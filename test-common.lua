--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015 Paul Norman, MIT license
]]--

require ("common")

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

print("TESTING: yesno")
assert(yesno(nil) == nil,           "test failed: yesno(nil) == nil")
assert(yesno('no') == 'false',      "test failed: yesno('no') == 'false'")
assert(yesno('false') == 'false',   "test failed: yesno('false') == 'false'")
assert(yesno('yes') == 'true',      "test failed: yesno('yes') == 'true'")
assert(yesno('foo') == 'true',      "test failed: yesno('foo') == 'true'")

print("TESTING: oneway")
assert(oneway(nil) == nil,          "test failed: oneway(nil) == nil")
assert(oneway('-1') == 'reverse',   "test failed: oneway('-1') == 'reverse'")
assert(oneway('no') == 'false',     "test failed: oneway('no') == 'false'")
assert(oneway('false') == 'false',  "test failed: oneway('false') == 'false'")
assert(oneway('yes') == 'true',     "test failed: oneway('yes') == 'true'")
assert(oneway('foo') == 'true',     "test failed: oneway('foo') == 'true'")

print("TESTING: speed")
assert(speed(nil) == nil,          "test failed: nil")
assert(speed("foo") == nil,        "test failed: foo")
assert(speed("70 foo") == nil,     "test failed: 70 foo")
assert(speed("70") == "70",        "test failed: 70")
assert(speed("-70") == nil,        "test failed: -70")
assert(speed("70.5") == "70.5",    "test failed: 70.5")
assert(speed("10 mph") == "16.09", "test failed: 10 mph")
assert(speed("10mph") == "16.09",  "test failed: 10mph")
assert(speed("12.5 mph") == "20.1125", "test failed: 10 mph")
assert(speed("12.5mph") == "20.1125",  "test failed: 10mph")
assert(speed("RO:urban") == "50",  "test failed: RO:urban")
assert(speed("80;100") == nil,  "test failed: 80;100")

print("TESTING: layer")
assert(layer(nil) == "0",           "test failed: nil")
assert(layer("0") == "0",           "test failed: 0")
assert(layer("-1") == "-1",         "test failed: -1")
assert(layer("1") == "1",           "test failed: 1")
assert(layer("1.5") == "0",           "test failed: 1.5")
assert(layer("foo") == "0",         "test failed: text")
assert(layer("f1") == "0",          "test failed: char num")
assert(layer("1f") == "0",          "test failed: num char")

print("TESTING: access")
assert(access(nil) == nil,          "test failed: nil")
assert(access("foo") == nil,        "test failed: unknown")
assert(access("yes") == "yes",      "test failed: yes")
assert(access("private") == "no",   "test failed: private")
assert(access("no") == "no",        "test failed: no")
assert(access("permissive") == "yes", "test failed: permissive")
assert(access("delivery") == "partial", "test failed: delivery")
assert(access("designated") == "yes", "test failed: designated")
assert(access("destination") == "partial", "test failed: destination")
assert(access("customers") == "partial", "test failed: customers")

print("TESTING: drop_all")
assert(deepcompare({drop_all()}, {1, {}}), "test failed: drop_all()")

print("TESTING: isarea")
-- Handling of area tag alone
assert(isarea({area = "yes"}),       "test failed: isarea(area=yes)")
assert(not isarea({area = "no"}),        "test failed: isarea(area=no)")
assert(not isarea({area = "foo"}),       "test failed: isarea(area=foo)")

-- Area tag overriding other tags
assert(not isarea({natural = "water", area = "no"}),  "test failed: isarea(natural=water,area=no)")
assert(isarea({natural = "water"}),  "test failed: isarea(natural=water)")

print("TESTING: split_list")
assert(split_list(nil) == nil, "test failed: single element")
assert(split_list('1') == '{"1"}', "test failed: single element")
assert(split_list('1;2') == '{"1","2"}', "test failed: multi-element")
assert(split_list('a"b') == '{"a\\"b"}', "test failed: element with quote")
assert(split_list('a"\195\188b"c') == '{"a\\"\195\188b\\"c"}', "test failed: unicode element with quote")

-- Utility functions for transform testing
local function acceptfoo(tags)
    return tags["foo"] ~= nil
end

local function identity(...)
    return ...
end

print("TESTING: generic_node")
local n1 = function (tags, cols, filter)
    return deepcompare({generic_node(tags, acceptfoo, identity)},
        {filter, cols })
end

assert(n1({}, {}, 1), "test failed: no tags")
assert(n1({baz="bar"}, {}, 1), "test failed: unaccepted node")
assert(n1({foo="bar"}, {foo="bar"}, 0), "test failed: accepted node")

print("TESTING: generic_line_way")
local l1 = function (tags, cols, filter, polygon)
    return deepcompare({generic_line_way(tags, acceptfoo, identity)},
        {filter, cols, polygon, 0})
end

assert(l1({}, {}, 1, 0), "test failed: no tags")
assert(l1({area="no"}, {}, 1, 0), "test failed: unaccepted line")
assert(l1({foo="bar"}, {foo="bar"}, 0, 0), "test failed: accepted line")
assert(l1({area="yes", foo="bar"}, {}, 1, 0), "test failed: accepted area")

print("TESTING: generic_polygon_way")
local p1 = function (tags, cols, filter, polygon)
    return deepcompare({generic_polygon_way(tags, acceptfoo, identity)},
        {filter, cols, polygon, 0})
end

assert(p1({}, {}, 1, 0), "test failed: no tags")
assert(p1({area="yes"}, {}, 1, 0), "test failed: unaccepted area")
assert(p1({area="yes", foo="bar"}, {area="yes", foo="bar"}, 0, 1), "test failed: accepted area")
assert(p1({area="no", foo="bar"}, {}, 1, 0), "test failed: accepted non-area")

print("TESTING: generic_multipolygon_members")
-- yay multipolygons?
-- generic_multipolygon_members is (tags, member_tags, membercount, accept, transform) -> (filter, cols, member_superseded, boundary, polygon, roads)

-- wraps generic_multipolygon_members so only stuff that changes need to be specified in the tests
local mp1 = function(tags, cols, filter, polygon)
    return deepcompare({generic_multipolygon_members(tags, {{}, {}}, 2, acceptfoo, identity)},
        {filter, cols, {0,0}, 0, polygon, 0})
end

assert(mp1({}, {}, 1, 0), "test failed: untagged relation")
assert(mp1({type="multipolygon"}, {}, 1, 1), "test failed: multipolygon with no tags")
assert(mp1({type="multipolygon", bar="baz"}, {}, 1, 1), "test failed: multipolygon with no tags of interest")
assert(mp1({type="multipolygon", foo="bar"}, {foo="bar"}, 0, 1), "test failed: multipolygon tag of interest")
