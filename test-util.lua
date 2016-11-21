--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require ("util")
print("util.lua tests")

-- deepcompare is used in other tests, so test it first
print("TESTING: deepcompare")
local t1={}
assert(deepcompare(t1, t1),         "test failed: deepcompare same table")
assert(deepcompare({}, {}),         "test failed: deepcompare empty table")
assert(deepcompare({2}, {2}),       "test failed: deepcompare 1 element equal table")
assert(not deepcompare({2}, {3}),   "test failed: deepcompare 1 element equal table")
assert(deepcompare({a="foo", b="bar"}, {b="bar", a="foo"}), "test failed: deepcompare 1 element equal table")
assert(not deepcompare({a="foo", b="bar"}, {b="bar", a="baz"}), "test failed: deepcompare 1 element equal table")
assert(deepcompare({{}, {}}, {{}, {}}),         "test failed: deepcompare table of empty tables")
assert(not deepcompare({{}, {}}, {{}, {}, {}}),         "test failed: deepcompare different table of empty tables")
assert(deepcompare({{a=1, b=2}, {c=3, d=4}}, {{a=1, b=2}, {c=3, d=4}}), "test failed: deepcompare table of tables")
assert(not deepcompare({{a=1, b=2}, {c=3, d=4}}, {{a=1, b=2}, {c=3, d="foo"}}), "test failed: deepcompare table of different tables")


print("TESTING: isset")
assert(isset(nil) == nil, "test failed: nil")
assert(isset('no') == false, "test failed: no")
assert(isset('false') == false, "test failed: false")
assert(isset('yes'), "test failed: yes")
assert(isset('foo'), "test failed: foo")

print("TESTING: yesno")
assert(yesno(nil) == nil,           "test failed: yesno(nil) == nil")
assert(yesno('no') == 'false',      "test failed: yesno('no') == 'false'")
assert(yesno('false') == 'false',   "test failed: yesno('false') == 'false'")
assert(yesno('yes') == 'true',      "test failed: yesno('yes') == 'true'")
assert(yesno('foo') == 'true',      "test failed: yesno('foo') == 'true'")

print("TESTING: split_list")
assert(split_list(nil) == nil, "test failed: empty")
assert(split_list('1') == '{"1"}', "test failed: single element")
assert(split_list('1;2') == '{"1","2"}', "test failed: multi-element")
assert(split_list('a"b') == '{"a\\"b"}', "test failed: element with quote")
assert(split_list('a\\b') == '{"a\\\\b"}', "test failed: element with backslash")
assert(split_list('a"\195\188b"c') == '{"a\\"\195\188b\\"c"}', "test failed: unicode element with quote")

print("TESTING: hstore")
assert(hstore(nil) == nil, "test failed: nil")
assert(hstore({}) == '', "test failed: empty")
assert(hstore({foo='bar'}) == '"foo"=>"bar"', "test failed: single element")
local h1 = hstore({foo='bar', baz='2'}) -- pairs does not guarantee any order, so we have to check all
assert(h1 == '"foo"=>"bar","baz"=>"2"' or h1 == '"baz"=>"2","foo"=>"bar"', "test failed: two elements")
assert(hstore({['fo"o']='bar'}) == '"fo\\"o"=>"bar"', "test failed: quoted key")
assert(hstore({['fo\\o']='bar'}) == '"fo\\\\o"=>"bar"', "test failed: backslash key")
assert(hstore({foo='ba"r'}) == '"foo"=>"ba\\"r"', "test failed: quoted value")
assert(hstore({foo='ba\\r'}) == '"foo"=>"ba\\\\r"', "test failed: backslash value")
