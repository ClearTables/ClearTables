--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require "common"

function accept_airport (tags)
    return tags["aeroway"] and (tags["aeroway"] == "aerodrome" or tags["aeroway"] == "heliport")
end

function accept_aeroway (tags)
    return tags["aeroway"] and (tags["aeroway"] == "taxiway" or tags["aeroway"] == "runway")
end

function transform_airport(tags)
    local cols = {}
    cols.airport = tags["aeroway"] -- guaranteed by accept_airport to be either aerodrome or heliport
    cols.name = tags["name"]
    cols.names = names(tags)
    cols.iata = tags["iata"] and string.sub(tags["iata"],0,3) or nil
    cols.iaco = tags["iaco"] and string.sub(tags["iaco"],0,4) or nil
    cols.ref = tags["ref"] or cols.iata or cols.iaco or nil
    return cols
end

function transform_aeroway(tags)
    local cols = {}
    cols.ref = tags["ref"]
    cols.aeroway =  tags["aeroway"]
    return cols
end

function airport_nodes (tags, num_keys)
    return generic_node(tags, accept_airport, transform_airport)
end

function airport_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_airport, transform_airport)
end

function airport_rels (tags, num_keys)
    if (tags["type"] == "multipolygon" and accept_airport(tags)) then
        return 0, tags
    end
    return 1, {}
end

function airport_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_airport, transform_airport)
end

function aeroway_ways (tags, num_keys)
    return generic_line_way(tags, accept_aeroway, transform_aeroway)
end
