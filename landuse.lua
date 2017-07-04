--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2017 Paul Norman, MIT license
]]--

require "common"

function accept_landuse (tags)
    return tags["landuse"] and (
        tags["landuse"] == "residential" or
        tags["landuse"] == "commercial" or
        tags["landuse"] == "retail" or
        tags["landuse"] == "industrial" or
        tags["landuse"] == "railway" or
        tags["landuse"] == "farmland" or
        tags["landuse"] == "farmyard" or
        tags["landuse"] == "allotments" or
        tags["landuse"] == "cemetery")
end

function transform_landuse (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)
    cols.landuse = tags["landuse"]
    return cols
end

function landuse_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_landuse, transform_landuse)
end

function landuse_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_landuse, transform_landuse)
end
