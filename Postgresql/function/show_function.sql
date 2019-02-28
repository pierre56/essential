/*Description: Permet d'afficher toutes les functions maison ainsi que leur description
*/


CREATE OR REPLACE FUNCTION audelor.show_function()
  RETURNS as void
  AS
$BODY$

BEGIN
return Query


SELECT n.nspname as "Schema",
d.description,
  p.proname as "Name",
  pg_catalog.pg_get_function_result(p.oid) as "Result data type",
  pg_catalog.pg_get_function_arguments(p.oid) as "Argument data types",
 CASE
  WHEN p.proisagg THEN 'agg'
  WHEN p.proiswindow THEN 'window'
  WHEN p.prorettype = 'pg_catalog.trigger'::pg_catalog.regtype THEN 'trigger'
  ELSE 'function'
 END as "Type"
FROM pg_catalog.pg_proc p
     LEFT JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
          left join pg_description as d on d.objoid=p.oid

WHERE pg_catalog.pg_function_is_visible(p.oid)
      AND n.nspname <> 'pg_catalog'
      AND n.nspname <> 'information_schema'
      and n.nspname ='audelor'
ORDER BY 1, 2, 4;


;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;

ex: select  audelor.find_empty_table()
ou  select * from audelor.find_empty_table()
--affichage en différents champs avec le 'select * from'
