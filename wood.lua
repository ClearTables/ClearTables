--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "common"

function accept_wood_area (tags)
    return tags["natural"] == "wood" or tags["landuse"] == "forest"
end

function transform_wood_area (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)
    return cols
end

function wood_area_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_wood_area, transform_wood_area)
end

function wood_area_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_wood_area, transform_wood_area)
end
