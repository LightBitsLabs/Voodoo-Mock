import sys
import re

filename = sys.argv[ 1 ]
testName = None
lineNumber = None

with open("blabla.txt", 'w') as fh:
    fh.write("args = %s" % sys.argv)

lines = open( filename ).readlines()

try:
    lineNumber = int( sys.argv[ 2 ] ) - 1
except ValueError:
    testName = sys.argv[ 2 ]

if lineNumber:
    assert lineNumber < len( lines ), "Line number must be inside file length"

maxLineNumberToCheck = lineNumber + 1 if lineNumber else len(lines)

PYTHON_TEST_METHOD_DEFINITION = re.compile( "\s+def\s+(test_\w+)\(" )
CPP_TEST_METHOD_DEFINITION = re.compile( "\s+void\s+(test_\w+)\(" )

for line in reversed( lines[ : maxLineNumberToCheck ] ):
    match = PYTHON_TEST_METHOD_DEFINITION.match( line )
    if match:
        if not testName or testName == match.group(1):
            print match.group( 1 )
            sys.exit( 0 )
    match = CPP_TEST_METHOD_DEFINITION.match( line )
    if match:
        if not testName or testName == match.group(1):
            print match.group( 1 )
            sys.exit( 0 )
print "POSITION IN FILE IS NOT INSIDE A TEST METHOD"
sys.exit( 1 )
