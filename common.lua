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

--- Is something an area?
-- @param kv OSM tags
-- @return 1 if area, 0 if linear
function isarea(tags)
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
-- @param kv OSM tags
-- @param kv_members OSM tags of relation members
-- @param membercount number of members
-- @param accept function that takes osm keys and returns true if the feature should be in the table
-- @param transform function that takes osm keys and returns tags for the tables
-- @return filter, tags, member_superseded, boundary, polygon, roads
function generic_multipolygon_members (tags, member_tags, membercount, accept, transform)
    tags = {}
    -- default to filtering out, and a linear feature
    filter = 1
    polygon = 0

    -- tracks if the relation members are used as a stand-alone way. No old-style
    -- MP support, but the array still needs to be returned
    members_superseeded = {}
    for i = 1, membercount do
        members_superseeded[i] = 0
    end

    if (tags["type"] == "multipolygon") then
        -- All multipolygons are areas
        polygon = 1
        -- Is this a feature we want?
        if (accept(tags)) then
            -- Get the tags for the table
            return 0, transform(tags), members_superseeded, 0, 1, 0
        end
        return 1, {}, members_superseeded, 0, 1, 0
    end

    return 1, {}, members_superseeded, 0, 0, 0
end
