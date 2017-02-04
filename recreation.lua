--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2017 Paul Norman, MIT license
]]--

require "common"

local leisure = {
    park = "park",
    playground = "playground",
    dog_park = "dog_park",
    golf_course = "golf",
    garden = "garden"
}

local amenity = {
    theatre = "theatre",
    cinema = "movies",
    nightclub = "nightclub"
}

function accept_recreation (tags)
    return leisure[tags["leisure"]] or amenity[tags["amenity"]]
end

function transform_recreation (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)
    cols.recreation = leisure[tags["leisure"]] or amenity[tags["amenity"]]
    return cols
end

function recreation_nodes (tags, num_keys)
    return generic_node(tags, accept_recreation, transform_recreation)
end

function recreation_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_recreation, transform_recreation)
end

function recreation_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_recreation, transform_recreation)
end
