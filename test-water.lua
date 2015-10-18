--[[
  This file is part of ClearTables

  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman, MIT license
]]--

require "water"

print("TESTING: accept_water_area")
assert(not accept_water_area({}), "test failed: untagged")
assert(not accept_water_area({foo="bar"}), "test failed: other tags")
assert(accept_water_area({natural="water"}), "test failed: natural=water")
assert(accept_water_area({waterway="riverbank"}), "test failed: waterway=riverbank")
assert(accept_water_area({landuse="reservoir"}), "test failed: landuse=reservoir")

print("TESTING: transform_water_area")
assert(deepcompare(transform_water_area({}), {}), "test failed: no tags")
assert(deepcompare(transform_water_area({natural="water"}), {}), "test failed: only natural")
assert(deepcompare(transform_water_area({name="foo"}), {name="foo"}), "test failed: name")
assert(deepcompare(transform_water_area({name="foo", bar="baz"}), {name="foo"}), "test failed: dropping other tags")
assert(deepcompare(transform_water_area({water="foo"}), {water="foo"}), "test failed: water tag")
assert(deepcompare(transform_water_area({waterway="riverbank"}), {water="river"}), "test failed: waterway")
assert(deepcompare(transform_water_area({landuse="reservoir"}), {water="reservoir"}), "test failed: waterway")
assert(deepcompare(transform_water_area({water="foo", waterway="riverbank"}), {water="foo"}), "test failed: water tag with riverbank")
assert(deepcompare(transform_water_area({water="foo", landuse="reservoir"}), {water="foo"}), "test failed: water tag with riverbank")

print("TESTING: accept_waterway")
assert(not accept_waterway({}), "test failed: untagged")
assert(not accept_waterway({foo="bar"}), "test failed: other tags")
assert(accept_waterway({waterway="stream"}), "test failed: stream")
assert(accept_waterway({waterway="river"}), "test failed: river")
assert(accept_waterway({waterway="ditch"}), "test failed: ditch")
assert(accept_waterway({waterway="canal"}), "test failed: canal")
assert(accept_waterway({waterway="drain"}), "test failed: drain")

print("TESTING: transform_waterway")
assert(deepcompare(transform_waterway({}), {}), "test failed: no tags")
assert(deepcompare(transform_waterway({waterway="river"}), {waterway="river"}), "test failed: river")
