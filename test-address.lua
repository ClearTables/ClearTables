--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015 Paul Norman, MIT license
]]--

require "address"

print("TESTING: accept_address")
assert(not accept_address({}), "test failed: untagged")
assert(not accept_address({foo="bar"}), "test failed: other tags")
assert(accept_address({["addr:unit"]="101"}), "test failed: unit")
assert(accept_address({["addr:housenumber"]="1a"}), "test failed: housenumber")
assert(accept_address({["addr:housename"]="foo"}), "test failed: housename")
assert(accept_address({["addr:street"]="Main Street"}), "test failed: street")

print("TESTING: transform_address")
assert(deepcompare(transform_address({}), {}), "test failed: no tags")
assert(deepcompare(transform_address({["addr:unit"]="101"}), {unit="101"}), "test failed: unit")
assert(deepcompare(transform_address({["addr:housenumber"]="1a"}), {housenumber="1a"}), "test failed: housenumber")
assert(deepcompare(transform_address({["addr:housename"]="foo"}), {housename="foo"}), "test failed: housename")
assert(deepcompare(transform_address({["addr:street"]="Main Street"}), {street="Main Street"}), "test failed: street")
assert(deepcompare(transform_address({["addr:suburb"]="foo"}), {suburb="foo"}), "test failed: suburb")
assert(deepcompare(transform_address({["addr:city"]="foo"}), {city="foo"}), "test failed: city")
