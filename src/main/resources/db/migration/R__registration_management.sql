create or replace function register_user_on_activity(in_user_id bigint, in_activity_id bigint)
    returns registration as $$
    declare
        res_registration registration%rowtype;
    begin
        -- check existence
        select * into res_registration from registration
        where user_id = in_user_id and activity_id = in_activity_id;
        if FOUND then
            raise exception 'registration_already_exists';
        end if;
        -- insert
        insert into registration (id, user_id, activity_id)
        values(nextval('id_generator'), in_user_id, in_activity_id);
        -- returns result
        select * into res_registration from registration
        where user_id = in_user_id and activity_id = in_activity_id;
        return res_registration;
    end;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION unregister_user_on_activity(in_user_id bigint, in_activity_id bigint)
    RETURNS void AS $$
    
    declare
        res_registration registration%ROWTYPE;
        
    BEGIN 
       SELECT * INTO res_registration
       FROM registration
       WHERE user_id = in_user_id AND activity_id = in_activity_id;
       
       IF NOT FOUND then 
          raise exception 'registration not found';
       end if;
       
       delete from registration where user_id = in_user_id AND activity_id = in_activity_id;
    END;
$$ language plpgsql 