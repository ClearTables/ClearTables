--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require "common"

--- Normalizes admin tags
-- @param v Admin tag value
-- @return An integer as a string for the layer tag
function admin_level (v)
    return v and string.find(v, "^%d%d?$") and tonumber(v) <=11 and tonumber(v) > 0 and v or nil
end

function accept_admin_area(tags)
    return tags["boundary"] == "administrative" and admin_level(tags["admin_level"])
end

function transform_admin_area (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)
    cols.level = admin_level(tags["admin_level"])
    return cols
end

function admin_area_rels (tags, num_keys)
    if accept_admin_area(tags) then
        return 0, tags
    end
    return 1, {}
end

--- Administrative area handling
-- @param tags OSM tags
-- @param member_tags OSM tags of relation members
-- @param membercount number of members
-- @param accept function that takes osm keys and returns true if the feature should be in the table
-- @param transform function that takes osm keys and returns tags for the tables
-- @return filter, cols, member_superseded, boundary, polygon, roads
function admin_area_rel_members (tags, member_tags, member_roles, membercount)
    members_superseeded = {}
    for i = 1, membercount do
        members_superseeded[i] = 0
    end

    if (accept_admin_area(tags)) then
        return 0, transform_admin_area(tags), members_superseeded, 0, 1, 0
    end
    return 1, {}, members_superseeded, 0, 0, 0
end

function admin_line_rels (tags, num_keys)
    if accept_admin_area(tags) then
        return 0, tags
    end
    return 1, {}
end

-- Administrative line handling
-- @param tags OSM tags
-- @param member_tags OSM tags of relation members
-- @param membercount number of members
-- @param accept function that takes osm keys and returns true if the feature should be in the table
-- @param transform function that takes osm keys and returns tags for the tables
-- @return filter, cols, member_superseded, boundary, polygon, roads
function admin_line_rel_members (tags, member_tags, member_roles, membercount)
    members_superseeded = {}
    for i = 1, membercount do
        members_superseeded[i] = 0
    end
    if (accept_admin_area(tags)) then
        return 0, transform_admin_area(tags), members_superseeded, 0, 0, 0
    end
    return 1, {}, members_superseeded, 0, 0, 0
end
