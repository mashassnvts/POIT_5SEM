/*1. Получите список всех файлов табличных пространств (перманентных  и временных).*/
select * from dba_data_files;
select * from dba_temp_files;

/*2. Создайте табличное пространство с именем XXX_QDATA (10m). При создании установите его в состояние offline. 
Затем переведите табличное пространство в состояние online. Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA. 
От имени XXX в  пространстве XXX_T1создайте таблицу из двух столбцов, один из которых будет являться первичным ключом. В таблицу добавьте 3 строки.*/
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
3. Получите список сегментов табличного пространства  XXX_QDATA. Определите сегмент таблицы XXX_T1. Определите остальные сегменты.*/
select distinct * from dba_segments where tablespace_name = 'SMI_QDATA';
select segment_name, segment_type from dba_segments where tablespace_name='SMI_QDATA';

/*SMI
4. Удалите (DROP) таблицу XXX_T1. Получите список сегментов табличного пространства  XXX_QDATA. 
Определите сегмент таблицы XXX_T1. Выполните SELECT-запрос к представлению USER_RECYCLEBIN, поясните результат.*/
drop table SMI_T1;
/*SYS*/
select distinct * from dba_segments where tablespace_name = 'SMI_QDATA';


select * from user_recyclebin;/*smi*/

/*5. Восстановите (FLASHBACK) удаленную таблицу. smi */
flashback table SMI_T1 to before drop;
select * from SMI_T1;

/*6. Выполните PL/SQL-скрипт, заполняющий таблицу XXX_T1 данными (10000 строк). SMI */
begin
for k in 10..10000
loop
insert into SMI_T1 values(k, k);
end loop;
commit;
end;
select * from SMI_T1;

/*7. Определите сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах. Получите перечень всех экстентов. smi*/
select * from user_segments where tablespace_name like 'SMI_QDATA';
select extents, blocks, bytes from user_segments where tablespace_name like 'SMI_QDATA';

/*8. Удалите табличное пространство XXX_QDATA и его файл sys*/
drop tablespace SMI_QDATA including contents and datafiles;
select * from SYS.DBA_TABLESPACES

/*9. Получите перечень всех групп журналов повтора. Определите текущую группу журналов повтора.*/
select GROUP# from v$log;
select GROUP# from v$log where STATUS = 'CURRENT';
    
/*10. Получите перечень файлов всех журналов повтора инстанса*/  
select MEMBER from v$logfile;
    
/*11С помощью переключения журналов повтора пройдите полный цикл переключений. 
Запишите серверное время в момент вашего первого переключения (оно понадобится для выполнения следующих заданий).*/    
ALTER SESSION SET CONTAINER = CDB$ROOT;

ALTER SYSTEM SWITCH LOGFILE;
SELECT GROUP#, STATUS, MEMBERS FROM V$LOG;
select current_timestamp from SYS.DUAL;

/*12Создайте дополнительную группу журналов повтора с тремя файлами журнала. Убедитесь в наличии группы и файлов, \
а также в работоспособности группы (переключением). Проследите последовательность SCN. */
ALTER DATABASE ADD LOGFILE GROUP 4 '/opt/oracle/oradata/XE/redo04.log' SIZE 50m BLOCKSIZE 512;
ALTER DATABASE ADD LOGFILE MEMBER '/opt/oracle/oradata/XE/redo04_1.log' TO GROUP 4;
ALTER DATABASE ADD LOGFILE MEMBER '/opt/oracle/oradata/XE/redo04_2.log' TO GROUP 4;
SELECT * FROM V$LOG;
select * from v$logfile


/*13Удалите созданную группу журналов повтора. Удалите созданные вами файлы журналов на сервере.*/
ALTER SYSTEM CHECKPOINT;
ALTER DATABASE DROP LOGFILE GROUP 4;
select * from v$logfile

/*14
14. Определите, выполняется или нет архивирование журналов повтора 
(архивирование должно быть отключено, иначе дождитесь, пока другой студент выполнит задание и отключит).*/
SELECT NAME, LOG_MODE FROM V$DATABASE;
SELECT INSTANCE_NAME, ARCHIVER, ACTIVE_STATE FROM V$INSTANCE;

/*15 Определите номер последнего архива*/
SELECT MAX(sequence#) FROM v$archived_log;

/*16 Включите архивирование. */
--SHUTDOWN IMMEDIATE;
--STARTUP MOUNT;
--ALTER DATABASE ARCHIVELOG;
--ALTER DATABASE OPEN;
SELECT NAME, LOG_MODE FROM V$DATABASE;

/*17
Принудительно создайте архивный файл. Определите его номер. 
Определите его местоположение и убедитесь в его наличии. Проследите последовательность SCN в архивах и журналах повтора. */
SELECT * FROM V$LOG;
ALTER SESSION SET CONTAINER = CDB$ROOT;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 ='LOCATION=/opt/oracle/oradata/XE/Archive';
ALTER SYSTEM SWITCH LOGFILE;
SELECT * FROM V$ARCHIVED_LOG;

SELECT sequence#, name FROM v$archived_log ORDER BY sequence# DESC; -- номер последнего архивного файла.
SELECT group#, sequence#, first_change#, next_change# FROM v$log ORDER BY group#;
SELECT * FROM V$ARCHIVED_LOG;


/*18*/
SHUTDOWN IMMEDIATE;
--STARTUP MOUNT;
--ALTER DATABASE NOARCHIVELOG;
--ALTER DATABASE OPEN;
select name, log_mode from v$database;


/*19 Получите список управляющих файлов.*/
SELECT * FROM V$CONTROLFILE;

/*21. Определите местоположение файла параметров инстанса. Убедитесь в наличии этого файла. */
select * from v$parameter where name = 'spfile';
/*22. Сформируйте PFILE с именем XXX_PFILE.ORA. Исследуйте его содержимое. Поясните известные вам параметры в файле.*/
CREATE PFILE = 'SMI_PFILE.ora' FROM SPFILE;
SHOW PARAMETER background_dump_dest;


SHOW PARAMETER SPFILE

/*23. Определите местоположение файла паролей инстанса. Убедитесь в наличии этого файла. */
SELECT * FROM V$PWFILE_USERS;

/*24. Получите перечень директориев для файлов сообщений и диагностики. */
SELECT * FROM V$DIAG_INFO;


