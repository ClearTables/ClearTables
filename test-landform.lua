--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "landform"
print("landform.lua tests")

print("TESTING: accept_landform_point")
assert(not accept_landform_point({}), "test failed: untagged")
assert(not accept_landform_point({foo="bar"}), "test failed: other tags")
assert(accept_landform_point({natural="peak"}), "test failed: natural=peak")
assert(accept_landform_point({natural="saddle"}), "test failed: natural=saddle")
assert(accept_landform_point({natural="volcano"}), "test failed: natural=volcano")
assert(accept_landform_point({natural="cave_entrance"}), "test failed: natural=cave_entrance")
assert(accept_landform_point({natural="cliff"}), "test failed: natural=cliff")

print("TESTING: transform_landform_point")
assert(deepcompare(transform_landform_point({}), {}), "test failed: no tags")
assert(transform_landform_point({natural="peak"}).landform == "peak", "test failed: peak")
assert(transform_landform_point({natural="saddle"}).landform == "saddle", "test failed: saddle")
assert(transform_landform_point({natural="volcano"}).landform == "volcano", "test failed: volcano")
assert(transform_landform_point({natural="cave_entrance"}).landform == "cave_entrance", "test failed: cave_entrance")
assert(transform_landform_point({natural="cliff"}).landform == "rock_spire", "test failed: rock_spire")
assert(transform_landform_point({name="foo"}).name == "foo", "test failed: name")
assert(transform_landform_point({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
assert(transform_landform_point({["ele"]="5"}).elevation == "5", "test failed: ele")

print("TESTING: accept_landform_line")
assert(not accept_landform_line({}), "test failed: untagged")
assert(not accept_landform_line({foo="bar"}), "test failed: other tags")
assert(accept_landform_line({natural="cliff"}), "test failed: natural=cliff")
assert(accept_landform_line({natural="ridge"}), "test failed: natural=ridge")
assert(accept_landform_line({natural="arete"}), "test failed: natural=arete")
assert(accept_landform_line({man_made="embankment"}), "test failed: man_made=embankment")

print("TESTING: transform_landform_line")
assert(deepcompare(transform_landform_line({}), {}), "test failed: no tags")
assert(transform_landform_line({natural="cliff"}).landform == "cliff", "test failed: cliff")
assert(transform_landform_line({natural="ridge"}).landform == "ridge", "test failed: ridge")
assert(transform_landform_line({natural="arete"}).landform == "arete", "test failed: arete")
assert(transform_landform_line({man_made="embankment"}).landform == "embankment", "test failed: embankment")
assert(transform_landform_line({natural="cliff", man_made="embankment"}).landform == "cliff", "test failed: cliff+embankment")
assert(transform_landform_line({name="foo"}).name == "foo", "test failed: name")
assert(transform_landform_line({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
