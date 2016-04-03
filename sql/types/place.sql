SET client_min_messages = warning;
DROP TYPE IF EXISTS place;
RESET client_min_messages;

-- The type is ordered so you can use WHERE clauses like rank >= 'village' to get towns and cities
CREATE TYPE place AS ENUM
(
    'neighbourhood',
    'suburb',
    'isolated_dwelling',
    'hamlet',
    'village',
    'town',
    'city'
);
