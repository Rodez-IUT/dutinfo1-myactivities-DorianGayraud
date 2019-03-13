-- Recherche le user avec username = "Default Owner"
-- Si il existe alors retourne le user 
-- Sinon on le créer le user avec username = "Default Owner" Puis on retourne le user créé

CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$ 


    DECLARE 

        defaultOwner "user"%rowtype;
        defaultOwnerUsername varchar(50) := "Default Owner";

    BEGIN

    -- Rechercher si get_default_owner.owner existe dans la BD 
    SELECT * INTO defaultOwnerfrom "user"
    WHERE username = defaultOwnerUsername;

    -- Si la recherche retourne une ligne on rentre dans le IF
    IF not found THEN

        INSERT INTO "user" (id, username)
        VALUES(nextval('id_generator'), defaultOwnerUsername);

       SELECT * INTO defaultOwner from "user"
       WHERE username = defaultOwnerUsername;

    END IF;
    RETURN defaultOwner 

    END;

$$ LANGUAGE PLPGSQL;