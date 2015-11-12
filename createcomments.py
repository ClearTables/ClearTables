#!/usr/bin/env python2

import sys, yaml, re

def safe_name(name):
    return re.match('''^[a-zA-Z0-9_ ]+$''', name)

def safe_comment(comment):
    # This is a slightly less restrictive character set, but the only one that needs escaping is '
    return re.match('''^[-a-zA-Z0-9_ ()"!,/.']+$''', comment)

def escape_comment(comment):
    return comment.replace("'", "''")
definitions = yaml.safe_load(sys.stdin)

# Doesn't matter on newer versions, but prevents the use of \ in normal string literals
print("SET standard_conforming_strings = TRUE;");

for table in definitions:
    # This requires all tables to be reasonably named
    if not safe_name(table["name"]):
        sys.exit("Unsafe table name: " + table["name"])

    if "comment" in table:
        if not safe_comment(table["comment"]):
            sys.exit('''Unsafe table comment for "''' + table["name"] +'''"''')

        print('''COMMENT ON TABLE "{}" IS '{}';'''.format(
            table["name"], escape_comment(table["comment"])))
    for column in table["tags"]:
        # Only check columns that have a comment
        if "comment" in column and column["comment"] is not None:
            if not safe_name(column["name"]):
                sys.exit('''Unsafe column name in table "''' + table["name"] + '''"."''' + column["name"] + '''"''')
            if not safe_comment(column["comment"]):
                sys.exit('''Unsafe column comment for "''' + table["name"] +'''"."''' + column["name"] + '''"''')
            print('''COMMENT ON COLUMN "{}"."{}" IS '{}';'''.format(
                table["name"], column["name"], escape_comment(column["comment"])))
