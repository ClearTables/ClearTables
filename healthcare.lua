--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2017 Paul Norman, MIT license
]]--

require "common"

local amenity = {
    hospital = true,
    doctors = true,
    dentist = true,
    clinic = true
}
function accept_healthcare (tags)
    return amenity[tags["amenity"]]
end

function transform_healthcare (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)
    cols.healthcare = tags["amenity"]
    if tags["amenity"] == "hospital" or tags["amenity"] == "clinic" then
        cols.emergency = yesno(tags["emergency"])
    end
    return cols
end

function healthcare_nodes (tags, num_keys)
    return generic_node(tags, accept_healthcare, transform_healthcare)
end

function healthcare_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_healthcare, transform_healthcare)
end

function healthcare_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_healthcare, transform_healthcare)
end
