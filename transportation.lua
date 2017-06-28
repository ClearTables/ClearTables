--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

--[[
Code for the transportation layers. These are some of the most complex. There's a few principles

 - Separate tables are needed for roads and rail
 - A way might appear in both if it's both a road and rail
 - Non-moterized lines are processed to avoid highway=path insanity

]]--
require "common"

local highway = {
    motorway        = {class="motorway", oneway="yes", motor_access="yes", bicycle="no", ramp="false"},
    trunk           = {class="trunk", motor_access="yes", ramp="false"},
    primary         = {class="primary", motor_access="yes", bicycle="yes", ramp="false"},
    secondary       = {class="secondary", motor_access="yes", bicycle="yes", ramp="false"},
    tertiary        = {class="tertiary", motor_access="yes", bicycle="yes", ramp="false"},
    unclassified    = {class="minor", motor_access="yes", bicycle="yes", ramp="false", area=true},
    residential     = {class="minor", motor_access="yes", bicycle="yes", ramp="false", area=true},
    road            = {class="unknown", motor_access="yes"},
    living_street   = {class="minor", motor_access="yes"},

    motorway_link   = {class="motorway", oneway="yes", motor_access="yes", ramp="true"},
    trunk_link      = {class="trunk", oneway="yes", motor_access="yes", ramp="true"},
    primary_link    = {class="primary", oneway="yes", motor_access="yes", ramp="true"},
    secondary_link  = {class="secondary", oneway="yes", motor_access="yes", ramp="true"},
    tertiary_link   = {class="tertiary", oneway="yes", motor_access="yes", ramp="true"},

    service         = {class="service", motor_access="yes", bicycle="yes", area=true},
    track           = {class="track", area=true},
    pedestrian      = {class="path", motor_access="no", area=true},
    path            = {class="path", motor_access="no", area=true},
    footway         = {class="path", motor_access="no", area=true},
    cycleway        = {class="path", motor_access="no", bicycle="yes", area=true},
    steps           = {class="path", motor_access="no"}
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

-- Some regions have the annoying habit of using values like RO:urban rather than setting the maxspeed.
-- These are the most common ones

local regional_maxspeed = {
    ["RO:urban"] = "50",
    ["RU:urban"] = "60",
    ["RU:rural"] = "90",
    ["RO:rural"] = "90",
    ["RO:trunk"] = "100",
    ["RU:living_street"] = "20"
}

--- Normalizes speed
-- @param v Speed tag value
-- @return Speed in km/h
function speed (v)
    if v == nil then
        return nil
    end
    -- speeds in km/h
    if string.find(v, "^%d+%.?%d*$") then
        -- Cap speed at 1000 km/h
        return v and tonumber(v) < 1000 and v or nil
    end
    if string.find(v, "^(%d+%.?%d*) ?mph$") then
        return tostring(tonumber(string.match(v, "^(%d+%.?%d*) ?mph$"))*1.609)
    end

    if regional_maxspeed[v] then
        -- calling speed() allows the value in the table to be in mph
        return speed(regional_maxspeed[v])
    end
    return nil
end

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
        tags["highway"] == "crossing" or
        tags["highway"] == "traffic_signals" or
        tags["highway"] == "motorway_junction")
end

function accept_road_area (tags)
    return highway[tags["highway"]] and highway[tags["highway"]].area
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
        if tags["service"] == "spur" or
           tags["service"] == "siding" or
           tags["service"] == "yard" or
           tags["service"] == "crossover" then
           cols.service = tags["service"]
        end
    end
    return cols
end


function road_ways (tags, num_keys)
    return generic_line_way(tags, accept_road, transform_road)
end

function road_area_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_road_area, transform_road) -- uses the same transform functions as lines
end

function road_area_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_road_area, transform_road)
end

function road_points (tags, num_keys)
    return generic_node(tags, accept_road_point, transform_road_point)
end

function rail_ways (tags, num_keys)
    return generic_line_way(tags, accept_rail, transform_rail)
end
