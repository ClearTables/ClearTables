--[[
  This file is part of ClearTables

  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman, MIT license
]]--

require "common"

function accept_water_area (tags)
    return tags["natural"] == "water" or tags["waterway"] == "riverbank" or tags["landuse"] == "reservoir"
end

function transform_water_area (tags)
    cols = {}
    cols["water"] = tags["water"] or (tags["waterway"] == "riverbank" and "river") or (tags["landuse"] == "reservoir" and "reservoir") or nil
    cols["name"] = tags["name"]
    return cols
end

function accept_waterway (tags)
    return tags["waterway"] == "stream" or tags["waterway"] == "river" or tags["waterway"] == "ditch"
        or tags["waterway"] == "canal" or tags["waterway"] == "drain"
end

function transform_waterway (tags)
    cols = {}
    cols["name"] = tags["name"]
    cols["waterway"] = tags["waterway"]
    cols["bridge"] = yesno(tags["bridge"])
    cols["tunnel"] = yesno(tags["tunnel"])
    return cols
end

function water_area_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_water_area, transform_water_area)
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

function waterway_ways (tags, num_keys)
    return generic_line_way(tags, accept_waterway, transform_waterway)
end
