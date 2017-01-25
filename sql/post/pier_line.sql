CREATE OR REPLACE VIEW pier_line AS
  SELECT * FROM pier_line_raw
    WHERE forced_line OR NOT ST_IsClosed(way);
