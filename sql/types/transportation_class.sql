SET client_min_messages = warning;
DROP TYPE IF EXISTS transportation_class;
RESET client_min_messages;

-- The type is ordered for sensible > and < operators
CREATE TYPE transportation_class AS ENUM
(
    'path',
    'track',
    'service',
    'unknown',
    'minor',
    'tertiary',
    'secondary',
    'primary',
    'trunk',
    'motorway',

    'transit',
    'rail'
);
