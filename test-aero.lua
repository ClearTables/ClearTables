--[[
This file is part of ClearTables

@author Paul Norman <penorman@mac.com>
@copyright 2015-2016 Paul Norman, MIT license
]]--

require "aero"
print("aero.lua tests")

print("TESTING: accept_airport")
assert(not accept_airport({}), "test failed: untagged")
assert(not accept_airport({foo="bar"}), "test failed: other tags")
assert(not accept_airport({aeroway="foo"}), "test failed: other aeroway")
assert(accept_airport({aeroway="aerodrome"}), "test failed: aerodrome")
assert(accept_airport({aeroway="heliport"}), "test failed: heliport")

print("TESTING: accept_aeroway")
assert(not accept_aeroway({}), "test failed: untagged")
assert(not accept_aeroway({foo="bar"}), "test failed: other tags")
assert(not accept_aeroway({aeroway="foo"}), "test failed: other aeroway")
assert(accept_aeroway({aeroway="runway"}), "test failed: runway")
assert(accept_aeroway({aeroway="taxiway"}), "test failed: taxiway")

print("TESTING: transform_airport")
assert(deepcompare(transform_airport({}), {}), "test failed: no tags")
assert(deepcompare(transform_airport({aeroway="aerodrome"}), {airport="aerodrome"}), "test failed: aerodrome")
assert(deepcompare(transform_airport({aeroway="heliport"}), {airport="heliport"}), "test failed: heliport")
assert(deepcompare(transform_airport({name="foo"}), {name="foo"}), "test failed: name")
assert(transform_airport({iata="FOO"}).iata == "FOO", "test failed: iata")
assert(transform_airport({iata="FOOD"}).iata == "FOO", "test failed: long iata")
assert(transform_airport({iata="FO"}).iata == "FO", "test failed: short iata")
assert(transform_airport({iaco="FOOO"}).iaco == "FOOO", "test failed: iaco")
assert(transform_airport({iaco="FOOOD"}).iaco == "FOOO", "test failed: long iaco")
assert(transform_airport({iaco="FO"}).iaco == "FO", "test failed: short iaco")
assert(transform_airport({ref="foo", iata="bar", iaco="baz"}).ref == "foo", "test failed: ref ref")
assert(transform_airport({iata="bar", iaco="baz"}).ref == "bar", "test failed: ref iata")
assert(transform_airport({iaco="baz"}).ref == "baz", "test failed: ref iaco")

print("TESTING: transform_aeroway")
assert(deepcompare(transform_aeroway({}), {}), "test failed: no tags")
assert(deepcompare(transform_aeroway({aeroway="runway"}), {aeroway="runway"}), "test failed: runway")
assert(deepcompare(transform_aeroway({aeroway="taxiway"}), {aeroway="taxiway"}), "test failed: taxiway")
assert(transform_aeroway({ref="foo"}).ref == "foo", "test failed: ref")
