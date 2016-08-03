--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "common"

function accept_barrier_line (tags)
    return tags["barrier"] == "fence" or
           tags["barrier"] == "wall" or
           tags["barrier"] == "hedge" or
           tags["barrier"] == "retaining_wall"
end

function transform_barrier_line (tags)
    local cols = {}
    cols.barrier = tags["barrier"]
    cols.height = height(tags["height"])
    return cols
end

function barrier_line_ways (tags, num_keys)
    return generic_line_way(tags, accept_barrier_line, transform_barrier_line)
end
