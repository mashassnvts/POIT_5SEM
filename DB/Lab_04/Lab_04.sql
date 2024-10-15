/*1. �������� ������ ���� ������ ��������� ����������� (������������  � ���������).*/
select * from dba_data_files;
select * from dba_temp_files;

/*2. �������� ��������� ������������ � ������ XXX_QDATA (10m). ��� �������� ���������� ��� � ��������� offline. 
����� ���������� ��������� ������������ � ��������� online. �������� ������������ XXX ����� 2m � ������������ XXX_QDATA. 
�� ����� XXX �  ������������ XXX_T1�������� ������� �� ���� ��������, ���� �� ������� ����� �������� ��������� ������. � ������� �������� 3 ������.*/
create tablespace SMI_QDATA
datafile 'SMI_QDATA'
size 10m
extent management local
offline;

select * from dba_tablespaces where TABLESPACE_NAME like '%SMI%';
alter tablespace SMI_QDATA online;

drop user SMI cascade;
create user SMI identified by 12345
default tablespace  SMI_QDATA
quota unlimited on SMI_QDATA;

grant create session,create table, create view,
create procedure,drop any table,drop any view,
drop any procedure to SMI;

alter user SMI quota 2m on SMI_QDATA;

select * from dba_users
--drop table SMI_T1
create table SMI_T1(
m number(10) primary key,
n number(20))tablespace SMI_QDATA;

insert into SMI_T1 (m,n) values (3, 4);
insert into SMI_T1 (m,n) values (7, 3);
insert into SMI_T1 (m,n) values (9, 3);

select * from SMI_T1;
/*SYS 
3. �������� ������ ��������� ���������� ������������  XXX_QDATA. ���������� ������� ������� XXX_T1. ���������� ��������� ��������.*/
select distinct * from dba_segments where tablespace_name = 'SMI_QDATA';
select segment_name, segment_type from dba_segments where tablespace_name='SMI_QDATA';

/*SMI
4. ������� (DROP) ������� XXX_T1. �������� ������ ��������� ���������� ������������  XXX_QDATA. 
���������� ������� ������� XXX_T1. ��������� SELECT-������ � ������������� USER_RECYCLEBIN, �������� ���������.*/
drop table SMI_T1;
/*SYS*/
select distinct * from dba_segments where tablespace_name = 'SMI_QDATA';


select * from user_recyclebin;/*smi*/

/*5. ������������ (FLASHBACK) ��������� �������. smi */
flashback table SMI_T1 to before drop;
select * from SMI_T1;

/*6. ��������� PL/SQL-������, ����������� ������� XXX_T1 ������� (10000 �����). SMI */
begin
for k in 10..10000
loop
insert into SMI_T1 values(k, k);
end loop;
commit;
end;
select * from SMI_T1;

/*7. ���������� ������� � �������� ������� XXX_T1 ���������, �� ������ � ������ � ������. �������� �������� ���� ���������. smi*/
select * from user_segments where tablespace_name like 'SMI_QDATA';
select extents, blocks, bytes from user_segments where tablespace_name like 'SMI_QDATA';

/*8. ������� ��������� ������������ XXX_QDATA � ��� ���� sys*/
drop tablespace SMI_QDATA including contents and datafiles;
select * from SYS.DBA_TABLESPACES

/*9. �������� �������� ���� ����� �������� �������. ���������� ������� ������ �������� �������.*/
select GROUP# from v$log;
select GROUP# from v$log where STATUS = 'CURRENT';
    
/*10. �������� �������� ������ ���� �������� ������� ��������*/  
select MEMBER from v$logfile;
    
/*11� ������� ������������ �������� ������� �������� ������ ���� ������������. 
�������� ��������� ����� � ������ ������ ������� ������������ (��� ����������� ��� ���������� ��������� �������).*/    
ALTER SESSION SET CONTAINER = CDB$ROOT;

ALTER SYSTEM SWITCH LOGFILE;
SELECT GROUP#, STATUS, MEMBERS FROM V$LOG;
select current_timestamp from SYS.DUAL;

/*12�������� �������������� ������ �������� ������� � ����� ������� �������. ��������� � ������� ������ � ������, \
� ����� � ����������������� ������ (�������������). ���������� ������������������ SCN. */
ALTER DATABASE ADD LOGFILE GROUP 4 '/opt/oracle/oradata/XE/redo04.log' SIZE 50m BLOCKSIZE 512;
ALTER DATABASE ADD LOGFILE MEMBER '/opt/oracle/oradata/XE/redo04_1.log' TO GROUP 4;
ALTER DATABASE ADD LOGFILE MEMBER '/opt/oracle/oradata/XE/redo04_2.log' TO GROUP 4;
SELECT * FROM V$LOG;
select * from v$logfile


/*13������� ��������� ������ �������� �������. ������� ��������� ���� ����� �������� �� �������.*/
ALTER SYSTEM CHECKPOINT;
ALTER DATABASE DROP LOGFILE GROUP 4;
select * from v$logfile

/*14
14. ����������, ����������� ��� ��� ������������� �������� ������� 
(������������� ������ ���� ���������, ����� ���������, ���� ������ ������� �������� ������� � ��������).*/
SELECT NAME, LOG_MODE FROM V$DATABASE;
SELECT INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;

/*15 ���������� ����� ���������� ������*/
SELECT MAX(sequence#) FROM v$archived_log;

/*16 �������� �������������. */
--SHUTDOWN IMMEDIATE;
--STARTUP MOUNT;
--ALTER DATABASE ARCHIVELOG;
--ALTER DATABASE OPEN;
SELECT NAME, LOG_MODE FROM V$DATABASE;

/*17
������������� �������� �������� ����. ���������� ��� �����. 
���������� ��� �������������� � ��������� � ��� �������. ���������� ������������������ SCN � ������� � �������� �������. */
SELECT * FROM V$LOG;
ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 ='LOCATION=/opt/oracle/oradata/XE/Archive';
ALTER SYSTEM SWITCH LOGFILE;
SELECT * FROM V$ARCHIVED_LOG;

SELECT sequence#, name FROM v$archived_log ORDER BY sequence# DESC; -- ����� ���������� ��������� �����.
SELECT group#, sequence#, first_change#, next_change# FROM v$log ORDER BY group#;
SELECT * FROM V$ARCHIVED_LOG;


/*18*/
SHUTDOWN IMMEDIATE;
--STARTUP MOUNT;
--ALTER DATABASE NOARCHIVELOG;
--ALTER DATABASE OPEN;
select name, log_mode from v$database;


/*19 �������� ������ ����������� ������.*/
SELECT * FROM V$CONTROLFILE;

/*21. ���������� �������������� ����� ���������� ��������. ��������� � ������� ����� �����. */
select * from v$parameter where name = 'spfile';
/*22. ����������� PFILE � ������ XXX_PFILE.ORA. ���������� ��� ����������. �������� ��������� ��� ��������� � �����.*/
CREATE PFILE = 'SMI_PFILE.ora' FROM SPFILE;
SHOW PARAMETER background_dump_dest;


SHOW PARAMETER SPFILE

/*23. ���������� �������������� ����� ������� ��������. ��������� � ������� ����� �����. */
SELECT * FROM V$PWFILE_USERS;

/*24. �������� �������� ����������� ��� ������ ��������� � �����������. */
SELECT * FROM V$DIAG_INFO;


