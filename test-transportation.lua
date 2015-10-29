--[[
  This file is part of ClearTables

  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman, MIT license
]]--

require "transportation"

print("TESTING: accept_road")
assert(not accept_road({}), "test failed: untagged")
assert(not accept_road({foo="bar"}), "test failed: other tags")
assert(not accept_road({highway="bar"}), "test failed: other highway tag")
-- Test one non-ramp, unknown, and ramp
assert(accept_road({highway="motorway"}), "test failed: motorway")
assert(accept_road({highway="residential"}), "test failed: residential")
assert(accept_road({highway="motorway_link"}), "test failed: motorway_link")
assert(not accept_road({railway="bar"}), "test failed: other railway tag")
assert(accept_road({railway="rail"}), "test failed: rail")

print("TESTING: transform_road")
assert(deepcompare(transform_road({}), {}), "test failed: no tags")
assert(deepcompare(transform_road({name="foo"}), {name="foo"}), "test failed: name")

assert(deepcompare(transform_road({ref="a;b"}), {refs='{"a","b"}'}), "test failed: ref")

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

assert(transform_road({highway="residential"}).layer == "0", "test failed: layer 0")
assert(transform_road({highway="residential", layer="4"}).layer == "4", "test failed: layer 4")

-- check that layer is the most significant. we can do that without hard-coding
-- z_order values by comparing two different layers, in effect reproducing the
-- ORDER BY used in rendering
assert(tonumber(transform_road({highway="residential", layer="3"}).z_order) >
        tonumber(transform_road({highway="residential", layer="2"}).z_order), "test failed: residential layer z_order")
assert(tonumber(transform_road({highway="residential", tunnel="yes", layer="3"}).z_order) >
        tonumber(transform_road({highway="motorway", layer="2", bridge="yes"}).z_order), "test failed: residential/motorway layer z_order")

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
