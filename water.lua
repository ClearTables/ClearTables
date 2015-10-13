--[[
  This file is part of ClearTables
  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman
--]]

require "common"
--- Function to identify 
--

function process_water_area (kv)
    
end

function water_area_ways (kv, num_keys)
    if (kv["natural"] == "water" and isarea(kv) == 1) then
        tags = {}
        tags["water"] = kv["water"]
        tags["name"] = kv["name"]
        return 0, tags, 1, 0
    end
    return 1, {}, 0, 0
end

function water_area_rels (kv, num_keys)
    if (kv["type"] == "multipolygon" and kv["natural"] == "water") then
        return 0, kv
    end
    return 1, {}
end

function water_area_rel_members(kv, keyvaluemembers, roles, membercount)
    tags = {}
    -- default to filtering out, and a linear feature
    filter = 1
    polygon = 0

    -- tracks if the relation members are used as a stand-alone way. No old-style
    -- MP support, but the array still needs to be returned
    membersuperseeded = {}
    for i = 1, membercount do
        membersuperseeded[i] = 0
    end

    if (kv["type"] == "multipolygon") then
        if (kv["natural"] == "water") then
            filter = 0
            polygon = 1
            tags["water"] = kv["water"]
            tags["name"] = kv["name"]
        end
    end

    return filter, tags, membersuperseeded, 0, polygon, 0
end