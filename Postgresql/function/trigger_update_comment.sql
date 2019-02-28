--trigger
--exemple
CREATE TRIGGER trigger_name {BEFORE | AFTER | INSTEAD OF} {event [OR ...]}
   ON table_name
   [FOR [EACH] {ROW | STATEMENT}]
   EXECUTE PROCEDURE trigger_function

--trigger ok
   CREATE TRIGGER trigger_update_comment
     AFTER UPDATE
     ON aud_perimetres.meta_reference
     FOR EACH ROW
     EXECUTE PROCEDURE trigger_function_update_comment();


--function trigger ok
CREATE OR REPLACE FUNCTION trigger_function_update_comment()
RETURNS trigger AS
$BODY$
BEGIN
  IF (NEW.libelle <> OLD.libelle OR OLD.libelle is null)THEN
    --attention doute si il faut rajouter le shema dans le comment on
    execute 'comment on COLUMN  '|| TG_TABLE_SCHEMA ||'.'|| OLD.table_name ||'.'|| OLD.column_name ||' is '|| quote_literal(NEW.libelle) ||';';

  END IF;
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE STRICT
COST 100;



________________________________________
--test_trigger
update audelor.meta_reference
set libelle = 'test_trigger'
where table_name='commune_16'
and column_name= 'cv'
________________________________________
