--[[
  This file is part of ClearTables

  Author: Paul Norman <penorman@mac.com>

  Copyright (c) 2015 Paul Norman
--]]

require ("common")

assert(yesno(nil) == nil,           "test failed: yesno(nil) == nil")
assert(yesno('no') == 'false',      "test failed: yesno('no') == 'false'")
assert(yesno('false') == 'false',   "test failed: yesno('false') == 'false'")
assert(yesno('yes') == 'true',      "test failed: yesno('yes') == 'true'")
assert(yesno('foo') == 'true',      "test failed: yesno('foo') == 'true'")

assert(oneway(nil) == nil,          "test failed: oneway(nil) == nil")
assert(oneway('-1') == 'reverse',   "test failed: oneway('-1') == 'reverse'")
assert(oneway('no') == 'false',     "test failed: oneway('no') == 'false'")
assert(oneway('false') == 'false',  "test failed: oneway('false') == 'false'")
assert(oneway('yes') == 'true',     "test failed: oneway('yes') == 'true'")
assert(oneway('foo') == 'true',     "test failed: oneway('foo') == 'true'")
