--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require "common"

function accept_building (tags)
    return (tags["building"] or tags["railway"] == "station" or tags["aeroway"] == "terminal") and tags["building"] ~= "no"
end

function transform_building (tags)
    local cols = {}
    -- Prefer the information that it's a railway station or aeroway terminal to the building tag
    -- from accept_building we know railway=station or aeroway=terminal or non-no building
    cols.building = tags["railway"] == "station" and "railway_station" or
                    tags["aeroway"] == "terminal" and "aeroway_terminal" or
                    tags["building"]
    cols.name = tags["name"]
    cols.names = names(tags)
    if tags["building:levels"] and string.find(tags["building:levels"], "^%d+$") and tonumber(tags["building:levels"]) < 10000 then
        cols.levels = tostring(tonumber(tags["building:levels"]))
    end
    cols.height = height(tags["height"])
    return cols
end

function building_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_building, transform_building)
end

function building_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_building, transform_building)
end
