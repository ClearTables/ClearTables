--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "protected"
print("protected.lua tests")

print("TESTING: accept_protected_area")
assert(not accept_protected_area({}), "test failed: untagged")
assert(not accept_protected_area({foo="bar"}), "test failed: other tags")
assert(accept_protected_area({boundary="national_park"}), "test failed: boundary=national_park")
assert(not accept_protected_area({boundary="foo"}), "test failed: other boundary")

print("TESTING: transform_protected_area")
assert(deepcompare(transform_protected_area({}), {}), "test failed: no tags")
assert(transform_protected_area({boundary="national_park"}).class == "national_park", "test failed: boundary=national_park")
assert(transform_protected_area({leisure="nature_reserve"}).class == "nature_reserve", "test failed: leisure=nature_reserve")
assert(transform_protected_area({leisure="nature_reserve", boundary="foo"}).class == "nature_reserve", "test failed: leisure=nature_reserve with other boundary")
assert(transform_protected_area({name="foo"}).name == "foo", "test failed: name")
assert(transform_protected_area({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
