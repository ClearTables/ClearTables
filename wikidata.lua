--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2017 Paul Norman, MIT license
]]--

require "common"

--- Find the wikidata ID from a string
-- @param str
-- @return id
function wikidata (str)
    if str and str:find("^Q[1-9]%d*$") then
        id = tonumber(str:sub(2))
        if id > 0 and id < 2^31-1 then
            return str:sub(2)
        end
    end
end

function accept_wikidata (tags)
    return tags["wikidata"] and wikidata(tags["wikidata"]) or false
end

function transform_wikidata (tags)
    local cols = {}
    cols.wikidata = wikidata(tags["wikidata"])
    return cols
end

function wikidata_nodes (tags, num_keys)
    return generic_node(tags, accept_wikidata, transform_wikidata)
end

function wikidata_line_ways (tags, num_keys)
    return generic_line_way(tags, accept_wikidata, transform_wikidata)
end

-- Because MPs don't need to be handled some filtering can be done here
function wikidata_line_rels (tags, num_keys)
    if tags["type"] and accept_wikidata(tags) and
        (tags["type"] ~= "multipolygon" and tags["type"] ~= "boundary") then
        return 0, tags
    end
    return 1, {}
end

--- Handling of line relations with wikidata
-- @param tags OSM tags
-- @param member_cols Columns of relation members
-- @param member_roles Roles of relation members
-- @param membercount number of members
-- @return filter, cols, member_superseded, boundary, polygon, roads
function wikidata_line_rel_members (tags, member_cols, member_roles, membercount)
    local members_superseeded = {}
    for i = 1, membercount do
        members_superseeded[i] = 0
    end
    -- wikidata_line_rels has already filtered out rels without wikidata id
    return 0, transform_wikidata(tags), members_superseeded, 0, 0, 1
end

function wikidata_polygon_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_wikidata, transform_wikidata)
end

--- Polygon handling for wikidata
-- Unlike generic_multipolygon this converts boundary relations to MPs
-- Because old-style multipolygon handling needs to be done even with
-- relations with only a type=multipolygon tag, any MP has to pass this
-- function.
-- @param tags OSM tags
-- @param num_keys Number of OSM tags
-- @return filter, tags
function wikidata_polygon_rels (tags, num_keys)
    if tags["type"] == "multipolygon" then
        return 0, tags
    elseif tags["type"] == "boundary" and accept_wikidata(tags) then
        -- override the type for later processing by wikidata_polygon_rel_members
        tags["type"] = "multipolygon"
        return 0, tags
    end
    return 1, {}
end

function wikidata_polygon_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_wikidata, transform_wikidata)
end
