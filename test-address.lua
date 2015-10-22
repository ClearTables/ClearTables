--[[
  This file is part of ClearTables

  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman, MIT license
]]--

require "address"

print("TESTING: accept_address")
assert(not accept_address({}), "test failed: untagged")
assert(not accept_address({foo="bar"}), "test failed: other tags")
assert(accept_address({["addr:housenumber"]="1a"}), "test failed: housenumber")
assert(accept_address({["addr:housename"]="foo"}), "test failed: housename")
assert(accept_address({["addr:street"]="Main Street"}), "test failed: street")
assert(accept_address({["addr:unit"]="101"}), "test failed: unit")
