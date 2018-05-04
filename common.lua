--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

-- Bring in common functions in their own files
require("util")
require("generic")

--- Gets multi-lingual names
-- @param tags OSM tags
-- @return string hstore with other names
function names (tags)
    if tags ~= nil and next(tags) ~= nil then
        local n = {}
        for k, v in pairs(tags) do
            if string.sub(k, 1, 5) == "name:" then
                lang = string.sub(k,6)
                if not string.find(lang, '%d')
                    and not string.find(lang, ':')
                    and lang ~= 'prefix'
                    and lang ~= 'genitive'
                    and lang ~= 'etymology'
                    and lang ~= 'botanical'
                    and lang ~= 'source'
                    and lang ~= 'left'
                    and lang ~= 'right' then

                    n[lang] = v
                end
            end
        end
        return next(n) ~= nil and hstore(n) or nil
    end
end

--- Normalizes oneway for roads/etc
-- @param v The tag value
-- @return The string true, false, or reverse, or nil which is turned into an enum by PostgreSQL
function oneway (v)
    return v ~= nil and (
            v == "-1" and "reverse" or (
                (v == "no" or v == "false") and "false" or (
                    "true"
                )
            )
        ) or nil
end

--- Normalizes layer tags
-- @param v The layer tag value
-- @return An integer for the layer tag
function layer (v)
    return v and string.find(v, "^-?%d+$") and tonumber(v) < 100 and tonumber(v) > -100 and v or "0"
end

--- Normalizes access tag values
-- @param v Access tag value
-- @return yes, no, partial, or nil
function access (v)
    return v ~= nil and (
        (v == "no" or v == "private") and "no" or (
            (v == "destination" or v == "customers" or v == "delivery") and "partial" or (
                (v == "yes" or v == "permissive" or v == "designated") and "yes"
            )
        )
    ) or nil
end

--- Normalize height tag values
-- @param h Height tag value
-- @return Height in meters as a string
function height (h)
    return h ~= nil and string.find(h, "^%d+%.?%d*$") and tonumber(h) < 31000 and tostring(tonumber(h)) or nil
end
