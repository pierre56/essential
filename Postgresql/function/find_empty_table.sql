/*Description: Permet de trouver les tables vides à travers les schémas.
!!!attention -> le nb de ligne est une estimation, il peut ne pas correspondre si ANALYSE/VACUUM non fait régulièrement
*/


CREATE OR REPLACE FUNCTION audelor.find_empty_table()
  RETURNS table (
  table_schema text,
  table_name text,
  nb_ligne integer
  )
  AS
$BODY$

BEGIN
return Query


select t.table_schema::text,  t.table_name::text ,reltuples::integer
from information_schema.tables as t
	inner join pg_class as pg on pg.relname=t.table_name
where reltuples<=1
and t.table_schema not in ('pg_catalog', 'information_schema')
and t.table_type='BASE TABLE'


;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;

ex: select  audelor.find_empty_table()
ou  select * from audelor.find_empty_table()
--affichage en différents champs avec le 'select * from'
