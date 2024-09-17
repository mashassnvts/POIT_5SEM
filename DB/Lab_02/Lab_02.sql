create tablespace TS_SMI
datafile  'D:\app\TS_SMI.dbf'
size 7M
autoextend on next 5M
maxsize 20M;
commit;


DROP TABLESPACE TS_SMI INCLUDING CONTENTS AND DATAFILES;


select TABLESPACE_NAME from dba_tablespaces;


create temporary tablespace TS_SMI_TEMP
tempfile 'D:\app\TS_SMI_TEMP.dbf'
size 5M
autoextend on next 3M
maxsize 30M

SELECT TABLESPACE_NAME, STATUS FROM DBA_TABLESPACES;
select * from dba_temp_files;

DROP TABLESPACE TS_SMI_TEMP INCLUDING CONTENTS AND DATAFILES;
select TABLESPACE_NAME from dba_tablespaces;


select * from dba_tablespaces;


alter session set "_ORACLE_SCRIPT"=true;
create role RL_SMICORE;

drop role RL_SMICORE;

grant create session to RL_SMICORE;
grant create table to RL_SMICORE;
grant drop any table to RL_SMICORE;
grant create any view to RL_SMICORE;
grant drop  view to RL_SMICORE;
grant create  procedure to RL_SMICORE;
grant drop any procedure to RL_SMICORE;



select role from dba_roles where role = 'RL_SMICORE';
select * from dba_roles where role = 'RL_SMICORE';
select * from dba_sys_privs where GRANTEE = 'RL_SMICORE';
select privilege from role_sys_privs where role = 'RL_SMICORE';


create profile PF_SMICORE limit
password_life_time 180
sessions_per_user 3
failed_login_attempts 7
password_lock_time 1
password_reuse_time 10
password_grace_time default 
connect_time 180
idle_time 30

drop profile PF_SMICORE cascade

select * from dba_profiles;
select * from dba_profiles where profile = 'PF_SMICORE';
select * from dba_profiles where profile = 'DEFAULT' ;



create user SMICORE identified by 12345
default tablespace TS_SMI
quota unlimited on TS_SMI
temporary tablespace TS_SMI_TEMP
profile PF_SMICORE
account unlock
password expire;

GRANT RL_SMICORE to SMICORE;

SELECT USERNAME FROM ALL_USERS;
drop user SMICORE cascade
SELECT * FROM DBA_USERS WHERE USERNAME = 'SMICORE';
DROP USER SMICORE CASCADE;

drop table newtable
create table newtable(
y number(6),
z varchar(10)
);

insert into newtable values(9,'h');
insert into newtable values(3,'g');
insert into newtable values(1,'w');

select * from newtable;

create tablespace SMI_QDATA
datafile 'SMI-QDATA.dfb'
size 10M
offline;

DROP TABLESPACE SMI_QDATA INCLUDING CONTENTS AND DATAFILES;

select TABLESPACE_NAME, STATUS, CONTENTS from SYS.dba_tablespaces;

alter tablespace SMI_QDATA online;

alter user SMICORE quota 2M on SMI_QDATA;

select tablespace_name, bytes, max_bytes from dba_ts_quotas where username = 'SMICORE';


drop table SMI_T1
create table SMI_T1
(
    m number(2),
    d varchar(10)
) tablespace SMI_QDATA;

insert  into SMI_T1 values (6, 'L');
INSERT into SMI_T1 values (3, 'G');
INSERT into SMI_T1 values (7, 'J');


select * from SMI_T1;


SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'SMICORE';
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'SMICORE';
SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'SMICORE';




