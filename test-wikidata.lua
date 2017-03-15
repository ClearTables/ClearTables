--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require "wikidata"
print("wikidata.lua tests")

print("TESTING: wikidata")
assert(wikidata(nil) == nil, "test failed: nil")
assert(wikidata("Q") == nil, "test failed: Q")
assert(wikidata("Q0") == nil, "test failed: Q0")
assert(wikidata("Q1") == "1", "test failed: Q1")
assert(wikidata("Q01") == nil, "test failed: Q01")
assert(wikidata("Q1X2") == nil, "test failed: invalid id")
assert(wikidata("Q-1234") == nil, "test failed: Q-1234")
assert(wikidata("Q1234") == "1234", "test failed: Q1234")
assert(wikidata("Q36893488147419103232") == nil, "test failed: Over length ID")

print("TESTING: accept_wikidata")
assert(not accept_wikidata({}), "test failed: untagged")
assert(not accept_wikidata({foo="bar"}), "test failed: other tags")
assert(accept_wikidata({wikidata="Q1234"}), "test failed: amenity=school")

print("TESTING: transform_wikidata")
assert(deepcompare(transform_wikidata({}), {}), "test failed: no tags")
assert(transform_wikidata({wikidata="Q1234"}).wikidata == "1234", "test failed: wikidata")
-- It shouldn't hit this test since it doesn't pass accept_wikidata above
assert(transform_wikidata({wikidata="Q1X2"}).wikidata == nil, "test failed: invalid wikidata")

print("TESTING: wikidata_line_rels")
assert(deepcompare(wikidata_line_rels({}, 0), 1, {}), "test failed: untagged")
assert(deepcompare(wikidata_line_rels({foo="bar"}, 1), 1, {}), "test failed: other tags")
assert(deepcompare(wikidata_line_rels({type="route", wikidata="Q1234"}, 2), 0,
    {type="route", wikidata="Q1234"}), "test failed: route rel")
assert(deepcompare(wikidata_line_rels({type="route",}, 1), 1, {}), "test failed: route rel without wikidata")
assert(deepcompare(wikidata_line_rels({type="multipolygon", wikidata="Q1234"}, 2), 1, {}), "test failed: MP with wikidata")

print("TESTING: wikidata_polygon_rels")

--- Check the output of wikidata_polygon_rels
-- Copied from test-generic.lua
-- @param filter Expected filter results
-- @param out_tags Expected tags return
-- @param in_tags Input tags
-- @param num_keys Input num_keys
local check_wikidata_polygon_rels = function (filter, out_tags, in_tags, num_keys)
    local actual_filter, actual_out_tags = wikidata_polygon_rels(in_tags, num_keys)

    if actual_filter ~= filter then
        print("filter mismatch")
        return false
    end
    if not deepcompare(actual_out_tags, out_tags) then
        print("out_tags mismatch")
        print("expected")
        for k, v in pairs(out_tags) do
            print(k, v)
        end
        print("actual")
        for k, v in pairs(actual_out_tags) do
            print(k, v)
        end
        return false
    end
    return true
end

assert(check_wikidata_polygon_rels(1, {}, {}, 0), "test failed: untagged relation")
assert(check_wikidata_polygon_rels(1, {}, {foo="bar"}, 1), "test failed: other tagged relation")
assert(check_wikidata_polygon_rels(0, {type="multipolygon"}, {type="multipolygon"}, 1), "test failed: untagged multipolygon")
assert(check_wikidata_polygon_rels(0, {type="multipolygon", foo="bar"}, {type="multipolygon", foo="bar"}, 2), "test failed: tagged multipolygon")
assert(check_wikidata_polygon_rels(0, {type="multipolygon", wikidata="Q1234"}, {type="boundary", wikidata="Q1234"}, 2), "test failed: boundary")
