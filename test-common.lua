--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require ("common")
print("common.lua tests")

print("TESTING: oneway")
assert(oneway(nil) == nil,          "test failed: oneway(nil) == nil")
assert(oneway('-1') == 'reverse',   "test failed: oneway('-1') == 'reverse'")
assert(oneway('no') == 'false',     "test failed: oneway('no') == 'false'")
assert(oneway('false') == 'false',  "test failed: oneway('false') == 'false'")
assert(oneway('yes') == 'true',     "test failed: oneway('yes') == 'true'")
assert(oneway('foo') == 'true',     "test failed: oneway('foo') == 'true'")

print("TESTING: layer")
assert(layer(nil) == "0",           "test failed: nil")
assert(layer("0") == "0",           "test failed: 0")
assert(layer("-1") == "-1",         "test failed: -1")
assert(layer("1") == "1",           "test failed: 1")
assert(layer("1.5") == "0",           "test failed: 1.5")
assert(layer("foo") == "0",         "test failed: text")
assert(layer("f1") == "0",          "test failed: char num")
assert(layer("1f") == "0",          "test failed: num char")

print("TESTING: access")
assert(access(nil) == nil,          "test failed: nil")
assert(access("foo") == nil,        "test failed: unknown")
assert(access("yes") == "yes",      "test failed: yes")
assert(access("private") == "no",   "test failed: private")
assert(access("no") == "no",        "test failed: no")
assert(access("permissive") == "yes", "test failed: permissive")
assert(access("delivery") == "partial", "test failed: delivery")
assert(access("designated") == "yes", "test failed: designated")
assert(access("destination") == "partial", "test failed: destination")
assert(access("customers") == "partial", "test failed: customers")

print("TESTING: height")
assert(height(nil) == nil, "test failed: nil")
assert(height("foo") == nil, "test failed: unknown")
assert(height("5") == "5", "test failed: 1 digit")
assert(height("56") == "56", "test failed: multi-digit")
assert(height("5.6") == "5.6", "test failed: decimal")
assert(height("5e6") == nil, "test failed: number with text")
assert(height("10000000000") == nil, "test failed: overflow")

print("TESTING: names")
assert(names(nil) == nil, "test failed: nil")
assert(names({}) == nil, "test failed: empty")
assert(names({foo="bar"}) == nil, "test failed: non-names")
assert(names({["name:foo"]="bar"}) == '"foo"=>"bar"', "test failed: one lang")
local name1 = names({["name:aa"]="foo", ["name:zz"]="bar"})
assert(name1 == '"aa"=>"foo","zz"=>"bar"' or name1 == '"zz"=>"bar","aa"=>"foo"', "test failed: two langs")
-- Language filtering
assert(names({["name:foo:baz"]="bar"}) == nil, "test failed: one filtered lang with :")
assert(names({["name:foo1"]="bar"}) == nil, "test failed: one filtered lang with number")
assert(names({["name:prefix"]="bar"}) == nil, "test failed: one filtered lang with prefix")
assert(names({["name:genitive"]="bar"}) == nil, "test failed: one filtered lang with genitive")
assert(names({["name:etymology"]="bar"}) == nil, "test failed: one filtered lang with etymology")
assert(names({["name:botanical"]="bar"}) == nil, "test failed: one filtered lang with botanical")
assert(names({["name:left"]="bar"}) == nil, "test failed: one filtered lang with left")
assert(names({["name:right"]="bar"}) == nil, "test failed: one filtered lang with right")

assert(names({["name:foo"]="bar", ["name:foo1"]="baz"}) == '"foo"=>"bar"', "test failed: one filtered lang with non-filtered")
