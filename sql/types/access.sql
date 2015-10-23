SET client_min_messages = warning;
DROP TYPE IF EXISTS access;
RESET client_min_messages;

CREATE TYPE access AS ENUM
(
   'yes',
   'partial',
   'no'
);
