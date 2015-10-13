--[[
  This file is part of ClearTables
  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman
--]]

require "common"

function water_area_ways (kv, num_keys)
    if (accept_water(kv) and isarea(kv) == 1) then
        tags = transform_water(kv)
        return 0, tags, 1, 0
    end
    return 1, {}, 0, 0
end

function water_area_rels (kv, num_keys)
    if (kv["type"] == "multipolygon" and accept_water(kv)) then
        return 0, kv
    end
    return 1, {}
end

function accept_water (kv)
    return kv["natural"] == "water"
end

function transform_water (kv)
    tags = {}
    tags["water"] = kv["water"]
    tags["name"] = kv["name"]
    return tags
end

function water_area_rel_members (kv, kv_members, roles, membercount)
    return generic_multipolygon_members(kv, kv_members, membercount, accept_water, transform_water)
end
