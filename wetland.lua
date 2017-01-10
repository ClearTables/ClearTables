--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2016 Paul Norman, MIT license
]]--

require "common"

function accept_wetland_area (tags)
    return tags["natural"] == "wetland"
end

local wetland_types = {
    marsh = 'open',
    reedbed = 'open',
    wet_meadow = 'open',
    swamp = 'treed',
    mangrove = 'treed',
    bog = 'peat',
    fen = 'peat',
    string_bog = 'peat',
    saltmarsh = 'salt',
    tidalflat = 'salt',
    saltern = 'salt'
}

function transform_wetland_area (tags)
    local cols = {}
    cols.wetland = wetland_types[tags["wetland"]] or nil
    cols.name = tags["name"]
    cols.names = names(tags)
    return cols
end

function wetland_area_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_wetland_area, transform_wetland_area)
end

function wetland_area_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_wetland_area, transform_wetland_area)
end
