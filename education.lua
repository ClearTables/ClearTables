--[[
  This file is part of ClearTables

  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman, MIT license
]]--

require "common"

function accept_education (tags)
    return (tags["amenity"] == "school" or
            tags["amenity"] == "university" or
            tags["amenity"] == "kindergarten" or
            tags["amenity"] == "college" or
            tags["amenity"] == "library")
end

function transform_education (tags)
    local cols = {}
    cols.name = tags["name"]
    cols.education = tags["amenity"]
    return cols
end

function education_ways (tags, num_keys)
    return generic_polygon_way(tags, accept_education, transform_education)
end

function education_rels (tags, num_keys)
    if (tags["type"] == "multipolygon" and accept_education(tags)) then
        return 0, tags
    end
    return 1, {}
end

function education_rel_members (tags, member_tags, member_roles, membercount)
    return generic_multipolygon_members(tags, member_tags, membercount, accept_education, transform_education)
end