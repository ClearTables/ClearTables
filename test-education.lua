--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require "education"
print("education.lua tests")

print("TESTING: accept_education")
assert(not accept_education({}), "test failed: untagged")
assert(not accept_education({foo="bar"}), "test failed: other tags")
assert(accept_education({amenity="school"}), "test failed: amenity=school")
assert(accept_education({amenity="university"}), "test failed: amenity=university")
assert(accept_education({amenity="kindergarten"}), "test failed: amenity=kindergarten")
assert(accept_education({amenity="college"}), "test failed: amenity=college")
assert(accept_education({amenity="library"}), "test failed: amenity=library")
assert(not accept_education({amenity="foo"}), "test failed: other amenity")

print("TESTING: transform_education")
assert(deepcompare(transform_education({}), {}), "test failed: no tags")
assert(transform_education({amenity="school"}).education == "school", "test failed: school")
assert(transform_education({name="foo"}).name == "foo", "test failed: name")
assert(transform_education({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
