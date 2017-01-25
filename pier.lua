--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2017 Paul Norman, MIT license
]]--

require "common"

function accept_pier_area (tags)
    -- generic_polygon_way checks for being an area (e.g. area=yes)
    return tags["man_made"] == "pier"
end

--- Acceptance for raw piers as lines
-- THis only accepts those which don't have tags *other* than man_made=pier
-- indicating its an area.
function accept_pier_line_raw (tags)
    if tags["man_made"] and tags["man_made"] == "pier" then
        -- drop the man_made tag to see if it's still an area
        tags["man_made"] = nil
        -- Only accept features which aren't polygons
        return not isarea(tags)
    end
    return false
end

function transform_pier_area (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)

    return cols
end

function transform_pier_line_raw (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)

    if tags["area"] == "no" then
        -- This object is a line, regardless of if it is closed or not
        cols.forced_line = "true"
    end

    return cols
end

function pier_line_raw_ways (tags, num_keys)
    return generic_line_way(tags, accept_pier_line_raw, transform_pier_line_raw)
end

function pier_area_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_pier_area, transform_pier_area)
end

function pier_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_pier_area, transform_pier_area)
end
