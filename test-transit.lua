--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2017 Paul Norman, MIT license
]]--

require "transit"
print("transit.lua tests")

print("TESTING: accept_transit")
assert(not accept_transit({}), "test failed: untagged")
assert(not accept_transit({foo="bar"}), "test failed: other tags")
assert(accept_transit({highway="bus_stop"}), "test failed: bus stop")
assert(accept_transit({amenity="bus_station"}), "test failed: bus station")
assert(accept_transit({railway="station"}), "test failed: railway station")
assert(accept_transit({railway="halt"}), "test failed: railway halt")
assert(accept_transit({amenity="ferry_terminal"}), "test failed: ferry terminal")
assert(accept_transit({amenity="taxi"}), "test failed: taxi stand")

print("TESTING: transform_transit")
assert(deepcompare(transform_transit({}), {}), "test failed: no tags")
assert(transform_transit({name="foo"}).name == "foo", "test failed: name")
assert(transform_transit({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
assert(transform_transit({highway="bus_stop"}).transit_mode == "bus", "test failed: bus_stop mode")
assert(transform_transit({highway="bus_stop"}).station == "false", "test failed: bus_stop station")
assert(transform_transit({amenity="bus_station"}).transit_mode == "bus", "test failed: bus_station mode")
assert(transform_transit({amenity="bus_station"}).station == "true", "test failed: bus_station station")
assert(transform_transit({railway="halt"}).transit_mode == "rail", "test failed: railway halt mode")
assert(transform_transit({railway="halt"}).station == "false", "test failed: railway halt station")
assert(transform_transit({railway="tram_stop"}).transit_mode == "tram", "test failed: tram stop mode")
assert(transform_transit({railway="tram_stop"}).station == "false", "test failed: tram stop station")
assert(transform_transit({railway="station"}).transit_mode == "rail", "test failed: railway station mode")
assert(transform_transit({railway="station"}).station == "true", "test failed: railway station station")
assert(transform_transit({amenity="ferry_terminal"}).transit_mode == "ferry", "test failed: ferry terminal mode")
assert(transform_transit({amenity="ferry_terminal"}).station == "true", "test failed: ferry terminal station")
assert(transform_transit({amenity="taxi"}).transit_mode == "taxi", "test failed: taxi stand mode")
assert(transform_transit({amenity="taxi"}).station == "false", "test failed: taxi stand station")
