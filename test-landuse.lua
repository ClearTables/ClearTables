--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2017 Paul Norman, MIT license
]]--

require "landuse"
print("landuse.lua tests")

print("TESTING: accept_landuse")
assert(not accept_landuse({}), "test failed: untagged")
assert(not accept_landuse({foo="bar"}), "test failed: other tags")
assert(accept_landuse({landuse="residential"}), "test failed: landuse=residential")
assert(accept_landuse({landuse="commercial"}), "test failed: landuse=commercial")
assert(accept_landuse({landuse="retail"}), "test failed: landuse=retail")
assert(accept_landuse({landuse="industrial"}), "test failed: landuse=industrial")
assert(accept_landuse({landuse="railway"}), "test failed: landuse=railway")
assert(accept_landuse({landuse="farmland"}), "test failed: landuse=farmland")
assert(accept_landuse({landuse="farmyard"}), "test failed: landuse=residential")
assert(accept_landuse({landuse="allotments"}), "test failed: landuse=allotments")
assert(accept_landuse({landuse="cemetery"}), "test failed: landuse=cemetery")
assert(not accept_landuse({landuse="foo"}), "test failed: other landuse")

print("TESTING: transform_landuse")
assert(deepcompare(transform_landuse({}), {}), "test failed: no tags")
assert(transform_landuse({landuse="residential"}).landuse == "residential", "test failed: residential")
assert(transform_landuse({name="foo"}).name == "foo", "test failed: name")
assert(transform_landuse({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
