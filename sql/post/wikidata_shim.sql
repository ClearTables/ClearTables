CREATE OR REPLACE VIEW planet_osm_point
  AS SELECT osm_id, hstore('wikidata', 'Q'||wikidata) AS tags, way
    FROM wikidata_point;
COMMENT ON VIEW planet_osm_point IS 'Wikidata ID of point features, in tags hstore column';
CREATE INDEX planet_osm_point_wikidata ON wikidata_point (((hstore('wikidata', 'Q'||wikidata)) -> 'wikidata'));

CREATE OR REPLACE VIEW planet_osm_line
  AS SELECT osm_id, hstore('wikidata', 'Q'||wikidata) AS tags, way
    FROM wikidata_line;
COMMENT ON VIEW planet_osm_point IS 'Wikidata ID of line features, in tags hstore column';
CREATE INDEX planet_osm_line_wikidata ON wikidata_line (((hstore('wikidata', 'Q'||wikidata)) -> 'wikidata'));

CREATE OR REPLACE VIEW planet_osm_polygon
  AS SELECT osm_id, hstore('wikidata', 'Q'||wikidata) AS tags, way
    FROM wikidata_polygon;
COMMENT ON VIEW planet_osm_polygon IS 'Wikidata ID of polygon features, in tags hstore column';
CREATE INDEX planet_osm_polygon_wikidata ON wikidata_polygon (((hstore('wikidata', 'Q'||wikidata)) -> 'wikidata'));
