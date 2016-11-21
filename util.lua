--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

--[[
This file contains utility functions which either transform a value to text PostgreSQL can cast to a standard type, or functions independent of ClearTables
]]--

--- Normalizes a tag value to true/false
-- This is used internally for logic, and not directly returned to PostgreSQL
-- @param v The tag value
-- @return The true, false, or nil
function isset (v)
    if v == nil then
        return nil
    end
    if v == "no" or v == "false" then
        return false
    end
    return true
end

--- Normalizes a tag value to true/false string
-- Typical usage would be on a tag like bridge, tunnel, or shelter which are expected
-- to be yes, no, or unset, but not a tag like oneway which could be
-- yes, no, reverse, or unset.
-- @param v The tag value
-- @return The string true or false, or nil, which is turned into a boolean by PostgreSQL
function yesno (v)
    return v~= nil and (isset(v) and "true" or "false") or nil
end

--- Splits a semi-colon separated list into a PostgreSQL array
-- @param array list to split
-- @param delim Optional custom delimiter for non-standard PostgreSQL types
function split_list (list, delim)
    delim = delim or ','
    -- Escape any quotes and then turn ";" into ",", also quoting each array value
    if list ~= nil then
        local inner = string.gsub(string.gsub(string.gsub(list,'\\','\\\\'), '"', '\\"'), ';', '","')
        return '{"'..inner..'"}'
    end
end

--- Turns a lua table into a PostgreSQL hstore
-- @param table table to convert
-- @return table in hstore string format
function hstore (table)
    if table ~= nil then
        local s = ''
        for k,v in pairs(table) do
            s = s..',"'..string.gsub(string.gsub(k,'\\','\\\\'),'"', '\\"')..'"=>"'..string.gsub(string.gsub(v,'\\','\\\\'),'"', '\\"')..'"'
        end
        return string.sub(s, 2) -- clean up first ,
    end
end

-- Lifted from Penlight. Modified to not handle cases that don't matter here
-- https://github.com/stevedonovan/Penlight/blob/master/lua/pl/tablex.lua
--[[
Copyright (C) 2009 Steve Donovan, David Manura.
Under the MIT license, like the rest of the code here
]]--

--- compare two values.
-- if they are tables, then compare their keys and fields recursively.
-- @within Comparing
-- @param t1 A value
-- @param t2 A value
-- @return true or false
function deepcompare (t1,t2)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    -- non-table types can be directly compared
    if ty1 ~= 'table' then
        return t1 == t2
    end
    for k1 in pairs(t1) do
        if t2[k1]==nil then return false end
    end
    for k2 in pairs(t2) do
        if t1[k2]==nil then return false end
    end
    for k1,v1 in pairs(t1) do
        local v2 = t2[k1]
        if not deepcompare(v1,v2) then return false end
    end

    return true
end
