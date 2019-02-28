Création d'une fonction pour grant privileges sur toutes les tables d'un schema
->select audelor.grant_privilege('audelor')


GRANT ALL ON all TABLE in schema '' TO audelor;
GRANT ALL ON all TABLE in schema '' TO audadmin;
GRANT SELECT, UPDATE, INSERT, DELETE ON all  TABLE in schema '' TO dsitravail;
GRANT SELECT ON ALL TABLE in schema ''  TO gdouser;
GRANT SELECT ON ALL TABLE in schema ''  TO fme_agglo;
GRANT SELECT ON ALL TABLE in schema ''  TO fme_audelor;
GRANT SELECT ON ALL TABLE in schema ''  TO sigclient;
GRANT SELECT ON ALL TABLE in schema ''  TO sigtravail;
GRANT SELECT ON ALL TABLE in schema ''  TO sigadmin;

______________________________________________________
CREATE OR REPLACE FUNCTION grant_privilege(nom_schema character varying)
  RETURNS void AS
$BODY$
DECLARE



BEGIN
--grant privileges sur toutes les tables dans un schema
execute '
GRANT ALL ON all TABLES in schema '|| nom_schema ||' TO audelor;
GRANT ALL ON all TABLES in schema '|| nom_schema ||' TO audadmin;
GRANT SELECT, UPDATE, INSERT, DELETE ON all  TABLES in schema '|| nom_schema ||' TO dsitravail;
GRANT SELECT ON ALL TABLES in schema '|| nom_schema ||'  TO gdouser;
GRANT SELECT ON ALL TABLES in schema '|| nom_schema ||'  TO fme_agglo;
GRANT SELECT ON ALL TABLES in schema '|| nom_schema ||'  TO fme_audelor;
GRANT SELECT ON ALL TABLES in schema '|| nom_schema ||'  TO sigclient;
GRANT SELECT ON ALL TABLES in schema '|| nom_schema ||'  TO sigtravail;
GRANT SELECT ON ALL TABLES in schema '|| nom_schema ||'  TO sigadmin;

';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE STRICT
  COST 100;
