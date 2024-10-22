/*1.	Определите общий размер области SGA*/
select sum(value) from v$sga;
/*2.	Определите текущие размеры основных пулов SGA.*/
select * from v$sga;
/*3.	Определите размеры гранулы для каждого пула.*/
select 
component,
current_size,
last_oper_mode,
last_oper_time,
granule_size,
current_size/granule_size as Ratio
from v$sga_dynamic_components;
/*4.	Определите объем доступной свободной памяти в SGA.*/
select current_size from v$sga_dynamic_free_memory;
/*5.	Определите максимальный и целевой размер области SGA.*/
select name, value from v$parameter where name in ('sga_target', 'sga_max_size');
--show parameter sga
/*6.	Определите размеры пулов КЕЕP, DEFAULT и RECYCLE  буферного кэша.*/
select component, current_size, max_size, min_size from v$sga_dynamic_components where component like '%КЕЕP%' or component like '%DEFAULT%' or component like '%RECYCLE%';
/*7.	Создайте таблицу, которая будет помещаться в пул КЕЕP. Продемонстрируйте сегмент таблицы.*/
create table task_seven(
n number(10)
) storage (buffer_pool keep); 
drop table task_seven

insert into task_seven (n) values (3);
insert into task_seven (n) values (6);
insert into task_seven (n) values (2);
select * from task_seven;
drop table task_seven;

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where segment_name = 'TASK_SEVEN';
/*8.	Создайте таблицу, которая будет кэшироваться в пуле DEFAULT. Продемонстрируйте сегмент таблицы. */
create table task_eight(
n number(10)
) storage (buffer_pool default);
insert into task_eight (n) values (3);
insert into task_eight (n) values (6);
insert into task_eight (n) values (2);
select * from task_eight;

drop table task_eight;

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where segment_name = 'TASK_EIGHT';
/*9.	Найдите размер буфера журналов повтора.*/
select name, hash from v$parameter where name = 'log_buffer';
--show parameter log_buffer;
/*10.	Найдите размер свободной памяти в большом пуле.*/
select * from v$sgastat where name = 'free memory' and pool = 'large pool';
/*11.	Определите режимы текущих соединений с инстансом (dedicated, shared).*/
select username, sid, server, status from v$session where username is not null;
/*12.	Получите полный список работающих в настоящее время фоновых процессов*/
select name, description from v$bgprocess where paddr!=hextoraw('00') order by name;
/*13.	Получите список работающих в настоящее время серверных процессов.*/
select * from v$process;
/*14.	Определите, сколько процессов DBWn работает в настоящий момент.*/
select count(*) from v$bgprocess where paddr!='00' and name like '%DBW%';
/*15.	Определите сервисы (точки подключения экземпляра).*/
select * from v$services;
/*16.	Получите известные вам параметры диспетчеров.*/
select * from v$dispatcher;
/*17.	Укажите в списке Windows-сервисов сервис, реализующий процесс LISTENER. */
--lsnrctl status
/*18.	Продемонстрируйте и поясните содержимое файла LISTENER.ORA.     */
--cat /opt/oracle/homes/OraDBHome21cXE/network/admin/listener.ora
--Файл listener.ora конфигурирует Oracle LISTENER, который принимает соединения по указанным адресам и управляет сервисами базы данных. В вашем случае LISTENER принимает соединения как локально (через IPC), так и по сети (через TCP) на стандартном порту 1521, и по умолчанию обрабатывает сервис XE.
/*19.	Запустите утилиту lsnrctl и поясните ее основные команды. */
--lsnrctl
--start           stop            status          services
--servacls        version         reload          save_config
--trace           spawn           quit            exit
--set*            show*
/*20.	Получите список служб инстанса, обслуживаемых процессом LISTENER. */
select name from dba_services; 