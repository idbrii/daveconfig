#! /usr/bin/env python

# Move documentation from a README to a lua file. Roughly using
# [LDoc](https://github.com/lunarmodules/LDoc) format except where it's
# excessively verbose.

import itertools
import re


class Doc(object):

    def __init__(self, func_name):
        self.arg_types = []
        self.arg_lines = []
        self.cfg_types = []
        self.cfg_lines = []
        self.ret_types = []
        self.ret_lines = []
        self._func_name = func_name.strip()
        self._desc = []
        self._returns = ''
        self._example = []
        # Preserve original output to diff against original to see if we failed
        # to parse anything.
        self.orig = False

    def _convert_type(self, kind):
        # TODO: Does ldoc specify a type for "unknown"?
        if kind == '*':
            return 'any'
        # Convert type style to ldoc
        # ldoc-style table notation: table[number] -> {number}
        kind = re.sub(r'table\[([^\]]+)\]', r'{\1}', kind, count=10)
        kind = re.sub(r'table\[([^\]]+)\]', r'{\1}', kind, count=10)
        # Optional args: [number] -> ?number
        kind = re.sub(r'\[([^\]]+)\]', r'?\1', kind, count=10)
        # Specify class as type instead of table: table: World -> World
        # kind = re.sub(r'table: (\u\w*)', r'!\1', kind, count=1)
        # Prefix types with bang: boolean: -> !boolean:
        # Disabled because I don't want to use this if I can avoid it.
        # kind = re.sub(r'\l+: ', r'!\0', kind, count=1)
        return kind

    def _parse_param_line(self, line, arg_lines, arg_types):
        # * `xg` `(number)` - the world's x gravity component
        # * `world` `(table)` - the world object, containing ...
        # * `sleep=true` `(boolean)` - if the world's bodies ...
        # * `Collider` `(table)` - The created RectangleCollider
        m = re.match(r'\* `([^`]+)` `\(([^)]*)\)` - (.*)', line)
        if self.orig:
            if m:
                arg_lines.append(m.expand(r"* `\1` `(\2)` - \3").strip())
                arg_types.append(m.group(2).strip())
            else:
                m = re.match(r'\* `(\s*)` - (.*)', line)
                if m:
                    arg_lines.append(m.expand(r"* `\1` - \2").strip())
                    arg_types.append(m.group(2).strip())
        else:
            if m:
                kind = self._convert_type(m.group(2).strip())
                line = f"{kind}" + m.expand(r": \1 \3").strip()
                line = line.replace(r"...: ... ", "\n ... - ")
                arg_lines.append(line)
                arg_types.append(kind)
            else:
                m = re.match(r'\* `([^`]+)` - (.*)', line)
                if m:
                    kind = self._convert_type(m.group(1).strip())
                    line = f"{kind}" + m.expand(r": \2").strip()
                    arg_lines.append(line)
                    arg_types.append(kind)

    def add_arg_line(self, line):
        self._parse_param_line(line, self.arg_lines, self.arg_types)

    def add_cfg_line(self, line):
        self._parse_param_line(line, self.cfg_lines, self.cfg_types)

    def add_return_line(self, line):
        self._parse_param_line(line, self.ret_lines, self.ret_types)

    def format_args(self):
        ret = ', '.join(self.ret_types)
        if not ret:
            ret = 'nil'
        decl = f"{self._func_name}({', '.join(self.arg_types)}) -> {ret}"
        args = "\n".join(self.arg_lines)
        cfgs = "\n  ".join(self.cfg_lines)
        if cfgs:
            cfgs = "\n  "+ cfgs
        ret = "\nreturn: ".join([''] + self.ret_lines)
        if args and ret:
            ret = "\n\n" + ret
        return f"{decl}\n\n{args}{cfgs}{ret}"

    def tostring(self):
        desc = "".join([''] + self._desc)
        try:
            period = desc.index('.') + 1
            desc = desc[:period] +'\n'+ desc[period:].lstrip()
        except ValueError:
            pass

        example = "    ".join([''] + self._example)
        if example:
            # This might cause ldoc to say "cannot deduce @usage". Just remove
            # the colon on that case.
            example = "usage:\n"+ example.rstrip()

        text = f"{desc}\n{self.format_args()}\n{self._returns}\n{example}"
        def comment(text):
            had_content = True
            for line in text:
                if line:
                    had_content = True
                    yield '-- '+line
                    continue
                if had_content:
                    yield '--'
                had_content = False

        lines = '\n'.join(comment(text.split('\n')))
        text = '-' + lines + "\n"
        return text

    def orig_format_args(self):
        ret = ', '.join(self.ret_types)
        if not ret:
            ret = 'nil'
        args = "\n".join(self.arg_lines)
        cfgs = "\n".join(self.cfg_lines)
        ret = "\n".join([''] + self.ret_lines)
        if args:
            args = 'Arguments:\n\n' + args
        if cfgs:
            cfgs = '\n\nSettings:\n\n' + cfgs
        if ret:
            ret = '\nReturns:\n' + ret
        if args and ret:
            ret = "\n" + ret
        return f"\n{args}{cfgs}{ret}"

    def orig_tostring(self):
        desc = "".join([''] + self._desc)
        example = "".join([''] + self._example)
        decl = f"{self._func_name}()"
        return f"#### `:{decl}`\n\n{desc}\n{example}\n{self.orig_format_args()}\n{self._returns}\n---\n"

    def __str__(self):
        if self.orig:
            return self.orig_tostring()
        return self.tostring()


sections = [
    '####',
    '---',
    'Arguments',
    'Settings',
    'Returns',
    '```',
]


def is_section(line):
    return any(line.startswith(s) for s in sections)


def get_header(f):
    for line in f:
        if line.isspace():
            continue
        if line.startswith('####'):
            return line


def collect_section(f, expected_section, expected_terminator=None):
    # print('START:', expected_section)
    text = []
    for line in f:
        # print('|>', line)
        if line.isspace():
            continue
        if expected_section and line.startswith(expected_section):
            continue
        if expected_terminator and line.startswith(expected_terminator):
            break
        if is_section(line):
            # go back one line
            f = itertools.chain((line,), f)
            break
        text.append(line)
    # import pprint; pprint.pprint(['END:', expected_section, text])
    return text, f


def process(readme):
    with open(readme, 'r') as f:
        docs = {}
        while True:
            line = get_header(f)
            if not line:
                break
            func_name = re.sub(r"\W*(\w+)\(.*", r"\1", line)
            doc = Doc(func_name)
            doc._desc ,f = collect_section(f, None)
            doc._example ,f = collect_section(f, '```lua', '```')
            args ,f = collect_section(f, 'Arguments')
            for line in args:
                doc.add_arg_line(line)
            args ,f = collect_section(f, 'Settings')
            for line in args:
                doc.add_cfg_line(line)
            args ,f = collect_section(f, 'Returns')
            for line in args:
                doc.add_return_line(line)
            docs[doc._func_name] = doc
            # print('--------------------')
            # print(doc)
            # return
    return docs


def run(code_file, readme):
    docs = process(readme)

    text = []
    with open(code_file, 'r') as f:
        for line in f:
            if 'function' in line:
                for k, v in docs.items():
                    if k in line:
                        text.append(str(v))
            text.append(line)


    with open(code_file, 'w') as f:
        for line in text:
            f.write(line)


if __name__ == "__main__":
    run(
        code_file = 'C:/code/public-clones/love-windfield/windfield/init.lua',
        readme = 'C:/code/public-clones/love-windfield/README.md',
    )
