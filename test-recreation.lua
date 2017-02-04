--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2017 Paul Norman, MIT license
]]--

require "recreation"
print("recreation.lua tests")

print("TESTING: accept_recreation")
assert(not accept_recreation({}), "test failed: untagged")
assert(not accept_recreation({foo="bar"}), "test failed: other tags")
assert(accept_recreation({leisure="park"}), "test failed: leisure=park")
assert(accept_recreation({leisure="playground"}), "test failed: leisure=playground")
assert(accept_recreation({leisure="dog_park"}), "test failed: leisure=dog_park")
assert(accept_recreation({leisure="golf_course"}), "test failed: leisure=golf_course")
assert(accept_recreation({leisure="garden"}), "test failed: leisure=garden")
assert(not accept_recreation({leisure="foo"}), "test failed: other leisure")
assert(accept_recreation({amenity="theatre"}), "test failed: amenity=theatre")
assert(accept_recreation({amenity="cinema"}), "test failed: amenity=cinema")
assert(accept_recreation({amenity="nightclub"}), "test failed: amenity=nightclub")
assert(not accept_recreation({amenity="foo"}), "test failed: other amenity")

print("TESTING: transform_recreation")
assert(deepcompare(transform_recreation({}), {}), "test failed: no tags")
assert(transform_recreation({name="foo"}).name == "foo", "test failed: name")
assert(transform_recreation({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")
assert(transform_recreation({leisure="park"}).recreation == "park", "test failed: park")
assert(transform_recreation({leisure="playground"}).recreation == "playground", "test failed: park")
assert(transform_recreation({leisure="dog_park"}).recreation == "dog_park", "test failed: dog_park")
assert(transform_recreation({leisure="golf_course"}).recreation == "golf", "test failed: golf_course")
assert(transform_recreation({leisure="garden"}).recreation == "garden", "test failed: garden")
assert(transform_recreation({amenity="theatre"}).recreation == "theatre", "test failed: theatre")
assert(transform_recreation({amenity="cinema"}).recreation == "movies", "test failed: cinema")
assert(transform_recreation({amenity="nightclub"}).recreation == "nightclub", "test failed: nightclub")
