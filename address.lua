--[[
  This file is part of ClearTables

  @author Paul Norman <penorman@mac.com>
  @copyright 2015 Paul Norman, MIT license
]]--

require "common"

function accept_address (tags)
    -- frequency sorted
    return tags["addr:housenumber"] or tags["addr:street"] or tags["addr:housename"] or tags["addr:unit"]
end

function transform_address (tags)
    local cols = {}
    cols["name"] = tags["name"]
    cols["unit"] = tags["addr:unit"]
    cols["housenumber"] = tags["addr:housenumber"]
    cols["street"] = tags["addr:street"]
    cols["suburb"] = tags["addr:suburb"]
    cols["city"] = tags["addr:city"]

    return cols
end

function address_nodes (tags, num_keys)
    return generic_node(tags, accept_address, transform_address)
end