--[[
  This file is part of ClearTables

  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman, MIT license
]]--

require ("common")

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


assert(yesno(nil) == nil,           "test failed: yesno(nil) == nil")
assert(yesno('no') == 'false',      "test failed: yesno('no') == 'false'")
assert(yesno('false') == 'false',   "test failed: yesno('false') == 'false'")
assert(yesno('yes') == 'true',      "test failed: yesno('yes') == 'true'")
assert(yesno('foo') == 'true',      "test failed: yesno('foo') == 'true'")

assert(oneway(nil) == nil,          "test failed: oneway(nil) == nil")
assert(oneway('-1') == 'reverse',   "test failed: oneway('-1') == 'reverse'")
assert(oneway('no') == 'false',     "test failed: oneway('no') == 'false'")
assert(oneway('false') == 'false',  "test failed: oneway('false') == 'false'")
assert(oneway('yes') == 'true',     "test failed: oneway('yes') == 'true'")
assert(oneway('foo') == 'true',     "test failed: oneway('foo') == 'true'")

assert(deepcompare({drop_all()}, {1, {}}), "test failed: drop_all()")

-- Handling of area tag alone
assert(isarea({area = "yes"}) == 1,       "test failed: isarea(area=yes)")
assert(isarea({area = "no"}) == 0,        "test failed: isarea(area=no)")
assert(isarea({area = "foo"}) == 0,       "test failed: isarea(area=foo)")

-- Area tag overriding other tags
assert(isarea({natural = "water", area = "no"}) == 0,  "test failed: isarea(natural=water,area=no)")
assert(isarea({natural = "water"}) == 1,  "test failed: isarea(natural=water)")

-- Utility functions for transform testing
local function acceptfoo(tags)
    return tags["foo"] ~= nil
end

local function identity(...)
    return ...
end

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
