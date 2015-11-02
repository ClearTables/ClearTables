#!/usr/bin/env python2

import sys, yaml, re

definitions = yaml.safe_load(sys.stdin)

# Doesn't matter on newer versions, but prevents the use of \ in normal string literals
print ("SET standard_conforming_strings = TRUE;");

# Do everything in one transaction so we don't get some comments but not others
print ("BEGIN;");

for table in definitions:
    # This requires all tables to be reasonably named
    if not re.match('''^[a-zA-Z0-9_ ]+$''', table["name"]):
        sys.exit("Unsafe table name: " + table["name"])

    for column in table["tags"]:
        # Only check columns that have a comment
        if "comment" in column and column["comment"] is not None:
            if not re.match('''^[a-zA-Z0-9_ ]+$''', column["name"]):
                sys.exit('''Unsafe column name in table "''' + table["name"] + '''"."''' + column["name"] + '''"''')

            # This is a slightly less restrictive character set, but the only one that needs escaping is '
            if not re.match('''^[a-zA-Z0-9_ ()"!.']+$''', column["comment"]):
                sys.exit('''Unsafe column comment for "''' + table["name"] +'''"."''' + column["name"] + '''"''')
            print ('''COMMENT ON COLUMN "{}"."{}" IS '{}';'''.format(
                table["name"], column["name"], column["comment"].replace("'", "''")))

print ("COMMIT;");
