--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2017 Paul Norman, MIT license
]]--

require "pier"
print("pier.lua tests")

print("TESTING: accept_pier_area")
assert(not accept_pier_area({}), "test failed: untagged")
assert(not accept_pier_area({foo="bar"}), "test failed: other tags")
assert(accept_pier_area({man_made="pier"}), "test failed: man_made=pier")
assert(not accept_pier_area({man_made="foo"}), "test failed: other man_made")

print("TESTING: accept_pier_line_raw")
assert(not accept_pier_line_raw({}), "test failed: untagged")
assert(not accept_pier_line_raw({foo="bar"}), "test failed: other tags")
assert(accept_pier_line_raw({man_made="pier"}), "test failed: man_made=pier")
assert(not accept_pier_line_raw({man_made="foo"}), "test failed: other man_made")
assert(not accept_pier_line_raw({man_made="pier", building="yes"}), "test failed: man_made=pier with other polygon tag")
assert(not accept_pier_line_raw({man_made="pier", area="yes"}), "test failed: man_made=pier with explicit area")
assert(accept_pier_line_raw({man_made="pier", area="no"}), "test failed: man_made=pier with explicit not area")
assert(accept_pier_line_raw({man_made="pier", highway="footway"}), "test failed: man_made=pier with other line tag")

print("TESTING: transform_pier_area")
assert(deepcompare(transform_pier_area({}), {}), "test failed: no tags")
assert(transform_pier_area({name="foo"}).name == "foo", "test failed: name")
assert(transform_pier_area({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")

print("TESTING: transform_pier_line_raw")
assert(deepcompare(transform_pier_line_raw({}), {}), "test failed: no tags")
assert(transform_pier_line_raw({name="foo"}).name == "foo", "test failed: name")
assert(transform_pier_line_raw({["name:en"]="foo"}).names == '"en"=>"foo"', "test failed: names")

assert(transform_pier_line_raw({}).forced_line == nil, "test failed: plain pier")
assert(transform_pier_line_raw({area="no"}).forced_line == "true", "test failed: explicit line")
