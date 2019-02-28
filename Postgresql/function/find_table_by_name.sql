Description: Permet de retrouver toutes les tables a travers les différents schémas via un
mot clé (mot clé non sensible  à la casse )




CREATE OR REPLACE FUNCTION nom_schema.find_table_by_name(nom_table text)
  RETURNS table (
  table_schema text,
  table_name text
  )
  AS
$BODY$

BEGIN
return Query

SELECT  t.table_schema ::text,t.table_name::text
FROM   information_schema.tables t
WHERE  t.table_name ilike '%'||nom_table ||'%'
order by t.table_schema
;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;

ex:  select audelor.find_table_by_name('meta')
--affichage en différents champs avec le 'select * from'


ou   select * from audelor.find_table_by_name('meta')
