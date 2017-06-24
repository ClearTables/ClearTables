# ClearTables #

An [osm2pgsql](https://github.com/openstreetmap/osm2pgsql) multi-backend style designed to simplify consumption of OSM data for rendering, export, or analysis.

ClearTables is currently under rapid development, and schema changes will frequently require database reloads.

## Requirements ##

- [osm2pgsql 0.90.1](https://github.com/openstreetmap/osm2pgsql) or later. Early versions after 0.86.0 may still work with bugs.
- [Lua](http://www.lua.org/), required for both osm2pgsql and testing the transforms
- [PostgreSQL](http://www.postgresql.org/) 9.1 or later
- [PostGIS](http://postgis.net/) 2.0 or later
- Python with [PyYAML](http://pyyaml.org/wiki/PyYAML)
- Make. Any version of Make should work, or the commands are simple enough to run by hand.

## Usage ##

    make
    createdb ct
    psql -d ct -c 'CREATE EXTENSION postgis; CREATE EXTENSION hstore;'
    cat sql/types/*.sql | psql -1Xq -d ct
    # Add other osm2pgsql flags for large imports, updates, etc
    osm2pgsql -d ct --number-processes 2 --output multi --style cleartables.json extract.osm.pbf
    cat sql/post/*.sql | psql -1Xq -d ct

Replace `ct` with the name of your database if naming it differently.

osm2pgsql will connect to PostgreSQL once per process for each table, for a total of processes * tables connections.
If PostgreSQL [`max_connections`](http://www.postgresql.org/docs/9.3/static/runtime-config-connection.html#RUNTIME-CONFIG-CONNECTION-SETTINGS)
is increased from the default, `--number-processes` can be increased. If `--number-processes` is omitted, osm2pgsql will
attempt to use as many processes as hardware threads.

## Principles ##

These are still a bit vague, and might be split into principles and practices

* Simplify data for the consumer

* Use PostgreSQL types other than `text` if appropriate

* Use boolean for yes/no values

* Use enum types where there's a limited list of possibilities independent of data to be included, or a well defined ordering

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

### Why no support for osm2pgsql `--hstore`? ###

ClearTables uses the hstore type but doesn't support `--hstore`.

1. The goal of ClearTables is to abstract away OSM tagging. Copying all the tags to the output is contrary to this.

2. Copying all tags is technically possible, but wouldn't be done with `--hstore`, instead it would be done similar to the names column. The `--hstore` option doesn't work well when using custom column names which may collide with OSM tags.

3. With tables for different types of features fine-grained selection of appropriate columns is possible and hstore isn't necessary.

4. Values within a hstore are untyped which is contrary to the principle of using appropriate types.

## Contributing ##

Bug reports, suggestions and (especially!) pull requests are very welcome on the Github issue tracker. Please check the tracker to see if your issue is already known, and be nice. For 
questions, please use IRC (irc.oftc.net or http://irc.osm.org, channel #osm-dev) and http://help.osm.org.

### Code style ##

* 2sp for YAML, 4sp for Lua
* `tags` are OSM tags, `cols` are database columns
* Space after function name when defining a function, e.g. ``function f (args)``
* Tests for all Lua functions except ones which are only [tail calls](http://www.lua.org/pil/6.3.html)

### Table names ###
* Use `_polygon` and `_point` suffix when there will be two tables holding the same type of object represented differently (e.g. most POIs)
* Use `_area` when there isn't a corresponding `_point` table for the same object, but there is another table for points or lines of a similar class but different objects (e.g. `wood_areas` for forests and `wood_line` for rows of trees)

### Lua guidelines ###

* Always set columns to strings, even if they're only true/false. It's unwise to count on anything else making it from Lua to C to C++ to PostgreSQL. This lets PostgreSQL do the only coversion.
* Test particular columns of a transform function instead of the entire output table, e.g. `assert(transform({foo="bar"}).baz == "qux")` instead of `assert(deepcompare(transform({foo="bar"}), {baz="qux"}))`.

### Getting started ###

Issues tagged with [new column](https://github.com/ClearTables/ClearTables/issues?utf8=%E2%9C%93&q=is%3Aopen%20is%3Aissue%20label%3A%22new%20column%22%20) are often good ones to get started with. Issues tagged [experimental](https://github.com/ClearTables/ClearTables/issues?q=is%3Aopen+is%3Aissue+label%3Aexperimental) are focused on researching new best practices and state of the art.

## Similar projects ##

* [GeoFabrik Shapefiles](http://www.geofabrik.de/data/shapefiles.html) in both their [free schema](http://download.geofabrik.de/osm-data-in-gis-formats-free.pdf) and [commercially produced schema](http://www.geofabrik.de/data/geofabrik-osm-gis-standard-0.7.pdf)
* [CartoDB OSM POIs](https://github.com/CartoDB/cartodb-osm-pois)

## Additional Reading ##

* [osm2pgsql lua docs](https://github.com/openstreetmap/osm2pgsql/blob/master/docs/lua.md)
