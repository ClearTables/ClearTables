--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2017 Paul Norman, MIT license
]]--

require "common"

function accept_transit (tags)
    -- frequency sorted
    return tags["highway"] == "bus_stop"
        or tags["highway"] == "bus_station"
        or tags["railway"] == "station"
        or tags["railway"] == "halt"
        or tags["amenity"] == "ferry_terminal"
        or tags["amenity"] == "taxi"
end

function transform_transit (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)
    if tags["amenity"] == "ferry_terminal" then
        cols.transit_mode = "ferry"
        cols.station = "true"
    elseif tags["railway"] == "station" then
        cols.transit_mode = "rail"
        cols.station = "true"
    elseif tags["railway"] == "halt" then
        cols.transit_mode = "rail"
        cols.station = "false"
    elseif tags["amenity"] == "taxi" then
        cols.transit_mode = "taxi"
        cols.station = "false"
    elseif tags["highway"] == "bus_station" then
        cols.transit_mode = "bus"
        cols.station = "true"
    elseif tags["highway"] == "bus_stop" then
        cols.transit_mode = "bus"
        cols.station = "false"
    end
    return cols
end

function transit_nodes (tags, num_keys)
    return generic_node(tags, accept_transit, transform_transit)
end
