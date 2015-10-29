--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015 Paul Norman, MIT license
]]--

require "common"

--- Normalizes admin tags
-- @param v Admin tag value
-- @return An integer as a string for the layer tag
function admin_level (v)
    return v and string.find(v, "^%d%d?$") and tonumber(v) <=11 and tonumber(v) > 0 and v or nil
end

function accept_admin_area(tags)
    return tags["boundary"] == "administrative" and admin_level(tags["admin_level"])
end

function transform_admin_area (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.level = admin_level(tags["admin_level"])
    return cols
end

function admin_area_rels (tags, num_keys)
    if (tags["type"] == "boundary" and accept_admin_area(tags)) then
        tags["type"] = "multipolygon" -- Pretend it's a MP for later rel member processing
        return 0, tags
    end
    return 1, {}
end

function admin_area_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_admin_area, transform_admin_area)
end
