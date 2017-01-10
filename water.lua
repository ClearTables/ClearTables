--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require "common"

function accept_water_area (tags)
    return tags["natural"] == "water" or tags["waterway"] == "riverbank" or tags["landuse"] == "reservoir"
end

function transform_water_area (tags)
    local cols = {}
    cols.water = tags["water"] or (tags["waterway"] == "riverbank" and "river") or (tags["landuse"] == "reservoir" and "reservoir") or nil
    cols.name = tags["name"]
    cols.names = names(tags)
    return cols
end

function accept_waterway (tags)
    return tags["waterway"] == "stream" or tags["waterway"] == "river" or tags["waterway"] == "ditch"
        or tags["waterway"] == "canal" or tags["waterway"] == "drain"
end

function transform_waterway (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)
    cols.waterway = tags["waterway"]
    cols.bridge = yesno(tags["bridge"])
    cols.tunnel = yesno(tags["tunnel"])
    cols.layer = layer(tags["layer"])
    return cols
end

function water_area_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_water_area, transform_water_area)
end

function water_area_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_water_area, transform_water_area)
end

function waterway_ways (tags, num_keys)
    return generic_line_way(tags, accept_waterway, transform_waterway)
end
