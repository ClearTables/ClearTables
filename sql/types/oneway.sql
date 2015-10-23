SET client_min_messages = warning;
DROP TYPE IF EXISTS oneway;
RESET client_min_messages;

CREATE TYPE oneway AS ENUM
(
   'true',
   'false',
   'reverse'
);
