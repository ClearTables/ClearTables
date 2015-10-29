--[[
  This file is part of ClearTables

  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman, MIT license
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
    living_street   = {z=30},

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
    rail            = {z=44},
    subway          = {z=42},
    narrow_gauge    = {z=42},
    light_rail      = {z=42},
    preserved       = {z=42},
    funicular       = {z=42},
    monorail        = {z=42},
    miniature       = {z=42},
    turntable       = {z=42},
    tram            = {z=41},
    disused         = {z=40},
    construction    = {z=40}
}

function accept_road (tags)
    return highway[tags["highway"]] or railway[tags["railway"]]
end

function transform_road (tags)
    local cols = {}
    cols.name = tags["name"]
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

        cols.bridge = yesno(tags["bridge"])
        cols.tunnel = yesno(tags["tunnel"])
        cols.layer = layer(tags["layer"])
        cols.z_order = tostring(tonumber(layer(tags["layer"]))*100 + (highway[tags["highway"]]["z"] or 0))
    end
    return cols
end

function road_ways (tags, num_keys)
    return generic_line_way(tags, accept_road, transform_road)
end
