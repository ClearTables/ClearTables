--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

--- Tags which are always polygons
-- TODO: sort by frequency
local unconditional_polygon_keys = {'natural', 'building','amenity'}

--- Tags where the key is normally a linestring, but these are exceptions

local polygon_exceptions = {
    waterway = {riverbank = true}
}


-- TODO: Conditional polygon keys (e.g. waterway=riverbank)

--- Is something an area?
-- @param tags OSM tags
-- @return 1 if area, 0 if linear
function isarea (tags)
    -- Handle explicit area tags
    if tags["area"] then
        return tags["area"] == "yes"
    end

    for i,k in ipairs(unconditional_polygon_keys) do
        if tags[k] then
            return true
        end
    end
    for k,v in pairs(polygon_exceptions) do
        if tags[k] then
            return v[tags[k]]
        end
    end
end

--- Drops all objects
-- @return osm2pgsql return to disregard an object as uninteresting
function drop_all (...)
    return 1, {}
end

--- Generic handling for a node
function generic_node (tags, accept, transform)
    if accept(tags) then
        cols = transform(tags)
        return 0, cols
    end
    return 1, {}
end

--- Generic handling for an linear way
-- @param tags OSM tags
-- @param accept function that takes osm keys and returns true if the feature should be in the table
-- @param transform function that takes osm keys and returns tags for the tables
-- @return filter, cols, polygon, roads
function generic_line_way (tags, accept, transform)
    -- accept is probably faster than isarea
    if (accept(tags) and not isarea(tags)) then
        cols = transform(tags)
        return 0, cols, 0, 0
    end
    return 1, {}, 0, 0
end

--- Generic handling for an area way
-- @param tags OSM tags
-- @param accept function that takes osm keys and returns true if the feature should be in the table
-- @param transform function that takes osm keys and returns tags for the tables
-- @return filter, cols, polygon, roads
function generic_polygon_way (tags, accept, transform)
    -- accept is probably faster than isarea
    if (accept(tags) and isarea(tags)) then
        return 0, transform(tags), 1, 0
    end
    return 1, {}, 0, 0
end

--- Generic handling for a multipolygon
-- @param tags OSM tags
-- @param member_tags OSM tags of relation members
-- @param membercount number of members
-- @param accept function that takes osm keys and returns true if the feature should be in the table
-- @param transform function that takes osm keys and returns tags for the tables
-- @return filter, cols, member_superseded, boundary, polygon, roads
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
            return 0, transform(tags), members_superseeded, 0, 1, 0
        end
        return 1, {}, members_superseeded, 0, 1, 0
    end

    return 1, {}, members_superseeded, 0, 0, 0
end
