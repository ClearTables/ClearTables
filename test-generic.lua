--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require ("util")
require ("generic")
print("generic.lua tests")

print("TESTING: isarea")
-- Handling of area tag alone
assert(isarea({area = "yes"}),       "test failed: area=yes")
assert(not isarea({area = "no"}),        "test failed: area=no")
assert(not isarea({area = "foo"}),       "test failed: area=foo")
assert(not isarea({foo = "bar"}), "test failed: random tag")

-- Area tag overriding other tags
assert(not isarea({natural = "water", area = "no"}),  "test failed: area override unconditional keys")

-- Unconditional keys
assert(isarea({natural = "water"}),  "test failed: unconditional key")

-- polygon exception tags
assert(isarea({waterway = "riverbank"}), "test failed: waterway=riverbank")
assert(not isarea({waterway = "river"}), "test failed: waterway=river")


print("TESTING: drop_all")
assert(deepcompare({drop_all()}, {1, {}}), "test failed: drop_all()")

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
