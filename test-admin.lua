--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require "admin"
print("admin.lua tests")

print("TESTING: admin_level")
assert(admin_level(nil) == nil, "test failed: nil")
assert(admin_level("foo") == nil, "test failed: text")
assert(admin_level("0") == nil, "test failed: 0")
assert(admin_level("12") == nil, "test failed: 12")
assert(admin_level("1") == "1", "test failed: 1")
assert(admin_level("11") == "11", "test failed: 11")

print("TESTING: accept_admin_area")
assert(not accept_admin_area({}), "test failed: untagged")
assert(not accept_admin_area({foo="bar"}), "test failed: other tags")
assert(not accept_admin_area({boundary="administrative"}), "test failed: boundary=administrative no level")
assert(accept_admin_area({boundary="administrative", admin_level="5"}), "test failed: boundary=administrative admin_level=5")

print("TESTING: transform_admin_area")
assert(deepcompare(transform_admin_area({}), {}), "test failed: no tags")
assert(deepcompare(transform_admin_area({boundary="administrative"}), {}), "test failed: only boundary")
assert(transform_admin_area({boundary="administrative", admin_level="5"}).level == "5", "test failed: level")
assert(deepcompare(transform_admin_area({boundary="administrative", admin_level="5", name="foo"}), {level="5", name="foo"}), "test failed: level + name")
assert(deepcompare(transform_admin_area({boundary="administrative", admin_level="5", ["name:en"]="foo"}), {level="5", names='"en"=>"foo"'}), "test failed: level + name")
