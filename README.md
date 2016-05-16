# ClearTables #

An [osm2pgsql](https://github.com/openstreetmap/osm2pgsql) multi-backend style designed to simplify consumption of OSM data for rendering, export, or analysis.

ClearTables is currently under rapid development, and schema changes will frequently require database reloads.

## Requirements ##

- [osm2pgsql 0.88.0](https://github.com/openstreetmap/osm2pgsql) or later. The multi-backend is used, which 0.86.0 does not support.
- [Lua](http://www.lua.org/), required for both osm2pgsql and testing the transforms
- [PostgreSQL](http://www.postgresql.org/) 9.1 or later
- [PostGIS](http://postgis.net/) 2.0 or later
- Python with [PyYAML](http://pyyaml.org/wiki/PyYAML)
- Make. Any version of Make should work, or the commands are simple enough to run by hand.

## Usage ##

    make
    createdb <database>
    psql -d <database> -c 'CREATE EXTENSION postgis;'
    cat sql/types/*.sql | psql -1Xq -d <database>
    # Add other osm2pgsql flags for large imports, updates, etc
    osm2pgsql -d <database> --number-processes 2 --output multi --style cleartables.json extract.osm.pbf
    cat sql/post/*.sql | psql -1Xq -d <database>

osm2pgsql will connect to PostgreSQL once per process for each table, for a total of processes * tables connections.
If PostgreSQL [`max_connections`](http://www.postgresql.org/docs/9.3/static/runtime-config-connection.html#RUNTIME-CONFIG-CONNECTION-SETTINGS)
is increased from the default, `--number-processes` can be increased. If `--number-processes` is omitted, osm2pgsql will
attempt to use as many processes as hardware threads.

## Principles ##

These are still a bit vague, and might be split into principles and practices

* Simplify data for the consumer

* Use PostgreSQL types other than `text` if appropriate

* Use boolean for yes/no values

* Use enum types where there's a defined list of possibilities

## FAQ ##

### Why no addresses in the building table? ###

Addresses and buildings have a many-to-many relationship. Multiple addresses
inside one building are very common, and multiple buildings in one address can
be found. If rendering, a separate table is fine, and if doing an analysis
these cases need to be considered which requires joins.

### Why road refs as an array? ###

A road may have multiple refs, and it's wrong to ignore this. To  pretend that
there's only one ref, use SQL like `array_to_string(refs, E'\n')` or
`array_to_string(refs, ';')`. The latter will reform the ref tag as it was in
the original data.

## Contributing ##

Bug reports, suggestions and (especially!) pull requests are very welcome on the Github issue tracker. Please check the tracker to see if your issue is already known, and be nice. For 
questions, please use IRC (irc.oftc.net or http://irc.osm.org, channel #osm-dev) and http://help.osm.org.

## Code style ##

* 2sp for YAML, 4sp for Lua
* `tags` are OSM tags, `cols` are database columns
* Space after function name when defining a function, e.g. ``function f (args)`
* Tests for all Lua functions except ones which are only [tail calls](http://www.lua.org/pil/6.3.html)

### Lua tricks ###

* Tag acceptance functions need to exit quickly in the common case of possible match

* Always set columns to strings, even if they're only true/false. It's unwise to count on anything else making it from Lua to C to C++ to PostgreSQL. This lets PostgreSQL do the only coversion.

## Similar projects ##

* [GeoFabrik Shapefiles](http://www.geofabrik.de/data/shapefiles.html)
* [CartoDB OSM POIs](https://github.com/CartoDB/cartodb-osm-pois)

## Additional Reading ##

* [osm2pgsql lua docs](https://github.com/openstreetmap/osm2pgsql/blob/master/docs/lua.md)
