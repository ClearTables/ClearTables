--[[
  This file is part of ClearTables

  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman, MIT license
]]--


-- Lua primer:

-- cond and "a" or "b" evaluates to a if cond is true, b if cond is false. This
-- is the idiomatic way to do an inline conditional in lua

--- Normalizes a tag value to true/false
-- Typical usage would be on a tag like bridge, tunnel, or shelter which are expected
-- to be yes, no, or unset, but not a tag like oneway which could be 
-- yes, no, reverse, or unset.
-- @param v The tag value
-- @return The string true or false, or nil, which is turned into a boolean by PostgreSQL
function yesno (v)
    return v ~= nil and ((v == "no" or v == "false") and "false" or "true") or nil
end


--- Normalizes oneway for roads/etc
-- @param v The tag value
-- @return The string true, false, or reverse, or nil which is turned into an enum by PostgreSQL
function oneway (v)
    return v ~= nil and (
            v == "-1" and "reverse" or (
                (v == "no" or v == "false") and "false" or (
                    "true"
                )
            )
        ) or nil
end

--- Drops all objects
-- @return osm2pgsql return to disregard an object as uninteresting
function drop_all (...)
    return 1, {}
end


--- Tags which are always polygons
-- TODO: sort by frequency
local unconditional_polygon_keys = {'natural'}

-- TODO: Conditional polygon keys (e.g. waterway=riverbank)

--- Is something an area?
-- @param tags OSM tags
-- @return 1 if area, 0 if linear
function isarea (tags)
    -- Handle explicit area tags
    if tags["area"] then
        return tags["area"] == "yes" and 1 or 0
    end

    for i,k in ipairs(unconditional_polygon_keys) do
        if tags[k] then
            return 1
        end
    end
end

--- Generic handling for a multipolygon
-- @param tags OSM tags
-- @param member_tags OSM tags of relation members
-- @param membercount number of members
-- @param accept function that takes osm keys and returns true if the feature should be in the table
-- @param transform function that takes osm keys and returns tags for the tables
-- @return filter, tags, member_superseded, boundary, polygon, roads
function generic_multipolygon_members (tags, member_tags, membercount, accept, transform)
    -- tracks if the relation members are used as a stand-alone way. No old-style
    -- MP support, but the array still needs to be returned
    members_superseeded = {}
    for i = 1, membercount do
        members_superseeded[i] = 0
    end

    if (tags["type"] and tags["type"] == "multipolygon") then
        -- Get rid of the MP tag, we've handled it
        tags["type"] = nil
        -- Is this a feature we want?
        if (accept(tags)) then
            -- Get the tags for the table
            return 0, transform(tags), members_superseeded, 0, 1, 0
        end
        return 1, {}, members_superseeded, 0, 1, 0
    end

    return 1, {}, members_superseeded, 0, 0, 0
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
