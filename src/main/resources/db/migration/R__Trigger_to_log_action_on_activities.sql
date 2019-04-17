DROP TRIGGER IF EXISTS log_delete_activity on activity ;
DROP TRIGGER IF EXISTS log_insert_registration on registration ;
DROP TRIGGER IF EXISTS log_delete_registration on registration ;

-- fonction trigger
CREATE OR REPLACE FUNCTION log_operation_on_entity()
    RETURNS TRIGGER AS $$
BEGIN
     
      IF (TG_OP = 'DELETE') THEN
        INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
        values  (nextval('id_generator'), lower(TG_OP), TG_RELNAME, OLD.id, user, now());
        RETURN NULL; -- le résultat est ignoré car il s'agit d'un trigger AFTER
      ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
        values  (nextval('id_generator'), lower(TG_OP), TG_RELNAME, NEW.id, user, now());
        RETURN NULL; -- le résultat est ignoré car il s'agit d'un trigger AFTER
    END IF;
    RETURN NULL; -- le résultat est ignoré car il s'agit d'un trigger AFTER
    
    
END;
$$ language plpgsql;

-- trigger
CREATE TRIGGER log_delete_activity
    AFTER DELETE ON activity
    FOR EACH ROW EXECUTE PROCEDURE log_operation_on_entity();
    
-- trigger
CREATE TRIGGER log_insert_registration
    AFTER INSERT ON registration
    FOR EACH ROW EXECUTE PROCEDURE log_operation_on_entity();
    
-- trigger
CREATE TRIGGER log_delete_registration
    AFTER DELETE ON registration
    FOR EACH ROW EXECUTE PROCEDURE log_operation_on_entity();