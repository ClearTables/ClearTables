--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

--- Tags which are always polygons
-- TODO: sort by frequency
local unconditional_polygon_keys = {
    'abandoned:aeroway',
    'abandoned:amenity',
    'abandoned:building',
    'abandoned:landuse',
    'abandoned:power',
    'amenity',
    'area:highway',
    'building:part',
    'landuse',
    'military',
    'office',
    'place',
    'public_transport',
    'shop',
    'tourism'
}

--- Tags where the key is normally a linestring, but these are exceptions
local polygon_exceptions = {
    aeroway = {
        aerodrome = true,
        heliport = true
    },
    highway = {
        services = true,
        rest_area = true
    },
    junction = {
        yes = true
    },
    waterway = {
        riverbank = true
    }
}

--- Tags where the key is normally a polygon, but these are exceptions
local linestring_exceptions = {
    building = {
        no = true
    },
    historic = {
        citywalls = true
    },
    leisure = {
        slipway = true,
        track = true
    },
    man_made = {
        breakwater = true,
        embankment = true,
        groyne = true
    },
    natural = {
        ridge = true,
        arete = true
    },
    power = {
        line = true,
        minor_line = true
    }
}
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
            return v[tags[k]] or false
        end
    end
    for k, v in pairs(linestring_exceptions) do
        if tags[k] then
            -- This key has an entry in the table
            if not v[tags[k]] then
                -- But the tag doesn't have an entry, so it's a polygon
                return true
            end
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
    if next(tags) then
        return 1, {INT_rejected="true"}, 0, 0
    else
        return 1, {INT_empty="true"}, 0, 0
    end
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

--- Combines the columns of relation members
-- If the cols are conflicting or all members are rejected or empty then nil is returned. Empty members are ignored
-- @param member_cols cols of relation members
-- @return combined cols, or nil if cannot combine
function combine_member_cols (member_cols)
    local combined_cols = {INT_empty="true"}
    for _, cols in ipairs(member_cols) do
        -- Check if the member was untagged
        if cols.INT_empty and cols.INT_empty == "true" then
            -- untagged member, skip it
        else
            -- First non-empty member
            if combined_cols.INT_empty and combined_cols.INT_empty == "true" then
                -- wipe out INT_empty
                combined_cols = cols
            else
                -- A different tagged member
                if not deepcompare(cols, combined_cols) then
                    return nil
                end
            end
        end
    end
    -- All the members were tagged but rejected. This might be of interested to a different transform, but not this one.
    if combined_cols.INT_rejected and combined_cols.INT_rejected == "true" or
       combined_cols.INT_empty and combined_cols.INT_empty == "true" then
        return nil
    else
        return combined_cols
    end
end

--- Generic handling for a multipolygon
-- @param tags OSM tags
-- @param member_cols Columns of relation members
-- @param membercount number of members
-- @param accept function that takes osm keys and returns true if the feature should be in the table
-- @param transform function that takes osm keys and returns tags for the tables
-- @return filter, cols, member_superseded, boundary, polygon, roads
function generic_multipolygon_members (tags, member_cols, membercount, accept, transform)
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
            local combined_tags = combine_member_cols(member_cols)
            if combined_tags ~= nil then
                -- valid MP
                -- all the members are either superseded or untagged, where it doesn't matter
                for i = 1, membercount do
                    members_superseeded[i] = 1
                end
                if combined_tags then
                    return 0, combined_tags, members_superseeded, 0, 1, 0
                end
            end
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
