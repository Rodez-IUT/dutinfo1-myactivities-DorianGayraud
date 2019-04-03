-- rechercher le user avec username = "Default_owner"
-- Si il existe alors retourne le user
-- Sinon 
--   On créé le user avec username = "Default_owner"
--   On retourne le user créé
CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$

DECLARE

  defaultOwner "user"%rowtype;
  defaultOwnerUsername varchar(50) := 'Default Owner';
  
BEGIN

  SELECT * INTO defaultOwner
  FROM "user"
  WHERE username = defaultOwnerUsername;

  if not found then
    INSERT INTO "user" (id, username)
    VALUES (nextval('id_generator'), defaultOwnerUsername);
    SELECT * INTO defaultOwner
    FROM "user"
    WHERE username = defaultOwnerUsername;
  end if;
  RETURN defaultOwner;
END
  
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fix_activities_without_owner() RETURNS SETOF activity AS $$

DECLARE
  
  defaultOwner "user"%rowtype;
  nowDate date = now();

BEGIN
  
  defaultOwner := get_default_owner();
  RETURN QUERY
  UPDATE activity
  SET owner_id = defaultOwner.id,
      modification_date = nowDate
      WHERE owner_id IS NULL
      RETURNING *;

END

$$ LANGUAGE plpgSQL;