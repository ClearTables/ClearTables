SET client_min_messages = warning;
DROP TYPE IF EXISTS brunnel;
RESET client_min_messages;

CREATE TYPE brunnel AS ENUM
(
   'tunnel',
   'bridge'
);
