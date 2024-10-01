/*1. Получите список всех существующих PDB в рамках экземпляра ORA12W. Определите их текущее состояние.*/
select * from dba_pdbs;

/*2. Выполните запрос к ORA12W, позволяющий получить перечень экземпляров.*/
select * from v$instance;

/*3. Вполните запрос к ORA12W, позволяющий получить перечень установленных компонентов СУБД Oracle 12c и их версии и статус. */
select * from v$option;
SELECT comp_id, comp_name, version, status FROM dba_registry;
/*5*/
select * from dba_pdbs;

/*6*/
create tablespace TS_SMI_PDB
datafile  'TS_PDB_SMIII.dbf'
size 9M
autoextend on next 4M
maxsize 50M;

create temporary tablespace TS_SMI_PDB_TEMP
tempfile 'TS_PDB_SMIII_TEMP.dbf'
size 5M
autoextend on next 2M
maxsize 20M;

select * from dba_tablespaces where TABLESPACE_NAME like '%TS%';
drop tablespace TS_PDB_SMI including contents and datafiles;
drop tablespace TS_PDB_SMI_TEMP including contents and datafiles;


SELECT tablespace_name FROM dba_tablespaces;

drop role RL_PDB_SMIICORE; 
create role RL_PDB_SMIIICORE;

grant connect to RL_PDB_SMIIICORE;
grant create session to RL_PDB_SMIIICORE;
grant create any table to RL_PDB_SMIIICORE;
grant drop any table to RL_PDB_SMIIICORE;
grant create any view to RL_PDB_SMIIICORE;
grant drop any view to RL_PDB_SMIIICORE;
grant create any procedure to RL_PDB_SMIIICORE;
grant drop any procedure to RL_PDB_SMIIICORE;

drop profile PF_SMIII
create profile PF_SMIIII limit
password_life_time 180
sessions_per_user 5
failed_login_attempts 7
password_lock_time 1
password_reuse_time 10
password_grace_time default 
connect_time 180
idle_time 30;


create user U1_SMIII_PDB identified by 12345
default tablespace TS_SMI_PDB
quota unlimited on TS_SMI_PDB
temporary tablespace TS_SMI_PDB_TEMP
profile PF_SMIIII
account unlock
password expire;

drop user U1_SMIII_PDB;

grant RL_PDB_SMIIICORE to U1_SMIII_PDB; 


create table SMI_table ( x number(2), y varchar(5));
DROP TABLE SMI_table
insert into SMI_table values (8, 'HELLO');
insert into SMI_table values (6, 'POKA');
commit;

select * from SMI_table;


select * from dba_tablespaces;
select * from dba_tablespaces where tablespace_name like 'TS%';
select * from DBA_DATA_FILES;
select * from DBA_TEMP_FILES;
select * from dba_roles;
select * from dba_roles where ROLE like 'RL%';
select * from dba_sys_privs where GRANTEE like 'RL%';
select * from dba_profiles
select * from dba_profiles where PROFILE like 'PF%';



create user C##SMI identified by 123;
grant create session to C##SMI;
ALTER SESSION SET CONTAINER = SMI_PDB;




