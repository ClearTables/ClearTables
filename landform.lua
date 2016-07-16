--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "common"

function accept_landform (tags)
    return (tags["natural"] == "peak" or
            tags["natural"] == "saddle" or
            tags["natural"] == "volcano" or
            tags["natural"] == "cave_entrance") -- cliff?
end

function transform_landform (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)
    cols.landform = tags["natural"]
    if tags["ele"] and string.find(tags["ele"], "^%d+%.?%d*$") and tonumber(tags["ele"]) < 100000 then
        cols.elevation = tostring(tonumber(tags["ele"]))
    end
    return cols
end

function landform_nodes (tags, num_keys)
    return generic_node(tags, accept_landform, transform_landform)
end