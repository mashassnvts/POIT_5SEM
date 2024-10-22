/*1.	���������� ����� ������ ������� SGA*/
select sum(value) from v$sga;
/*2.	���������� ������� ������� �������� ����� SGA.*/
select * from v$sga;
/*3.	���������� ������� ������� ��� ������� ����.*/
select 
component,
current_size,
last_oper_mode,
last_oper_time,
granule_size,
current_size/granule_size as Ratio
from v$sga_dynamic_components;
/*4.	���������� ����� ��������� ��������� ������ � SGA.*/
select current_size from v$sga_dynamic_free_memory;
/*5.	���������� ������������ � ������� ������ ������� SGA.*/
select name, value from v$parameter where name in ('sga_target', 'sga_max_size');
--show parameter sga
/*6.	���������� ������� ����� ���P, DEFAULT � RECYCLE  ��������� ����.*/
select component, current_size, max_size, min_size from v$sga_dynamic_components where component like '%���P%' or component like '%DEFAULT%' or component like '%RECYCLE%';
/*7.	�������� �������, ������� ����� ���������� � ��� ���P. ����������������� ������� �������.*/
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
/*8.	�������� �������, ������� ����� ������������ � ���� DEFAULT. ����������������� ������� �������. */
create table task_eight(
n number(10)
) storage (buffer_pool default);
insert into task_eight (n) values (3);
insert into task_eight (n) values (6);
insert into task_eight (n) values (2);
select * from task_eight;

drop table task_eight;

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where segment_name = 'TASK_EIGHT';
/*9.	������� ������ ������ �������� �������.*/
select name, hash from v$parameter where name = 'log_buffer';
--show parameter log_buffer;
/*10.	������� ������ ��������� ������ � ������� ����.*/
select * from v$sgastat where name = 'free memory' and pool = 'large pool';
/*11.	���������� ������ ������� ���������� � ��������� (dedicated, shared).*/
select username, sid, server, status from v$session where username is not null;
/*12.	�������� ������ ������ ���������� � ��������� ����� ������� ���������*/
select name, description from v$bgprocess where paddr!=hextoraw('00') order by name;
/*13.	�������� ������ ���������� � ��������� ����� ��������� ���������.*/
select * from v$process;
/*14.	����������, ������� ��������� DBWn �������� � ��������� ������.*/
select count(*) from v$bgprocess where paddr!='00' and name like '%DBW%';
/*15.	���������� ������� (����� ����������� ����������).*/
select * from v$services;
/*16.	�������� ��������� ��� ��������� �����������.*/
select * from v$dispatcher;
/*17.	������� � ������ Windows-�������� ������, ����������� ������� LISTENER. */
--lsnrctl status
/*18.	����������������� � �������� ���������� ����� LISTENER.ORA.     */
--cat /opt/oracle/homes/OraDBHome21cXE/network/admin/listener.ora
--���� listener.ora ������������� Oracle LISTENER, ������� ��������� ���������� �� ��������� ������� � ��������� ��������� ���� ������. � ����� ������ LISTENER ��������� ���������� ��� �������� (����� IPC), ��� � �� ���� (����� TCP) �� ����������� ����� 1521, � �� ��������� ������������ ������ XE.
/*19.	��������� ������� lsnrctl � �������� �� �������� �������. */
--lsnrctl
--start           stop            status          services
--servacls        version         reload          save_config
--trace           spawn           quit            exit
--set*            show*
/*20.	�������� ������ ����� ��������, ������������� ��������� LISTENER. */
select name from dba_services; 