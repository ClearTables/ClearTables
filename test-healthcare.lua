--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2017 Paul Norman, MIT license
]]--

require "healthcare"
print("healthcare.lua tests")

print("TESTING: accept_healthcare")
assert(not accept_healthcare({}), "test failed: untagged")
assert(not accept_healthcare({foo="bar"}), "test failed: other tags")
assert(accept_healthcare({amenity="hospital"}), "test failed: amenity=hospital")
assert(accept_healthcare({amenity="doctors"}), "test failed: amenity=dentist")
assert(accept_healthcare({amenity="dentist"}), "test failed: amenity=dentist")
assert(accept_healthcare({amenity="clinic"}), "test failed: amenity=clinic")
assert(not accept_healthcare({amenity="foo"}), "test failed: other amenity")

print("TESTING: transform_healthcare")
assert(deepcompare(transform_healthcare({}), {}), "test failed: no tags")
assert(transform_healthcare({name="foo"}).name == "foo", "test failed: name")
assert(transform_healthcare({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
assert(transform_healthcare({amenity="hospital"}).healthcare == "hospital", "test failed: hospital")
assert(transform_healthcare({amenity="doctors"}).healthcare == "doctors", "test failed: doctors")
assert(transform_healthcare({amenity="dentist"}).healthcare == "dentist", "test failed: dentist")
assert(transform_healthcare({amenity="clinic"}).healthcare == "clinic", "test failed: clinic")
assert(transform_healthcare({amenity="hospital", emergency="yes"}).emergency == "true", "test failed: emergency hospital")
assert(transform_healthcare({amenity="hospital", emergency="no"}).emergency == "false", "test failed: non-emergency hospital")
assert(transform_healthcare({amenity="hospital"}).emergency == nil, "test failed: unknown emergency hospital")
assert(transform_healthcare({amenity="clinic", emergency="yes"}).emergency == "true", "test failed: emergency clinic")
assert(transform_healthcare({amenity="clinic", emergency="no"}).emergency == "false", "test failed: non-emergency clinic")
assert(transform_healthcare({amenity="clinic"}).emergency == nil, "test failed: unknown emergency clinic")
