--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "wood"
print("wood.lua tests")

print("TESTING: accept_wood_area")
assert(not accept_wood_area({}), "test failed: untagged")
assert(not accept_wood_area({foo="bar"}), "test failed: other tags")
assert(accept_wood_area({natural="wood"}), "test failed: natural=wood")
assert(accept_wood_area({landuse="forest"}), "test failed: landuse=forest")
assert(not accept_wood_area({natural="foo"}), "test failed: other natural")
assert(not accept_wood_area({landuse="foo"}), "test failed: other landuse")

print("TESTING: transform_wood_area")
assert(deepcompare(transform_wood_area({}), {}), "test failed: no tags")
assert(transform_wood_area({name="foo"}).name == "foo", "test failed: name")
assert(transform_wood_area({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
