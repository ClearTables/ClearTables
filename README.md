# ClearTables #

An [osm2pgsql](https://github.com/openstreetmap/osm2pgsql) multi-backend style designed to simplify consumption of OSM data for rendering, export, or analysis.

## Requirements ##

- [osm2pgsql 0.88.0](https://github.com/openstreetmap/osm2pgsql) or later. The multi-backend is used, which 0.86.0 does not support.
- [Lua](http://www.lua.org/), required for both osm2pgsql and testing the transforms
- [PostgreSQL](http://www.postgresql.org/) 9.1 or later
- [PostGIS](http://postgis.net/) 2.0 or later
- Python with [PyYAML](http://pyyaml.org/wiki/PyYAML)
- Make. Any version of Make should work, or the commands are simple enough to run by hand.

## Usage ##

    make
    osm2pgsql -d database --output multi --style cleartables.json extract.osm.pbf

## Principles ##

These are still a bit vague, and might be split into principles and practices

* Simplify data for the consumer

* Use PostgreSQL types other than `text` if appropriate

* Use boolean for yes/no values

* Use enum types where there's a defined list of possibilities

## FAQ ##

### Why no addresses in the building table? ###

Adresses and buildings have a many-to-many relationship. Multiple addresses
inside one building are very common, and multiple buildings in one address can
be found. If rendering, a separate table is fine, and if doing an analysis
these cases need to be considered which requires joins.

## Contributing ##

Bug reports, suggestions and (especially!) pull requests are very welcome on the Github issue tracker. Please check the tracker to see if your issue is already known, and be nice. For 
questions, please use IRC (irc.oftc.net or http://irc.osm.org, channel #osm-dev) and http://help.osm.org.

If you'd like to sponsor development of ClearTables or a multi-backend style for your needs, you can contact me at penorman@mac.com.

## Code style ##

* 2sp for YAML, 4sp for Lua
* `tags` are OSM tags, `cols` are database columns
* Space after function name when defining a function, e.g. ``function f (args)`
* Tests for all Lua functions except ones which are only [tail calls](http://www.lua.org/pil/6.3.html)

### Lua tricks ###

* Tag acceptance functions need to exit quickly in the common case of possible match

* Always set columns to strings, even if they're only true/false. It's unwise to count on anything else making it from Lua to C to C++ to PostgreSQL. This lets PostgreSQL do the only coversion.

## Additional Reading ##

* [osm2pgsql lua docs](https://github.com/openstreetmap/osm2pgsql/blob/master/docs/lua.md)
