--[[
  This file is part of ClearTables
  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman
--]]

require "common"

function accept_water_area (tags)
    return tags["natural"] == "water" or tags["waterway"] == "riverbank" or tags["landuse"] == "reservoir"
end

function transform_water_area (tags)
    cols = {}
    cols["water"] = tags["water"] or (tags["waterway"] and tags["waterway"] == "riverbank" and "riverbank") or (tags["landuse"] and tags["landuse"] == "reservoir" and "reservoir")
    cols["name"] = tags["name"]
    return tags
end

function water_area_ways (tags, num_keys)
    if (accept_water_area(tags) and isarea(tags) == 1) then
        cols = transform_water_area(tags)
        return 0, cols, 1, 0
    end
    return 1, {}, 0, 0
end

function water_area_rels (tags, num_keys)
    if (tags["type"] == "multipolygon" and accept_water_area(tags)) then
        return 0, tags
    end
    return 1, {}
end

function water_area_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_water_area, transform_water_area)
end
