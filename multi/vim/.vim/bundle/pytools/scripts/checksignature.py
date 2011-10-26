import re
import sys
import os

'''
You can use checksignature to verify that the signatures of your base classes
match your parent class.

The following example searches the io directory (not recursive) for any classes
that inherit from BaseMessage or BaseConsumer and checks for correct use of
their respective Start and End methods. (Of course, the methods could be
anything.)

NOTE: Does not check return value!

You can run the checker from vim with something like this:

check_signature.vim

    " Load python objects (should probably do this only once
    if exists("loaded_checksignature_py")
        let loaded_checksignature_py = 1
        pyfile ~/.vim/bundle/pytools/scripts/checksignature.py

        python << EOF
c = Checker()
c.add_signature("BaseMessage", "Start( GenericSocket const * owner, SimpleObject * obj ) const")
c.add_signature("BaseMessage", "End( GenericSocket const * owner, SimpleObject * obj ) const")
c.add_signature("BaseConsumer", "Start( SimpleObject * obj ) const")
c.add_signature("BaseConsumer", "End( SimpleObject * obj ) const")
EOF
    endif

	" Runs the checker. Generates a temp file to stuff the output into.
	let temp_file = tempname()
	execute 'py c.set_output_file("' . temp_file . '")'
	py c.check_files_for_signatures("C:/lib/io/")
	py c.close_output_file()
	set efm=%f:%l(%c)%m
	exec "cfile " . temp_file
'''


class Signature(object):
    '''Represents the signature of a method.

    Contains information that we can use to check whether other method
    signatures match this method.
    '''
    def __init__(self, parent, method):
        self.parent_check = re.compile("public " + parent + r"\b")
        self.name = method[:method.index('(')]
        self.name_check = re.compile(r"\b" + self.name + r"\b")
        self.method = method.replace(' ', '')

    def _get_missing_word(self, index):
        return re.match('\w*', self.method[index:]).group(0)

    def check(self, line):
        # initialize indices
        self.i = 0
        name_index = line.index(self.name)

        for partial_index, c in enumerate(line[name_index:]):
            i = name_index + partial_index
            if c.isspace():
                # ignore spaces
                continue

            if c in '{;':
                # completed the signature
                break

            try:
                if c != self.method[self.i]:
                    # mismatch
                    msg = 'expected: ' + self._get_missing_word(self.i)
                    return i, msg
            except IndexError:
                msg = 'unexpected: "%s"' % line[i:]
                return i, msg

            # otherwise, increment
            self.i += 1

        if self.i < len(self.method):
            # missing some content (likely a const)
            msg = 'expected: ' + self._get_missing_word(self.i)
            return i, msg

        #print >> self.out, self.method[self.i:]
        #print >> self.out, line[i:]
        return -1, ''

class Checker:
    '''Collect method signatures and check files for compliance.

    Useful when pure virtual functions aren't an option (eg, generated code).
    Will check that you're using the right parameters (it's often easy to
    forget the const).
    '''
    def __init__(self):
        self.members = []
        self.out = sys.stdout

    def set_output_file(self, outfile):
        self.out = open(outfile, 'w')

    def close_output_file(self):
        self.out.close()
        self.out = sys.stdout

    def add_signature(self, parent, method):
        self.members.append( Signature(parent, method) )

    def _check_file_for_signatures(self, fname):
        for sig in self.members:
            inherits = False
            for line_num, line in enumerate(open(fname, 'r')):
                line = line.rstrip()

                if sig.parent_check.search(line) is not None:
                    inherits = True

                if sig.name_check.search(line):
                    if not inherits:
                        # Class doesn't inherit from our parent, so methods may be
                        # unrelated. Skip it.
                        # BUG: if the inheritance is indirect, this won't work.
                        continue

                    col, msg = sig.check(line)
                    if col >= 0:
                        # found an error
                        print >> self.out, '%s:%d(%d) %s Signature mis-match. %s' % (fname, line_num+1, col+1, sig.name, msg)
                        print >> self.out, line
                        print >> self.out, ' '* col + '^'

    def check_files_for_signatures(self, dir_to_check):
        dirpath, dirnames, filenames = os.walk(dir_to_check).next()
        for fname in filenames:
            fname = os.path.join(dirpath, fname)
            if not fname.endswith('.h'):
                continue

            self._check_file_for_signatures(fname)

