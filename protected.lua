--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "common"

function accept_protected_area (tags)
    return tags["boundary"] == "national_park" or tags["leisure"] == "nature_reserve"
end

function transform_protected_area (tags)
    local cols = {}
    cols.class = tags["boundary"] == "national_park" and "national_park" or 
                 tags["leisure"] == "nature_reserve" and "nature_reserve" or
                 nil
    cols.name = tags["name"]
    cols.names = names(tags)
    return cols
end

function protected_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_protected_area, transform_protected_area)
end

function protected_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_protected_area, transform_protected_area, true)
end
