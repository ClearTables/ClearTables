--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

--[[
Code for the transportation layers. These are some of the most complex. There's a few principles

 - Separate tables are needed for roads and rail
 - A way might appear in both if it's both a road and rail
 - z_order is consistent across highways and rail, allowing a UNION ALL to be done
 - Non-moterized lines are processed to avoid highway=path insanity

]]--
require "common"

local highway = {
    motorway        = {z=36, class="motorway", oneway="yes", motor_access="yes", bicycle="no", ramp="false"},
    trunk           = {z=35, class="trunk", motor_access="yes", ramp="false"},
    primary         = {z=34, class="primary", motor_access="yes", bicycle="yes", ramp="false"},
    secondary       = {z=33, class="secondary", motor_access="yes", bicycle="yes", ramp="false"},
    tertiary        = {z=32, class="tertiary", motor_access="yes", bicycle="yes", ramp="false"},
    unclassified    = {z=31, class="minor", motor_access="yes", bicycle="yes", ramp="false"},
    residential     = {z=31, class="minor", motor_access="yes", bicycle="yes", ramp="false"},
    road            = {z=31, class="unknown", motor_access="yes"},
    living_street   = {z=30, class="minor", motor_access="yes"},

    motorway_link   = {z=26, class="motorway", oneway="yes", motor_access="yes", ramp="true"},
    trunk_link      = {z=25, class="trunk", oneway="yes", motor_access="yes", ramp="true"},
    primary_link    = {z=24, class="primary", oneway="yes", motor_access="yes", ramp="true"},
    secondary_link  = {z=23, class="secondary", oneway="yes", motor_access="yes", ramp="true"},
    tertiary_link   = {z=22, class="tertiary", oneway="yes", motor_access="yes", ramp="true"},

    service         = {z=15, class="service", motor_access="yes", bicycle="yes"},
    track           = {z=12, class="track"},
    pedestrian      = {z=11, class="path", motor_access="no"},
    path            = {z=10, class="path", motor_access="no"},
    footway         = {z=10, class="path", motor_access="no"},
    cycleway        = {z=10, class="path", motor_access="no", bicycle="yes"},
    steps           = {z=10, class="path", motor_access="no"},

    proposed        = {z=1}
}

local railway = {
    rail            = {z=44, class="rail"},
    narrow_gauge    = {z=42, class="rail"},
    preserved       = {z=42, class="rail"},
    funicular       = {z=42, class="rail"},
    subway          = {z=42, class="transit"},
    light_rail      = {z=42, class="transit"},
    monorail        = {z=42, class="transit"},
    tram            = {z=41, class="transit"}
}

--- Normalizes lane tags
-- @param v The lane tag value
-- @return An integer > 0 or nil for the lane tag
function lanes (v)
    return v and string.find(v, "^%d+$") and tonumber(v) < 100 and tonumber(v) > 0 and v or nil
end

function brunnel (tags)
    return isset(tags["bridge"]) and "bridge" or isset(tags["tunnel"]) and "tunnel" or nil
end

function accept_road (tags)
    return highway[tags["highway"]]
end

function accept_rail (tags)
    return railway[tags["railway"]]
end

function accept_road_point (tags)
    return tags["highway"] and (
        tags["highway"]== "crossing" or
        tags["highway"]== "traffic_signals" or
        tags["highway"]== "motorway_junction")
end

function transform_road_point (tags)
    local cols = {}
    cols.type = tags["highway"]
    cols.name = tags["name"]
    cols.names = names(tags)
    cols.ref = tags["ref"]
    return cols
end

function transform_road (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)
    cols.refs = split_list(tags["ref"])
    if highway[tags["highway"]] then
        cols.class = highway[tags["highway"]]["class"]
        cols.ramp = highway[tags["highway"]]["ramp"]
        cols.oneway = oneway(tags["oneway"] or highway[tags["highway"]]["oneway"] or (tags["junction"] == "roundabout" and "yes") or nil)
        -- Build access tags, taking the first non-nil value from the access hiarchy, or if that fails, taking a sane default
        cols.motor_access = access(tags["motor_vehicle"] or
                tags["vehicle"] or tags["access"] or highway[tags["highway"]]["motor_access"])
        cols.bicycle_access = access(tags["bicycle"] or
                tags["vehicle"] or tags["access"] or highway[tags["highway"]]["bicycle_access"])

        cols.maxspeed = speed(tags["maxspeed"])
        cols.brunnel = brunnel(tags)
        cols.layer = layer(tags["layer"])
        cols.z_order = highway[tags["highway"]]["z"] or 0
    end
    return cols
end

function transform_rail (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.names = names(tags)
    if railway[tags["railway"]] then
        cols.class = railway[tags["railway"]]["class"]
        cols.brunnel = brunnel(tags)
        cols.layer = layer(tags["layer"])
        cols.z_order = railway[tags["railway"]]["z"] or 0
    end
    return cols
end


function road_ways (tags, num_keys)
    return generic_line_way(tags, accept_road, transform_road)
end

function road_area_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_road, transform_road) -- uses the same accept/transform functions as lines
end

function road_area_rels (tags, num_keys)
    if (tags["type"] == "multipolygon" and accept_road(tags)) then
        return 0, tags
    end
    return 1, {}
end

function road_area_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_road, transform_road)
end

function road_points (tags, num_keys)
    return generic_node(tags, accept_road_point, transform_road_point)
end

function rail_ways (tags, num_keys)
    return generic_line_way(tags, accept_rail, transform_rail)
end
