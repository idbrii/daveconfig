#! /usr/bin/env python3

import sys
import xml.dom.minidom

doc = sys.stdin
pretty = xml.dom.minidom.parse(doc).toprettyxml()
print(pretty)
