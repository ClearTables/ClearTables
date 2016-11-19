SET client_min_messages = warning;
DROP TYPE IF EXISTS wetland;
RESET client_min_messages;

-- The type is ordered so you can use WHERE clauses like rank >= 'village' to get towns and cities
CREATE TYPE wetland AS ENUM
(
    'open', --open
    'treed', --with trees
    'peat', --peat-forming
    'salt' --saltwater-based

);

/*
    'bog',
    'marsh',
    'swamp',
    'reedbed',
    'tidalflat',
    'mangrove',
    'wet_meadow',
    'saltmarsh',
    'string_bog',
    'saltern',
    'fen'
*/