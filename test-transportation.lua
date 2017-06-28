--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require "transportation"
print("transportation.lua tests")

print("TESTING: brunnel")
assert(brunnel({}) == nil, "test failed: nil")
assert(brunnel({bridge="yes"}) == "bridge", "test failed: bridge=yes")
assert(brunnel({bridge="no"}) == nil, "test failed: bridge=no")
assert(brunnel({tunnel="yes"}) == "tunnel", "test failed: tunnel=yes")
assert(brunnel({tunnel="no"}) == nil, "test failed: tunnel=no")
assert(brunnel({bridge="yes", tunnel="yes"}) == "bridge", "test failed: tunnel+bridge")

print("TESTING: lanes")
assert(lanes(nil) == nil,           "test failed: nil")
assert(lanes("0") == nil,           "test failed: 0")
assert(lanes("-1") == nil,          "test failed: -1")
assert(lanes("1") == "1",           "test failed: 1")
assert(lanes("1.5") == nil,         "test failed: 1.5")
assert(lanes("foo") == nil,         "test failed: text")
assert(lanes("f1") == nil,          "test failed: char num")
assert(lanes("1f") == nil,          "test failed: num char")

print("TESTING: speed")
assert(speed(nil) == nil, "test failed: nil")
assert(speed("foo") == nil, "test failed: foo")
assert(speed("70 foo") == nil, "test failed: 70 foo")
assert(speed("70") == "70", "test failed: 70")
assert(speed("-70") == nil, "test failed: -70")
assert(speed("70.5") == "70.5", "test failed: 70.5")
assert(speed("1234") == nil, "test failed: out of range")
assert(speed("10 mph") == "16.09", "test failed: mph with space")
assert(speed("10mph") == "16.09", "test failed: mph without space")
assert(speed("12.5 mph") == "20.1125", "test failed: decimal mph with space")
assert(speed("12.5mph") == "20.1125", "test failed: decimal mph without space")
assert(speed("12a5 mph") == nil, "test failed: mph with letter instead of decimal")
assert(speed("10mph0") == nil, "test failed: mph in middle")
assert(speed("RO:urban") == "50", "test failed: RO:urban")
assert(speed("80;100") == nil, "test failed: 80;100")

print("TESTING: accept_road")
assert(not accept_road({}), "test failed: untagged")
assert(not accept_road({foo="bar"}), "test failed: other tags")
assert(not accept_road({highway="bar"}), "test failed: other highway tag")
-- Test one non-ramp, unknown, and ramp
assert(accept_road({highway="motorway"}), "test failed: motorway")
assert(accept_road({highway="residential"}), "test failed: residential")
assert(accept_road({highway="motorway_link"}), "test failed: motorway_link")

print("TESTING: accept_road_area")
assert(not accept_road_area({}), "test failed: untagged")
assert(not accept_road_area({foo="bar"}), "test failed: other tags")
assert(not accept_road_area({highway="bar"}), "test failed: other highway tag")
assert(not accept_road_area({highway="motorway"}), "test failed: motorway")
assert(not accept_road_area({highway="motorway_link"}), "test failed: motorway_link")
assert(accept_road_area({highway="residential"}), "test failed: residential")
assert(accept_road_area({highway="unclassified"}), "test failed: unclassified")
assert(accept_road_area({highway="pedestrian"}), "test failed: pedestrian")
assert(accept_road_area({highway="service"}), "test failed: service")
assert(accept_road_area({highway="footway"}), "test failed: footway")
assert(accept_road_area({highway="cycleway"}), "test failed: cycleway")
assert(accept_road_area({highway="track"}), "test failed: track")
assert(accept_road_area({highway="path"}), "test failed: path")

print("TESTING: accept_rail")
assert(not accept_rail({}), "test failed: untagged")
assert(not accept_rail({foo="bar"}), "test failed: other tags")
assert(not accept_rail({railway="bar"}), "test failed: other railway tag")
assert(accept_rail({railway="rail"}), "test failed: rail")

print("TESTING: transform_road")
assert(deepcompare(transform_road({}), {}), "test failed: no tags")
assert(deepcompare(transform_road({name="foo"}), {name="foo"}), "test failed: name")
assert(deepcompare(transform_road({["name:en"]="foo"}), {names='"en"=>"foo"'}), "test failed: names")

assert(deepcompare(transform_road({ref="a;b"}), {refs='{"a","b"}'}), "test failed: ref")

assert(transform_road({highway="motorway", maxspeed="80"}).maxspeed == "80", "test failed: maxspeed")

assert(transform_road({highway="motorway"}).class == "motorway", "test failed: motorway class")
assert(transform_road({highway="motorway_link"}).class == "motorway", "test failed: motorway_link class")
assert(transform_road({highway="road"}).class == "unknown", "test failed: road class")
assert(transform_road({highway="pedestrian"}).class == "path", "test failed: pedestrian class")

assert(transform_road({highway="motorway"}).ramp == "false", "test failed: motorway ramp")
assert(transform_road({highway="motorway_link"}).ramp == "true", "test failed: motorway_link ramp")
assert(transform_road({highway="road"}).ramp == nil, "test failed: road ramp")
assert(transform_road({highway="pedestrian"}).ramp == nil, "test failed: pedestrian ramp")

assert(transform_road({highway="residential", motor_vehicle="yes"}).motor_access == "yes", "test failed: residential motor motor_vehicle yes")
assert(transform_road({highway="residential", motor_vehicle="no"}).motor_access == "no", "test failed: residential motor motor_vehicle no")
assert(transform_road({highway="residential", vehicle="yes"}).motor_access == "yes", "test failed: residential motor motor_vehicle yes")
assert(transform_road({highway="residential", vehicle="no"}).motor_access == "no", "test failed: residential motor motor_vehicle no")
assert(transform_road({highway="residential", access="yes"}).motor_access == "yes", "test failed: residential motor access yes")
assert(transform_road({highway="residential", access="no"}).motor_access == "no", "test failed: residential motor access no")

assert(transform_road({highway="residential", bicycle="yes"}).bicycle_access == "yes", "test failed: residential bicycle bicycle_access yes")
assert(transform_road({highway="residential", bicycle="no"}).bicycle_access == "no", "test failed: residential bicycle bicycle_access no")
assert(transform_road({highway="residential", vehicle="yes"}).bicycle_access == "yes", "test failed: residential bicycle bicycle_access yes")
assert(transform_road({highway="residential", vehicle="no"}).bicycle_access == "no", "test failed: residential bicycle bicycle_access no")
assert(transform_road({highway="residential", access="yes"}).bicycle_access == "yes", "test failed: residential bicycle bicycle_access yes")
assert(transform_road({highway="residential", access="no"}).bicycle_access == "no", "test failed: residential bicycle bicycle_access no")

assert(transform_road({highway="residential", bridge="yes"}).brunnel == "bridge", "test failed: bridge")
assert(transform_road({highway="residential", tunnel="yes"}).brunnel == "tunnel", "test failed: tunnel")
assert(transform_road({highway="residential", bridge="yes", tunnel="yes"}).brunnel == "bridge", "test failed: bridge+tunnel")

assert(transform_road({highway="residential"}).layer == "0", "test failed: layer 0")
assert(transform_road({highway="residential", layer="4"}).layer == "4", "test failed: layer 4")

assert(transform_road({highway="residential", oneway="yes"}).oneway == "true", "test failed: residential oneway=yes")
assert(transform_road({highway="residential", oneway="no"}).oneway == "false", "test failed: residential oneway=no")
assert(transform_road({highway="residential", oneway="-1"}).oneway == "reverse", "test failed: residential oneway=-1")
assert(transform_road({highway="residential"}).oneway == nil, "test failed: residential no oneway")

assert(transform_road({highway="motorway_link", oneway="yes"}).oneway == "true", "test failed: motorway_link oneway=yes")
assert(transform_road({highway="motorway_link", oneway="no"}).oneway == "false", "test failed: motorway_link oneway=no")
assert(transform_road({highway="motorway_link", oneway="-1"}).oneway == "reverse", "test failed: motorway_link oneway=-1")
assert(transform_road({highway="motorway_link"}).oneway == "true", "test failed: motorway_link no oneway")

assert(transform_road({highway="residential", junction="roundabout", oneway="yes"}).oneway == "true", "test failed: junction oneway=yes")
assert(transform_road({highway="residential", junction="roundabout", oneway="no"}).oneway == "false", "test failed: junction oneway=no")
assert(transform_road({highway="residential", junction="roundabout", oneway="-1"}).oneway == "reverse", "test failed: junction oneway=-1")
assert(transform_road({highway="residential", junction="roundabout"}).oneway == "true", "test failed: junction no oneway")

print("TESTING: accept_road_point")
assert(not accept_road_point({}), "test failed: untagged")
assert(not accept_road_point({foo="bar"}), "test failed: other tags")
assert(not accept_road_point({highway="bar"}), "test failed: other highway tag")
assert(accept_road_point({highway="crossing"}), "test failed: crossing")
assert(accept_road_point({highway="traffic_signals"}), "test failed: traffic_signals")
assert(accept_road_point({highway="motorway_junction"}), "test failed: motorway_junction")

print("TESTING: transform_road_point")
assert(deepcompare(transform_road_point({}), {}), "test failed: no tags")
assert(transform_road_point({name="foo"}).name == "foo", "test failed: name")
assert(transform_road_point({["name:en"]="foo"}), {names='"en"=>"foo"'}, "test failed: names")
assert(transform_road_point({ref="A1"}).ref == "A1", "test failed: ref")
assert(transform_road_point({highway="crossing"}).type == "crossing", "test failed: highway")

print("TESTING: transform_rail")
assert(deepcompare(transform_rail({}), {}), "test failed: no tags")
assert(transform_rail({name="foo"}).name == "foo", "test failed: name")
assert(transform_rail({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
assert(transform_rail({railway="subway"}).class == "transit", "test failed: subway class")

assert(transform_rail({railway="rail"}).service == nil, "test failed: no service")
assert(transform_rail({railway="rail", service="spur"}).service == "spur", "test failed: spur")
assert(transform_rail({railway="rail", service="siding"}).service == "siding", "test failed: siding")
assert(transform_rail({railway="rail", service="yard"}).service == "yard", "test failed: yard")
assert(transform_rail({railway="rail", service="crossover"}).service == "crossover", "test failed: crossover")

assert(transform_rail({railway="rail", bridge="yes"}).brunnel == "bridge", "test failed: bridge")
assert(transform_rail({railway="rail", tunnel="yes"}).brunnel == "tunnel", "test failed: tunnel")
assert(transform_rail({railway="rail", bridge="yes", tunnel="yes"}).brunnel == "bridge", "test failed: bridge+tunnel")
