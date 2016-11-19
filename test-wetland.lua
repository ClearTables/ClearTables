--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "wetland"
print("wetland.lua tests")

print("TESTING: accept_wetland_area")
assert(not accept_wetland_area({}), "test failed: untagged")
assert(not accept_wetland_area({foo="bar"}), "test failed: other tags")
assert(accept_wetland_area({natural="wetland"}), "test failed: natural=wetland")
assert(not accept_wetland_area({natural="foo"}), "test failed: other natural")

print("TESTING: transform_wetland_area")
assert(deepcompare(transform_wetland_area({}), {}), "test failed: no tags")
assert(transform_wetland_area({wetland="bog"}).wetland == "peat", "test failed: bog")
assert(transform_wetland_area({wetland="marsh"}).wetland == "open", "test failed: marsh")
assert(transform_wetland_area({wetland="swamp"}).wetland == "treed", "test failed: swamp")
assert(transform_wetland_area({wetland="reedbed"}).wetland == "open", "test failed: reedbed")
assert(transform_wetland_area({wetland="tidalflat"}).wetland == "salt", "test failed: tidalflat")
assert(transform_wetland_area({wetland="mangrove"}).wetland == "treed", "test failed: mangrove")
assert(transform_wetland_area({wetland="wet_meadow"}).wetland == "open", "test failed: wet_meadow")
assert(transform_wetland_area({wetland="saltmarsh"}).wetland == "salt", "test failed: saltmarsh")
assert(transform_wetland_area({wetland="string_bog"}).wetland == "peat", "test failed: string_bog")
assert(transform_wetland_area({wetland="saltern"}).wetland == "salt", "test failed: saltern")
assert(transform_wetland_area({wetland="fen"}).wetland == "peat", "test failed: fen")
assert(transform_wetland_area({name="foo"}).name == "foo", "test failed: name")
assert(transform_wetland_area({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
