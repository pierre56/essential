CREATE OR REPLACE FUNCTION creation_table_meta_ref(nom_schema varchar)
  RETURNS void AS
$BODY$
DECLARE


BEGIN
--drop des tables precedentes
--creation meta_reference vide + alter
execute '
DROP TABLE IF EXISTS '|| nom_schema ||'.meta_reference;
DROP TABLE IF EXISTS '|| nom_schema ||'.meta_ref_exist;


create table '|| nom_schema ||'.meta_reference(table_name,column_name) as(
  SELECT TABLE_NAME,COLUMN_NAME
  FROM INFORMATION_SCHEMA.COLUMNS
  where TABLE_SCHEMA='|| quote_literal(nom_schema) ||');

  alter table '|| nom_schema ||'.meta_reference add  libelle varchar(255);
';
--création table temporaire des champs ayant des comment dans le schema
execute'
create  table '|| nom_schema ||'.meta_ref_exist (schema_name,table_name,column_name,description)
 as (
SELECT c.table_schema,c.table_name,c.column_name,pgd.description
FROM pg_catalog.pg_statio_all_tables as st
  inner join pg_catalog.pg_description pgd on (pgd.objoid=st.relid)
  inner join information_schema.columns c on (pgd.objsubid=c.ordinal_position
                                              and  c.table_schema=st.schemaname
                                              and c.table_name=st.relname)
and schemaname= '|| quote_literal(nom_schema) ||'
);
';
--update des comments existants vers meta_reference
execute'
update   '|| nom_schema ||'.meta_reference t2
set libelle = t1.description
from '|| nom_schema ||'.meta_ref_exist t1
where t2.table_name=t1.table_name
and t2.column_name=t1.column_name;
';
--add trigger pour synchro entre commentaire sur les champs et meta_reference
execute'
CREATE TRIGGER trigger_update_comment
  AFTER UPDATE
  ON '|| nom_schema ||'.meta_reference
  FOR EACH ROW
  EXECUTE PROCEDURE trigger_function_update_comment();

';
--drop de la table temporaire
execute '
DROP TABLE IF EXISTS '|| nom_schema ||'.meta_ref_exist;
';

END;
$BODY$
LANGUAGE plpgsql VOLATILE STRICT
COST 100;
______________________________________________

CREATE OR REPLACE FUNCTION trigger_function_update_comment()
RETURNS trigger AS
$BODY$
BEGIN
--verification de l'ancien champs
  IF (NEW.libelle <> OLD.libelle OR OLD.libelle is null)THEN
    --comment on lors d'un update
    execute 'comment on COLUMN  '|| TG_TABLE_SCHEMA ||'.'|| OLD.table_name ||'.'|| OLD.column_name ||' is '|| quote_literal(NEW.libelle) ||';';

  END IF;
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE STRICT
COST 100;
______________________________________________
--test_function->test_trigger
update audelor.meta_reference
set libelle = 'test_trigger'
where table_name='commune_16'
and column_name= 'cv'
______________________________________________
--test_function->global
SELECT creation_table_meta_ref('nom_schema')

______________________________________________
auto-populate champs commun->

update aud_commerce.meta_reference
set libelle = 'code de la commune'
and column_name= 'libcom'

______________________________________________
-- creation d'un dico de meta_ref
CREATE OR REPLACE FUNCTION function_update_meta_dico(nom_schema varchar)
RETURNS void AS
$BODY$
DECLARE

BEGIN
execute'
update '|| nom_schema ||'.meta_reference
set libelle = 'nom de la commune'
and column_name= 'libcom';

update '|| nom_schema ||'.meta_reference
set libelle = 'code de la commune'
and column_name= 'depcom';

update '|| nom_schema ||'.meta_reference
set libelle = 'code de la commune'
and column_name= 'epci';
--
update '|| nom_schema ||'.meta_reference
set libelle = 'code du departement'
and column_name= 'depcom';

update '|| nom_schema ||'.meta_reference
set libelle = 'code de la commune'
and column_name= 'codcom';

update '|| nom_schema ||'.meta_reference
set libelle = 'code de la commune'
and column_name= 'libcom';

update '|| nom_schema ||'.meta_reference
set libelle = 'code de la commune'
and column_name= 'libcom';

update '|| nom_schema ||'.meta_reference
set libelle = 'code de la commune'
and column_name= 'libcom';


';

END;
$BODY$
LANGUAGE plpgsql VOLATILE STRICT
COST 100;

__________________________________
--create table dico_meta -> parcours toute les colonnes et récupère les noms de colonnes courants avec le count
--3 requetes différentes avec des résultats proches mais
create table audelor.dico_meta as(
SELECT c.column_name ,pgd.description,count(column_name) as patate
FROM pg_catalog.pg_statio_all_tables as st
  inner join pg_catalog.pg_description pgd on (pgd.objoid=st.relid)
  inner join information_schema.columns c on (pgd.objsubid=c.ordinal_position
                                              and  c.table_schema=st.schemaname
                                              and c.table_name=st.relname)
group by column_name,pgd.description
having count(column_name) >5);

SELECT c.table_schema,c.table_name,c.column_name,pgd.description
FROM pg_catalog.pg_statio_all_tables as st
  inner join pg_catalog.pg_description pgd on (pgd.objoid=st.relid)
  inner join information_schema.columns c on (pgd.objsubid=c.ordinal_position
                                              and  c.table_schema=st.schemaname
                                              and c.table_name=st.relname)
and c.column_name='depcom';


SELECT c.table_schema,c.column_name ,pgd.description,count(column_name) as patate
FROM pg_catalog.pg_statio_all_tables as st
  inner join pg_catalog.pg_description pgd on (pgd.objoid=st.relid)
  inner join information_schema.columns c on (pgd.objsubid=c.ordinal_position
                                              and  c.table_schema=st.schemaname
                                              and c.table_name=st.relname)
group by column_name,pgd.description,c.table_schema
having count(column_name) >1;
