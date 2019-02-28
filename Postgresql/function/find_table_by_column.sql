/*Description: Permet de retrouver toutes les tables ayant
une column que l'on a travers les différents schémas  (mot clé non sensible  à la casse )
*/



CREATE OR REPLACE FUNCTION nom_schema.find_table_by_column(nom_column text)
  RETURNS table (
  table_schema text,
  table_name text,
  column_name text,
  column_type text
  )
  AS
$BODY$

BEGIN
return Query


select t.table_schema ::text,t.table_name::text, a.attname, a.atttypid::regtype
from pg_class as c
    inner join pg_attribute as a on a.attrelid = c.oid
    left join information_schema.tables as t on c.relname=t.table_name
where a.attname ilike '%'|| nom_column ||'%'
and c.relkind = 'r'


;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;

ex: select  audelor.find_table_by_column('codgeo')
ou  select * from audelor.find_table_by_column('codgeo')
--affichage en différents champs avec le 'select * from'
