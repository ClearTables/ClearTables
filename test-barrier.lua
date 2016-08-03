--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "barrier"
print("barrier.lua tests")

print("TESTING: accept_barrier_line")
assert(not accept_barrier_line({}), "test failed: untagged")
assert(not accept_barrier_line({foo="bar"}), "test failed: other tags")
assert(accept_barrier_line({barrier="fence"}), "test failed: barrier=fence")
assert(accept_barrier_line({barrier="wall"}), "test failed: barrier=wall")
assert(accept_barrier_line({barrier="hedge"}), "test failed: barrier=hedge")
assert(accept_barrier_line({barrier="retaining_wall"}), "test failed: barrier=retaining_wall")
assert(not accept_barrier_line({barrier="foo"}), "test failed: other barrier")

print("TESTING: transform_barrier_line")
assert(deepcompare(transform_barrier_line({}), {}), "test failed: no tags")
assert(transform_barrier_line({barrier="fence"}).barrier == "fence", "test failed: fence")
assert(transform_barrier_line({barrier="wall"}).barrier == "wall", "test failed: wall")
assert(transform_barrier_line({barrier="hedge"}).barrier == "hedge", "test failed: hedge")
assert(transform_barrier_line({barrier="retaining_wall"}).barrier == "retaining_wall", "test failed: retaining_wall")
assert(transform_barrier_line({height="5"}).height == "5", "test failed: height")
