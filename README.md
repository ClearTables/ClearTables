# ClearTables #

An [osm2pgsql](https://github.com/openstreetmap/osm2pgsql) multi-backend style designed to simplify consumption of OSM data for rendering, export, or analysis.

## Requirements ##

- [osm2pgsql 0.88.0](https://github.com/openstreetmap/osm2pgsql) or later. The multi-backend is used, which 0.86.0 does not support.
- [PostgreSQL 9.1](http://www.postgresql.org/)
- [PostGIS](http://postgis.net/) 2.0
- Python with [PyYAML](http://pyyaml.org/wiki/PyYAML)

## Usage ##

    make
    osm2pgsql --output multi --style cleartables.json

## Contributing ##

Bug reports, suggestions and (especially!) pull requests are very welcome on the Github issue tracker. Please check the tracker to see if your issue is already known, and be nice. For 
questions, please use IRC (irc.oftc.net or http://irc.osm.org, channel #osm-dev) and http://help.osm.org.

Formatting: hard tabs (2sp)

If you'd like to sponsor development of ClearTables or a multi-backend style for your needs, you can contact me at penorman@mac.com.
