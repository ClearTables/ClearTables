--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "place"
print("place.lua tests")

print("TESTING: population")
assert(population(nil) == nil, "test failed: nil")
assert(population("0") == "0", "test failed: 0")
assert(population("-1") == nil, "test failed: -1")
assert(population("1") == "1", "test failed: 1")
assert(population("1.5") == nil, "test failed: 1.5")
assert(population("foo") == nil, "test failed: text")
assert(population("f1") == nil, "test failed: char num")
assert(population("1f") == nil, "test failed: num char")

print("TESTING: accept_place")
assert(not accept_place({}), "test failed: untagged")
assert(not accept_place({foo="bar"}), "test failed: other tags")
assert(accept_place({place="city"}), "test failed: city")
assert(accept_place({place="town"}), "test failed: town")
assert(accept_place({place="village"}), "test failed: village")
assert(accept_place({place="hamlet"}), "test failed: hamlet")
assert(accept_place({place="isolated_dwelling"}), "test failed: isolated_dwelling")
assert(accept_place({place="suburb"}), "test failed: suburb")
assert(accept_place({place="neighbourhood"}), "test failed: neighbourhood")
assert(accept_place({place="locality"}), "test failed: locality")
assert(accept_place({place="farm"}), "test failed: farm")
assert(not accept_place({place="foo"}), "test failed: other place")

print("TESTING: transform_place")
assert(deepcompare(transform_place({}), {}), "test failed: no tags")
assert(transform_place({name="foo"}).name == "foo", "test failed: name")
assert(transform_place({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
assert(transform_place({place="city"}).class == "settlement", "test failed: city class")
assert(transform_place({place="city"}).rank == "city", "test failed: city rank")
assert(transform_place({place="town"}).class == "settlement", "test failed: town class")
assert(transform_place({place="town"}).rank == "town", "test failed: town rank")
assert(transform_place({place="village"}).class == "settlement", "test failed: village class")
assert(transform_place({place="village"}).rank == "village", "test failed: village rank")
assert(transform_place({place="hamlet"}).class == "settlement", "test failed: hamlet class")
assert(transform_place({place="hamlet"}).rank == "hamlet", "test failed: hamlet rank")
assert(transform_place({place="isolated_dwelling"}).class == "settlement", "test failed: isolated_dwelling class")
assert(transform_place({place="isolated_dwelling"}).rank == "isolated_dwelling", "test failed: isolated_dwelling rank")
assert(transform_place({place="suburb"}).class == "subregion", "test failed: suburb class")
assert(transform_place({place="suburb"}).rank == "suburb", "test failed: suburb rank")
assert(transform_place({place="neighbourhood"}).class == "subregion", "test failed: neighbourhood class")
assert(transform_place({place="neighbourhood"}).rank == "neighbourhood", "test failed: neighbourhood rank")
assert(transform_place({place="locality"}).class == "locality", "test failed: locality")
assert(transform_place({place="farm"}).class == "farm", "test failed: farm")

assert(transform_place({place="city", population="100"}).population == "100", "test failed: population")
