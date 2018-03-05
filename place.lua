--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016-2017 Paul Norman, MIT license
]]--

require "common"

local settlements = {
    city=true,
    town=true,
    village=true,
    hamlet=true,
    isolated_dwelling=true
}

local subregions = {
    suburb=true,
    neighbourhood=true
}

local other = {
    locality=true,
    farm=true
}

--- Restrictions population to positive or zero integers
function population (v)
    return v and string.find(v, "^%d+$") and tonumber(v) < 2147483647 and tonumber(v) >= 0 and v or nil
end

function accept_place (tags)
    -- most tags["place"] will match one of the lookups, so this is quite fast
    return (tags["place"] and (settlements[tags["place"]] or subregions[tags["place"]] or other[tags["place"]]))
end

function transform_place (tags)
    local cols = {}
    if settlements[tags["place"]] then
        cols.class = "settlement"
        cols.rank = tags["place"]
    elseif subregions[tags["place"]] then
        cols.class = "subregion"
        cols.rank = tags["place"]
    elseif other[tags["place"]] then
        cols.class = tags["place"]
    end
    cols.name = tags["name"]
    cols.names = names(tags)
    cols.population = population(tags["population"])
    return cols
end

function place_nodes (tags, num_keys)
    return generic_node(tags, accept_place, transform_place)
end
