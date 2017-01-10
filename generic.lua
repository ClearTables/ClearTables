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
    return 1, {INT_rejected="true"}, 0, 0
end

--- Generic handling of a multipolygon
-- Unlike other generic functions, osm2pgsql enters directly here.
-- Because old-style multipolygon handling needs to be done even with
-- relations with only a type=multipolygon tag, any MP has to pass this
-- function.
-- @param tags OSM tags
-- @param num_keys Number of OSM tags
-- @return filter, tags
function generic_multipolygon (tags, num_keys)
    if (tags["type"] == "multipolygon") then
        return 0, tags
    end
    return 1, {}
end

--- Combines the tags of relation members
-- If the tags are conflicting then nil is returned. Members with no tags are ignored
-- @param member_tags OSM tags of relation members
-- @return combined tags, or nil if cannot combine
function combine_member_tags (member_tags)
    local combined_tags = {}
    for _, tags in ipairs(member_tags) do
        -- Check if the member has tags
        if next(tags) ~= nil then
            if next(combined_tags) == nil then
                -- This is the first tagged member
                combined_tags = tags
            else
                -- A different tagged member
                if not deepcompare(tags, combined_tags) then
                    return nil
                end
            end
        end
    end
    return combined_tags
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
    local members_superseeded = {}
    for i = 1, membercount do
        members_superseeded[i] = 0
    end

    if (tags["type"] and tags["type"] == "multipolygon") then
        -- Get rid of the MP tag, we've handled it
        tags["type"] = nil
        if next(tags) == nil then
            -- This is an old style MP
        else
            -- This is a new-style MP, so we can see if we want it by looking
            -- at the relation tags
            if accept(tags) then
                return 0, transform(tags), members_superseeded, 0, 1, 0
            end
        end
        return 1, {}, members_superseeded, 0, 1, 0
    end

    return 1, {}, members_superseeded, 0, 0, 0
end
