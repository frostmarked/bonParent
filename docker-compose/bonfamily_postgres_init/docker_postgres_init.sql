CREATE ROLE "bonGateway" LOGIN;
CREATE DATABASE "bonGateway"
    WITH 
    OWNER = "bonGateway"
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
    
CREATE ROLE "bonReplicaService" LOGIN;
CREATE DATABASE "bonReplicaService"
    WITH 
    OWNER = "bonReplicaService"
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
    
CREATE ROLE "bonLivestockService" LOGIN;
CREATE DATABASE "bonLivestockService"
    WITH 
    OWNER = "bonLivestockService"
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
    
CREATE ROLE "bonContentService" LOGIN;
CREATE DATABASE "bonContentService"
    WITH 
    OWNER = "bonContentService"
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
                