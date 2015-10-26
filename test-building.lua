--[[
  This file is part of ClearTables

  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman, MIT license
]]--

require "building"

print("TESTING: accept_building")
assert(not accept_building({}), "test failed: untagged")
assert(not accept_building({}), "test failed: untagged")
assert(not accept_building({foo="bar"}), "test failed: other tags")
assert(accept_building({building="yes"}), "test failed: building=yes")
assert(accept_building({building="foo"}), "test failed: building=foo")
assert(not accept_building({building="no"}), "test failed: building=no")
assert(accept_building({railway="station"}), "test failed: railway=station")
assert(not accept_building({railway="station", building="no"}), "test failed: railway=station building=no")
assert(accept_building({aeroway="terminal"}), "test failed: aeroway=terminal")
assert(not accept_building({aeroway="terminal", building="no"}), "test failed: aeroway=terminal building=no")

print("TESTING: transform_building")
assert(deepcompare(transform_building({}), {}), "test failed: no tags")
assert(deepcompare(transform_building({building="yes"}), {building="yes"}), "test failed: only building")
assert(deepcompare(transform_building({building="foo"}), {building="foo"}), "test failed: typed building")
assert(deepcompare(transform_building({railway="station"}), {building="railway_station"}), "test failed: railway=station")
assert(deepcompare(transform_building({railway="station", building="foo"}), {building="railway_station"}), "test failed: railway=station with building tag")
assert(deepcompare(transform_building({aeroway="terminal"}), {building="aeroway_terminal"}), "test failed: aeroway=terminal")
assert(deepcompare(transform_building({aeroway="terminal", building="foo"}), {building="aeroway_terminal"}), "test failed: aeroway=terminal with building tag")

assert(deepcompare(transform_building({name="foo"}), {name="foo"}), "test failed: name")
assert(deepcompare(transform_building({name="foo", bar="baz"}), {name="foo"}), "test failed: dropping other tags")
assert(deepcompare(transform_building({["building:levels"]="5"}), {levels="5"}), "test failed: levels")
assert(deepcompare(transform_building({["building:levels"]="2.5"}), {}), "test failed: levels float")
assert(deepcompare(transform_building({["building:levels"]="bar"}), {}), "test failed: levels text")
assert(deepcompare(transform_building({["building:levels"]="1e6"}), {}), "test failed: levels number with text")
assert(deepcompare(transform_building({["building:levels"]="10000000000"}), {}), "test failed: levels overflow")
assert(deepcompare(transform_building({["height"]="5"}), {["height"]="5"}), "test failed: height")
assert(deepcompare(transform_building({["height"]="56"}), {["height"]="56"}), "test failed: multi-digit height")
assert(deepcompare(transform_building({["height"]="foo"}), {}), "test failed: height text")
assert(deepcompare(transform_building({["height"]="5.5"}), {["height"]="5.5"}), "test failed: height fractional")
assert(deepcompare(transform_building({["height"]="10a5"}), {}), "test failed: height num char num")
assert(deepcompare(transform_building({["height"]="10000000000"}), {}), "test failed: height overflow")
