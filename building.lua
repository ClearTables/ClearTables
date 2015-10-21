--[[
  This file is part of ClearTables

  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman, MIT license
]]--

require "common"

function accept_building (tags)
    return tags["building"] and tags["building"] ~= "no"
end

function transform_building (tags)
    local cols = {}
    cols["building"] = tags["building"]
    cols["name"] = tags["name"]
    if tags["building:levels"] and string.find(tags["building:levels"], "^%d+$") and tonumber(tags["building:levels"]) < 10000 then
        cols["levels"] = tostring(tonumber(tags["building:levels"]))
    end
    if tags["height"] and string.find(tags["height"], "^%d+%.?%d*$") and tonumber(tags["height"]) < 10000 then
        cols["height"] = tostring(tonumber(tags["height"]))
    end
    return cols
end


function building_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_building, transform_building)
end

function building_rels (tags, num_keys)
    if (tags["type"] == "multipolygon" and accept_building(tags)) then
        return 0, tags
    end
    return 1, {}
end

function building_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_building, transform_building)
end