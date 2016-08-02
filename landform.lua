--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "common"

function accept_landform_point (tags)
    return tags["natural"] == "peak" or
           tags["natural"] == "saddle" or
           tags["natural"] == "volcano" or
           tags["natural"] == "cave_entrance" or
           tags["natural"] == "cliff"
end

function transform_landform_point (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)
    cols.landform = tags["natural"] == "peak" and "peak" or
                    tags["natural"] == "saddle" and "saddle" or
                    tags["natural"] == "volcano" and "volcano" or
                    tags["natural"] == "cave_entrance" and "cave_entrance" or
                    tags["natural"] == "cliff" and "rock_spire" or
                    nil
    cols.elevation = height(tags["ele"])
    return cols
end

function accept_landform_line (tags)
    return tags["natural"] == "cliff" or
           tags["natural"] == "ridge" or
           tags["natural"] == "arete" or
           tags["man_made"] == "embankment"
end

function transform_landform_line (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)
    -- With both natural and man_made keys accepted all the possibilities
    -- need to be explicitly listed in the order of priority
    cols.landform = tags["natural"] == "cliff" and "cliff" or
                    tags["natural"] == "ridge" and "ridge" or
                    tags["natural"] == "arete" and "arete" or
                    tags["man_made"] == "embankment" and "embankment" or
                    nil
    return cols
end

function landform_nodes (tags, num_keys)
    return generic_node(tags, accept_landform_point, transform_landform_point)
end

function landform_ways (tags, num_keys)
    return generic_line_way(tags, accept_landform_line, transform_landform_line)
end
