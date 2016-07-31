--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "landform"
print("landform.lua tests")

print("TESTING: accept_landform")
assert(not accept_landform({}), "test failed: untagged")
assert(not accept_landform({foo="bar"}), "test failed: other tags")
assert(accept_landform({natural="peak"}), "test failed: natural=peak")
assert(accept_landform({natural="saddle"}), "test failed: natural=saddle")
assert(accept_landform({natural="volcano"}), "test failed: natural=volcano")
assert(accept_landform({natural="cave_entrance"}), "test failed: natural=cave_entrance")

print("TESTING: transform_landform")
assert(deepcompare(transform_landform({}), {}), "test failed: no tags")
assert(transform_landform({natural="peak"}).landform == "peak", "test failed: peak")
assert(transform_landform({name="foo"}).name == "foo", "test failed: name")
assert(transform_landform({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
assert(transform_landform({["ele"]="5"}).elevation == "5", "test failed: ele")
