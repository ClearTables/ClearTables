--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require "address"
print("address.lua tests")

print("TESTING: accept_address")
assert(not accept_address({}), "test failed: untagged")
assert(not accept_address({foo="bar"}), "test failed: other tags")
assert(accept_address({["addr:unit"]="101"}), "test failed: unit")
assert(accept_address({["addr:housenumber"]="1a"}), "test failed: housenumber")
assert(accept_address({["addr:housename"]="foo"}), "test failed: housename")
assert(accept_address({["addr:street"]="Main Street"}), "test failed: street")

print("TESTING: transform_address")
assert(deepcompare(transform_address({}), {}), "test failed: no tags")
assert(transform_address({["addr:unit"]="101"}).unit == "101", "test failed: unit")
assert(transform_address({["addr:housenumber"]="1a"}).housenumber == "1a", "test failed: housenumber")
assert(transform_address({["addr:housename"]="foo"}).housename == "foo", "test failed: housename")
assert(transform_address({["addr:street"]="Main Street"}).street == "Main Street", "test failed: street")
assert(transform_address({["addr:suburb"]="foo"}).suburb == "foo", "test failed: suburb")
assert(transform_address({["addr:city"]="foo"}).city == "foo", "test failed: city")
