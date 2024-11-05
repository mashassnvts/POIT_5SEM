/*1.	Найдите на компьютере конфигурационные файлы SQLNET.ORA и TNSNAMES.ORA и ознакомьтесь с их содержимым.*/
--cat /opt/oracle/homes/OraDBHome21cXE/network/admin/sqlnet.ora
--cat /opt/oracle/homes/OraDBHome21cXE/network/admin/tnsnames.ora
/*2.	Соединитесь при помощи sqlplus с Oracle как пользователь SYSTEM, получите перечень параметров экземпляра Oracle.*/
--SHOW PARAMETER INSTANCE
/*3.	Соединитесь при помощи sqlplus с подключаемой базой данных как пользователь SYSTEM, получите список табличных пространств, файлов табличных пространств, ролей и пользователей.*/
--select * from v$tablespace;
--select * from dba_data_files;
--select * from dba_temp_files;
--select * from all_users;
--select * from dba_role_privs;
/*4.	Ознакомьтесь с параметрами в HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE на вашем компьютере.*/
/*5.	Запустите утилиту Oracle Net Manager и подготовьте строку подключения с именем имя_вашего_пользователя_SID, где SID – идентификатор подключаемой базы данных. */
--/opt/oracle/oradata/dbconfig/XE/tnsnames.ora
/*6.	Подключитесь с помощью sqlplus под собственным пользователем и с применением подготовленной строки подключения. */
sqlplus sys/SMI_SID as sysdba
/*7.	Выполните select к любой таблице, которой владеет ваш пользователь. */
create table newtable(
y number(6),
z varchar(10)
);

insert into newtable values(9,'h');
insert into newtable values(3,'g');
insert into newtable values(1,'w');

drop table newtable;
select * from newtable;
/*8.	Ознакомьтесь с командой HELP.Получите справку по команде TIMING. Подсчитайте, сколько времени длится select к любой таблице.*/
HELP
HELP TIMING
SET TIMING ON
select * from all_users;
/*9.	Ознакомьтесь с командой DESCRIBE.Получите описание столбцов любой таблицы.*/
help describe
DESCRIBE DBA_USERS;
/*10.	Получите перечень всех сегментов, владельцем которых является ваш пользователь.*/
SELECT SEGMENT_NAME, SEGMENT_TYPE, OWNER, TABLESPACE_NAME, BYTES, BLOCKS FROM DBA_SEGMENTS WHERE OWNER = 'SYSTEM';
/*11.	Создайте представление, в котором получите количество всех сегментов, количество экстентов, блоков памяти и размер в килобайтах, которые они занимают.*/
create or replace VIEW all_segments AS select owner, count(*) as segments_count, sum(extents) as total_extents, sum(blocks) as total_blocks, sum(bytes)/1024 as total_bytes from dba_segments group by owner, SEGMENT_TYPE;
select * from all_segments;

