create table audelor.meta_ref(
  meta varchar,
  libelle varchar
)

objectif de la fonction:
aller chercher dans la table meta les libelles deja présent pour les intégrer ensuite dans la nouvelle table sous forme de commentaire


CREATE or REPLACE function aud_perimetres.meta(nom_schema varchar, nom_table varchar) returns void as

$BODY$
  declare

  rec_table_meta     audelor.meta_ref%rowtype ;
  rec_table_cible    audelor.meta_ref%rowtype;

  cur_cible CURSOR FOR
    SELECT COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    where TABLE_NAME=''|| nom_table ||''
    and COLUMN_NAME in
    (select meta  from audelor.meta_ref );

  cur_meta cursor for
    select *
    from audelor.meta_ref ;

BEGIN
   -- Open the cursor
  open cur_cible;
  open cur_meta;

LOOP
    -- fetch row into the film
 fetch cur_meta into rec_table_meta;
  FETCH cur_cible into  rec_table_cible;

  -- attention au passage de param dans la fonction
    -- gros doute sur le "execute" / PERFORM peut etre meilleur
      if rec_table_cible.meta::text =rec_table_meta.meta::text then
        -- build the query
        execute 'comment on COLUMN  ' || nom_schema ||'.'|| nom_table ||'.'|| rec_table_meta.meta ||' is ''patate'';';
else
      RAISE NOTICE 'cible: % ', rec_table_cible.meta;
      RAISE NOTICE 'meta: %', rec_table_meta.meta;
      end if;
        -- exit when no more row to fetch
  exit when not FOUND;
end LOOP;
     -- Close the cursor
close cur_cible;
close cur_meta;

end;
$BODY$ LANGUAGE plpgsql STRICT;


___________________________________
insert into audelor.meta_ref --permet d'importer les meta des autres tables
select id_nivgeo,lib_nivgeo
from nom_table
___________________________________
Try avec une LOOP


CREATE or REPLACE function aud_perimetres.metabis(nom_schema varchar, nom_table varchar) returns void as

$BODY$
  declare

  rec_meta     audelor.meta_ref%rowtype ;
  rec_table_cible    audelor.meta_ref%rowtype;
  count_fail integer;
  cur_cible scroll CURSOR FOR
    SELECT COLUMN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
    where TABLE_NAME=''|| nom_table ||''
    and COLUMN_NAME in
    (select meta  from audelor.meta_ref );

  cur_meta cursor for
    select *
    from audelor.meta_ref ;

BEGIN
   -- Open the cursor
  open cur_cible;
  open cur_meta;

    -- fetch row into the film
for rec_meta in select *
                  from audelor.meta_ref
LOOP
  FETCH cur_cible into  rec_table_cible ;


  -- attention au passage de param dans la fonction
    -- gros doute sur le "execute" / PERFORM peut etre meilleur
      if rec_table_cible.meta::text =rec_meta.meta::text then
      RAISE NOTICE 'cible: % ', rec_table_cible.meta;
      RAISE NOTICE 'meta: %', rec_meta.meta;
      count_fail +=1;
        -- build the query
        execute 'comment on COLUMN  ' || nom_schema ||'.'|| nom_table ||'.'|| rec_meta.meta ||' is ''patate'';';
        else
        raise notice 'count_fail: %', count_fail;
        end if;

        exit when not FOUND;
        -- exit when no more row to fetch
end LOOP;
     -- Close the cursor
close cur_cible;
close cur_meta;

end;
$BODY$ LANGUAGE plpgsql STRICT;

__________________________________
v3 ok ->
  -- Function: aud_perimetres.metabis(character varying, character varying)

  -- DROP FUNCTION aud_perimetres.metabis(character varying, character varying);

  CREATE OR REPLACE FUNCTION aud_perimetres.meta(
      nom_schema character varying,
      nom_table character varying)
    RETURNS void AS
  $BODY$
  DECLARE

  column_cible    audelor.meta_ref%rowtype ;
  rec_libelle     audelor.meta_ref%rowtype;


  cur_meta cursor( var_meta varchar  ) is  select libelle
              from audelor.meta_ref
              where meta = var_meta;
  BEGIN


  FOR column_cible in (SELECT COLUMN_NAME
                      FROM INFORMATION_SCHEMA.COLUMNS
                      where TABLE_NAME=''|| nom_table ||''
                      and TABLE_SCHEMA=''|| nom_schema ||''
                      and COLUMN_NAME in
                          (select meta  from audelor.meta_ref ))
  LOOP
  open cur_meta(column_cible.meta);
  FETCH  cur_meta into rec_libelle;
  exit when not FOUND;
       execute 'comment on COLUMN  ' || nom_schema ||'.'|| nom_table ||'.'|| column_cible.meta ||' is '|| quote_literal(rec_libelle) ||';';

          raise notice 'meta: %', column_cible.meta ;
          raise notice 'libelle: %', rec_libelle ;
  close cur_meta;
  end LOOP;


   end;
   $BODY$
    LANGUAGE plpgsql VOLATILE STRICT
    COST 100;


 _________________________________________
-- obj -> add to meta_ref -> fonction pour recuperer les tables existantes de meta et les ajouter à meta_ref

 CREATE OR REPLACE FUNCTION aud_perimetres.add_to_meta(
     nom_schema character varying,
     nom_table character varying)
   RETURNS void AS
 $BODY$
 DECLARE


 column_cible    audelor.meta_ref%rowtype ;
 rec_libelle     audelor.meta_ref%rowtype;

 BEGIN


 insert into audelor.meta_ref --permet d'importer les meta des autres tables
 select id_nivgeo,lib_nivgeo
 from nom_table


________________________________________
/*
1)
obj-> CREATe TABLE meta_ref
*/
CREATE table meta_ref (
nom_champs varchar not null, --COLUMN_NAME
nom_table varchar not null,  --TABLE_SCHEMA
libelle varchar     --libelle-> libelle long du champs -> utiliser comme commentaire
primary key(nom_champs, nom_table)
);
--primary key -> nom_champs, nom_table

/*
2)
obj -> recuperer tous les champs de toutes les tables d'un schema
    ->insert into meta_ref from table du schema ->!!!->faire en sorte de recuperer les commentaires si il y en
*/
create table audelor.meta_reference(TABLE_NAME,COLUMN_NAME) as(
  SELECT TABLE_NAME,COLUMN_NAME
  FROM INFORMATION_SCHEMA.COLUMNS
  where TABLE_SCHEMA='audelor');

alter table audelor.meta_reference add  libelle varchar(255);

drop table audelor.meta_reference

create table audelor.meta_reference(TABLE_NAME,COLUMN_NAME) as(
--recupere les infos de toutes les tables ayant des commentaires
  SELECT c.table_schema,c.table_name,c.column_name,pgd.description
FROM pg_catalog.pg_statio_all_tables as st
  inner join pg_catalog.pg_description pgd on (pgd.objoid=st.relid)
  inner join information_schema.columns c on (pgd.objsubid=c.ordinal_position
    and  c.table_schema=st.schemaname and c.table_name=st.relname)
    and schemaname ='audelor' --
);

    --essai foireux
    update audelor.meta_reference m
    set m.TABLE_NAME=table_name,
    m.COLUMN_NAME=column_name,
    m.libelle=description
    from(
    SELECT c.table_name,c.column_name,pgd.description
    FROM pg_catalog.pg_statio_all_tables as st
      inner join pg_catalog.pg_description pgd on (pgd.objoid=st.relid)
      inner join information_schema.columns c on (pgd.objsubid=c.ordinal_position
        and  c.table_schema=st.schemaname and c.table_name=st.relname)
            and schemaname ='audelor' --
    ) as try
________________________________________
--essai 1)

--creation d'une table ayant deja des commentaires (impossible de faire un merge)
create table audelor.meta_ref_exist (schema_name,table_name,column_name,description)
 as (
SELECT c.table_schema,c.table_name,c.column_name,pgd.description
FROM pg_catalog.pg_statio_all_tables as st
  inner join pg_catalog.pg_description pgd on (pgd.objoid=st.relid)
  inner join information_schema.columns c on (pgd.objsubid=c.ordinal_position
                                              and  c.table_schema=st.schemaname
                                              and c.table_name=st.relname)
);
--creation d'une table avec toutes les tables et columns
create table audelor.meta_reference(table_name,column_name ) as(
  SELECT TABLE_NAME,COLUMN_NAME
  FROM INFORMATION_SCHEMA.COLUMNS
  where TABLE_SCHEMA='audelor');

  --insertion des champs ayant deja des commentaires sur la table de meta
  update   audelor.meta_reference t2
  set libelle = t1.description
  from audelor.meta_ref_exist t1
  where t2.table_name=t1.table_name
  and t2.column_name=t1.column_name




/*
3)
obj-> trigger si insert dans meta_ref-> add comment on table d'origine
*/
______________________________________________________
-- Function: creation_table_meta_ref(character varying)

-- DROP FUNCTION creation_table_meta_ref(character varying);

CREATE OR REPLACE FUNCTION creation_meta_reference(nom_schema character varying)
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
  ALTER TABLE '|| nom_schema ||'.meta_reference ADD PRIMARY KEY (table_name,column_name);

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
ALTER FUNCTION creation_meta_reference(character varying)
  OWNER TO audelor;
