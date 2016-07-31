--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require "building"
print("building.lua tests")

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
assert(transform_building({building="yes"}).building == "yes", "test failed: only building")
assert(transform_building({building="foo"}).building == "foo", "test failed: typed building")
assert(transform_building({railway="station"}).building == "railway_station", "test failed: railway=station")
assert(transform_building({railway="station", building="foo"}).building == "railway_station", "test failed: railway=station with building tag")
assert(transform_building({aeroway="terminal"}).building == "aeroway_terminal", "test failed: aeroway=terminal")
assert(transform_building({aeroway="terminal", building="foo"}).building == "aeroway_terminal", "test failed: aeroway=terminal with building tag")

assert(transform_building({name="foo"}).name == "foo", "test failed: name")
assert(transform_building({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
assert(transform_building({name="foo", bar="baz"}).name == "foo", "test failed: dropping other tags")
assert(transform_building({["building:levels"]="5"}).levels == "5", "test failed: levels")
assert(transform_building({["building:levels"]="2.5"}).levels == nil, "test failed: levels float")
assert(transform_building({["building:levels"]="bar"}).levels == nil, "test failed: levels text")
assert(transform_building({["building:levels"]="1e6"}).levels == nil, "test failed: levels number with text")
assert(transform_building({["building:levels"]="10000000000"}).levels == nil, "test failed: levels overflow")
assert(transform_building({["height"]="5"}).height == "5", "test failed: height")