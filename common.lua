--[[
  This file is part of ClearTables

  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman
--]]


-- Lua primer:

-- cond and "a" or "b" evaluates to a if cond is true, b if cond is false. This
-- is the idiomatic way to do an inline conditional in lua

--- Normalizes a tag value to true/false
-- Typical usage would be on a tag like bridge, tunnel, or shelter which are expected
-- to be yes, no, or unset, but not a tag like oneway which could be 
-- yes, no, reverse, or unset.
-- @param v The tag value
-- @return The string true or false, which is turned into a boolean by PostgreSQL
function yesno (v)
  return v ~= nil and ((v == "no" or v == "false") and "false" or "true") or nil
end

function oneway (v)
  return v ~= nil and (
    v == "-1" and "reverse" or (
      (v == "no" or v == "false") and "false" or (
        "true"
      )
    )
  ) or nil
end