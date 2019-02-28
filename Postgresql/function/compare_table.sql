
  description:
  comparaison de 2 tables (table_name,column_name, data_type, character_maximum_length)




compare_table_not_in()
SELECT table_name, COLUMN_NAME, data_type, character_maximum_length  --select * from table 1 not in table 2
FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='sirene_29_56_juin17'
and column_name not in (
                      SELECT COLUMN_NAME
                      FROM INFORMATION_SCHEMA.COLUMNS
                      where TABLE_NAME='sirene_zel_juin16')





SELECT table_name as table_name1 , COLUMN_NAME as COLUMN_NAME1, data_type as data_type1, character_maximum_length as character_maximum_length1 --select  from table 1 not in table 2
FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='sirene_29_56_juin17'
and column_name in (
                      SELECT COLUMN_NAME
                      FROM INFORMATION_SCHEMA.COLUMNS
                      where TABLE_NAME='sirene_zel_juin16')

full join on
SELECT table_name as table_name2 , COLUMN_NAME as COLUMN_NAME2, data_type as data_type2, character_maximum_length as character_maximum_length2 --select  from table 1 not in table 2
FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='sirene_29_56_juin17'
and column_name not in (
                      SELECT COLUMN_NAME
                      FROM INFORMATION_SCHEMA.COLUMNS
                      where TABLE_NAME='sirene_zel_juin16')



SELECT source.table_name as table_name1 , source.COLUMN_NAME as COLUMN_NAME1, source.data_type as data_type1, source.character_maximum_length as character_maximum_length1
cible.table_name as table_name2 , cible.COLUMN_NAME as COLUMN_NAME2, cible.data_type as data_type2, cible.character_maximum_length as character_maximum_length2
from INFORMATION_SCHEMA.COLUMNS as source
where TABLE_NAME='sirene_29_56_juin17'

inner join  INFORMATION_SCHEMA.COLUMNS as cible using(table_name)
where TABLE_NAME='sirene_29_56_juin17'




CREATE OR REPLACE FUNCTION audelor.compare_table(table_source text, table_cible text )
  RETURNS table (
table_source text,
    COLUMN_source text,
    data_type_source text,
    taille__type_source text,
    table_cible text,
    COLUMN_cible text,
    data_type_cible text,
    taille__type_cible text,
    match_column text)
  AS
$BODY$

execute '
WITH table_source AS (
                        SELECT table_name as table_source , COLUMN_NAME as COLUMN_source, data_type as data_type_source, character_maximum_length as taille__type_source --select  from table 1 not in table 2
                        FROM INFORMATION_SCHEMA.COLUMNS
                        where TABLE_NAME='''||table_source ||'''

), table_cible AS (SELECT table_name as table_cible , COLUMN_NAME as COLUMN_cible, data_type as data_type_cible, character_maximum_length as taille__type_cible --select  from table 1 not in table 2
                        FROM INFORMATION_SCHEMA.COLUMNS
                        where TABLE_NAME='''||table_cible ||'''
),match as (
            SELECT *,
            case
              when (COLUMN_source=COLUMN_cible) and (data_type_source=data_type_cible) and (taille__type_cible=taille__type_source) then ''identique''
              when (COLUMN_source!=COLUMN_cible) and (data_type_source=data_type_cible) and (taille__type_cible=taille__type_source) then ''column non présente''
              when (COLUMN_source=COLUMN_cible) and (data_type_source!=data_type_cible) and (taille__type_cible=taille__type_source) then ''typage différent''
              when (COLUMN_source=COLUMN_cible) and (data_type_source=data_type_cible) and (taille__type_cible!=taille__type_source) then ''taille typage différent''
              ELSE ''column absente dans une des tables ''
            END AS match_column
            FROM table_source t2
                right join table_cible as t1 on COLUMN_source=COLUMN_cible
            order by COLUMN_cible,COLUMN_source
)
SELECT *
FROM match
;'
END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;


attention le nombre de column sera équivalent au nombre de column de la table cible




CREATE OR REPLACE FUNCTION audelor.compare_table(table_reference text, table_ciblee text )
  RETURNS table (
table_source text,
    COLUMN_source text,
    data_type_source text,
    taille__type_source text,
    table_cible text,
    COLUMN_cible text,
    data_type_cible text,
    taille__type_cible text,
    match_column text)
  AS
$BODY$
begin
return Query
WITH table_source AS (
                        SELECT s.table_name::text as table_source , s.COLUMN_NAME::text as COLUMN_source, s.data_type::text as data_type_source, s.character_maximum_length::text as taille__type_source
                        FROM INFORMATION_SCHEMA.COLUMNS as s
                        where TABLE_NAME=''||table_reference||''

), table_cible AS (
                        SELECT c.table_name::text as table_cible , c.COLUMN_NAME::text as COLUMN_cible, c.data_type::text as data_type_cible, c.character_maximum_length::text as taille__type_cible
                        FROM INFORMATION_SCHEMA.COLUMNS as c
                        where TABLE_NAME=''||table_ciblee ||''
),match as (
            SELECT *,
            case
              when (t2.COLUMN_source=t1.COLUMN_cible) and (t2.data_type_source=t1.data_type_cible) and (t1.taille__type_cible=t2.taille__type_source) then 'identique'
              when (t2.COLUMN_source!=t1.COLUMN_cible) and (t2.data_type_source=t1.data_type_cible) and (t1.taille__type_cible=t2.taille__type_source) then 'column non présente'
              when (t2.COLUMN_source=t1.COLUMN_cible) and (t2.data_type_source!=t1.data_type_cible) and (t1.taille__type_cible=t2.taille__type_source) then 'typage différent'
              when (t2.COLUMN_source=t1.COLUMN_cible) and (t2.data_type_source=t1.data_type_cible) and (t1.taille__type_cible!=t2.taille__type_source) then 'taille typage différent'
              ELSE 'column absente dans une des tables '
            END AS match_column
            FROM table_source t2
                right join table_cible as t1 on t2.COLUMN_source=t1.COLUMN_cible
            order by t1.COLUMN_cible,t2.COLUMN_source
)
SELECT *
FROM match
;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
