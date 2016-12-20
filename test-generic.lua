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

-- Construct a function to be called by osm2pgsql with mock accept and transform

--- Mocked function for testing MP Handling
-- @param tags OSM tags
-- @param member_tags OSM tags of relation members
-- @param member_roles OSM roles of relation members
-- @param membercount number of members
-- @return filter, cols, member_superseded, boundary, polygon, roads
-- member_roles is not used, so nil can be passed in
local function foo_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, acceptfoo, identity)
end

assert(deepcompare({foo_rel_members({}, {}, nil, 0)},
                   {1, {}, {}, 0, 0, 0}), "test failed: untagged memberless relation")
assert(deepcompare({foo_rel_members({}, {{}}, nil, 1)},
                   {1, {}, {0}, 0, 0, 0}), "test failed: untagged relation")
assert(deepcompare({foo_rel_members({type="multipolygon", bar="baz"}, {{}}, nil, 1)},
                   {1, {}, {0}, 0, 1, 0}), "test failed: MP with other tags")

assert(deepcompare({foo_rel_members({type="multipolygon", foo="baz"}, {{}}, nil, 1)},
                   {0, {foo="baz"}, {0}, 0, 1, 0}), "test failed: MP with target tag")
assert(deepcompare({foo_rel_members({type="multipolygon", foo="baz"}, {{asdf="one"}}, nil, 1)},
                   {0, {foo="baz"}, {0}, 0, 1, 0}), "test failed: MP with target tag, way with different tags")
assert(deepcompare({foo_rel_members({type="multipolygon", foo="baz"}, {{foo="baz"}}, nil, 1)},
                   {0, {foo="baz"}, {0}, 0, 1, 0}), "test failed: MP with target tag, way with same tags")

assert(deepcompare({foo_rel_members({type="multipolygon", foo="baz", bar="qax"}, {{}}, nil, 1)},
                   {0, {foo="baz", bar="qax"}, {0}, 0, 1, 0}), "test failed: MP with target tag + others")
assert(deepcompare({foo_rel_members({type="multipolygon", foo="baz", bar="qax"}, {{asdf="one"}}, nil, 1)},
                   {0, {foo="baz", bar="qax"}, {0}, 0, 1, 0}), "test failed: MP with target tag + others, way with different tags")
assert(deepcompare({foo_rel_members({type="multipolygon", foo="baz", bar="qax"}, {{foo="baz"}}, nil, 1)},
                   {0, {foo="baz", bar="qax"}, {0}, 0, 1, 0}), "test failed: MP with target tag + others, way with same tags")

assert(deepcompare({foo_rel_members({type="multipolygon", foo="baz"}, {{}, {}}, nil, 2)},
                   {0, {foo="baz"}, {0, 0}, 0, 1, 0}), "test failed: MP with target tag, two ways")
assert(deepcompare({foo_rel_members({type="multipolygon", foo="baz"}, {{asdf="one"}, {asdf="one"}}, nil, 2)},
                   {0, {foo="baz"}, {0, 0}, 0, 1, 0}), "test failed: MP with target tag, ways with different tags from MP")
assert(deepcompare({foo_rel_members({type="multipolygon", foo="baz"}, {{asdf="one"}, {zxcv="two"}}, nil, 2)},
                   {0, {foo="baz"}, {0, 0}, 0, 1, 0}), "test failed: MP with target tag, ways with different and distinct tags from MP")
assert(deepcompare({foo_rel_members({type="multipolygon", foo="baz"}, {{foo="baz"}, {foo="baz"}}, nil, 2)},
                   {0, {foo="baz"}, {0, 0}, 0, 1, 0}), "test failed: MP with target tag, ways with same tags as MP")
