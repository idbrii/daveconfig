#! /usr/bin/env python

def reload_module(module, fpath):
    '''Reload a python module.

    Useful when writing vimplugins in python. Works even when importing with
    `import modu as m`.
    '''
    import importlib.machinery
    loader = importlib.machinery.SourceFileLoader(module, fpath)
    handle = loader.load_module()
    print(handle)

