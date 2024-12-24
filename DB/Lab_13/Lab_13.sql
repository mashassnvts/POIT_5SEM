grant create tablespace, drop tablespace to smi;
alter user smi quota unlimited on first_tablespace;
alter user smi quota unlimited on second_tablespace;
alter user smi quota unlimited on third_tablespace;
alter user smi quota unlimited on fouth_tablespace;

create tablespace first_tablespace
datafile 'first.dbf'
size 7 m 
autoextend on
maxsize unlimited 
extent management local;

create tablespace second_tablespace
datafile 'second_tablespace.dbf' 
size 7 m 
autoextend on
maxsize unlimited 
extent management local;

create tablespace third_tablespace
datafile 'third_tablespace.dbf' 
size 7 m 
autoextend on
maxsize unlimited 
extent management local;


create tablespace fouth_tablespace
datafile 'fouth_tablespace.dbf' 
size 7 m 
autoextend on
maxsize unlimited 
extent management local;
drop table parent_tab

create table parent_tab (
parent_id number not null,
parent_name varchar2 (30) not null,
local_transaction_time timestamp not null,
constraint pk_parent primary key (parent_id))
partition by range (local_transaction_time) (
partition p0 values less than (timestamp' 2009-02-07 00:00:00'),
partition p1 values less than (timestamp' 2009-02-08 00:00:00'),
partition p2s values less than (timestamp' 2009-02-09 00:00:00'))
enable row movement;


create table child_tab
(
child_id number,
pid number not null,
classification number,
constraint pk_child primary key (child_id),
constraint fk_child_to_parent foreign key (pid) references parent_tab (parent_id)
)partition by reference (fk_child_to_parent)
enable row movement;


insert into parent_tab values(1,'parent x', timestamp' 2009-02-08 00:00:00')
insert into child_tab values(1,1,0)

commit;
select partition_name from user_tab_partitions where table_name = 'CHILD_TAB'

select parent_id, local_transaction_time,
case 
when local_transaction_time < timestamp '2009-02-07 00:00:00' then 'p0'
when local_transaction_time < timestamp '2009-02-08 00:00:00' then 'p1'
when local_transaction_time < timestamp '2009-02-09 00:00:00' then 'p2'
 else '����������� ��������'
end as partition_name
from parent_tab;

--1.	�������� ������� T_RANGE c ����������� ����������������. ����������� ���� ��������������� ���� NUMBER. 
drop table t_range;
create table t_range (
id number,
name varchar2(50)
)

partition by range (id)(
partition p0 values less than (5) tablespace first_tablespace,
partition p1 values less than (15) tablespace second_tablespace,
partition p2 values less than (25) tablespace third_tablespace,
partition p3 values less than (maxvalue) tablespace fouth_tablespace
);

insert into t_range (id, name) values (1, 'fsdvd');
insert into t_range (id, name) values (9, 'fsdvd');
insert into t_range (id, name) values (13, 'fsdvd');
insert into t_range (id, name) values (23, 'fsdvd');
insert into t_range (id, name) values (29, 'fsdvd');

commit;

select * from t_range partition(p0);
select * from t_range partition(p1);
select * from t_range partition(p2);
select * from t_range partition(p3);
--2.	�������� ������� T_INTERVAL c ������������ ����������������. ����������� ���� ��������������� ���� DATE.
drop table t_interval;
create table t_interval(
id date,
name varchar2(50)
)
partition by range (id)
interval(numtoyminterval(1, 'month'))
(
partition p0 values less than (to_date('2020-01-01', 'yyyy-mm-dd')) tablespace first_tablespace,
partition p1 values less than (to_date('2021-02-02', 'yyyy-mm-dd')) tablespace second_tablespace,
partition p2 values less than (to_date('2022-03-03', 'yyyy-mm-dd')) tablespace third_tablespace,
partition p3 values less than (to_date('2023-04-04', 'yyyy-mm-dd')) tablespace fouth_tablespace
);

insert into t_interval (id, name) values('11-11-2019', 'hghghg');
insert into t_interval (id, name) values ('11-11-2020', 'prprpr');
insert into t_interval (id, name) values ('11-11-2021', 'kdkdkd');
insert into t_interval (id, name) values ('05-04-2023', 'alalal');
commit;

select * from t_interval partition (p0);
select * from t_interval partition (p1);
select * from t_interval partition (p2);
select * from t_interval partition (p3);
--3.	�������� ������� T_HASH c ���-����������������. ����������� ���� ��������������� ���� VARCHAR2.
create table t_hash (
id number,
name varchar2(50)
)

partition by hash (name) (
partition p0 tablespace first_tablespace,
partition p1 tablespace second_tablespace,
partition p2 tablespace third_tablespace,
partition p3 tablespace fouth_tablespace
);

insert into t_hash (id, name) values (1, 'one');
insert into t_hash (id, name) values (2, 'two');
insert into t_hash (id, name) values (3, 'three');
insert into t_hash (id, name) values (4, 'fourth');
insert into t_hash (id, name) values (5, 'five');
insert into t_hash (id, name) values (6, 'six');
insert into t_hash (id, name) values (7, 'seven');
insert into t_hash (id, name) values (8, 'eight');
commit;

select * from t_hash partition (p0);
select * from t_hash partition (p1);
select * from t_hash partition (p2);
select * from t_hash partition (p3);
--4.	�������� ������� T_LIST �� ��������� ����������������. ����������� ���� ��������������� ���� CHAR.
create table t_list (
id number,
name char(1)
)
partition by list (name)(
partition p0 values ('a') tablespace first_tablespace,
partition p1 values ('b') tablespace second_tablespace,
partition p2 values ('c') tablespace third_tablespace,
partition p3 values (default) tablespace fouth_tablespace
);

insert into t_list (id, name) values (1, 'a');
insert into t_list (id, name) values (2, 'b');
insert into t_list (id, name) values (3, 'c');
insert into t_list (id, name) values (4, 'd');
insert into t_list (id, name) values (5, 'e');
commit;

select * from t_list partition (p0);
select * from t_list partition (p1);
select * from t_list partition (p2);
select * from t_list partition (p3);
--5.	������� � ������� ���������� INSERT ������ � ������� T_RANGE, T_INTERVAL, T_HASH, T_LIST. ������ ������ ���� ������, ����� ��� ������������ �� ���� �������. ����������������� ��� � ������� SELECT �������.
--6.	����������������� ��� ���� ������ ������� ����������� ����� ����� ��������, ��� ��������� (�������� UPDATE) ����� ���������������.
alter table t_range enable row movement;
select * from t_range partition (p0);
update t_range set name = 'name 3' where id =1;
select * from t_range partition (p0);
select * from t_range partition (p1);

alter table t_interval enable row movement;
select * from t_interval partition (p0);
update t_interval set id = '11-12-2020' where name = 'hghghg';
select * from t_interval partition (p0);
select * from t_interval partition (p1);
rollback;

alter table t_hash enable row movement;
select * from t_hash partition (p0);
update t_hash set name = 'new fourth' where id =4;
select * from t_hash partition (p0);
select * from t_hash partition (p1);
select * from t_hash partition (p2);
select * from t_hash partition (p3);

alter table t_list enable row movement;
select * from t_list partition (p0);
update t_list set name = 'z' where id = 1;
select * from t_list partition (p0);
select * from t_list partition (p1);
select * from t_list partition (p2);
select * from t_list partition (p3);
--7.	��� ����� �� ������ ����������������� �������� ��������� ALTER TABLE MERGE.
alter table t_range merge partitions p0, p1 into partition partition_merge tablespace first_tablespace;
select * from t_range partition (partition_merge);
--8.	��� ����� �� ������ ����������������� �������� ��������� ALTER TABLE SPLIT.
alter table t_range split partition partition_merge at (14) into (
partition p0 tablespace third_tablespace, 
partition p1 tablespace fouth_tablespace
);
select * from t_range partition (p0);
select * from t_range partition (p1);
select * from t_range partition (p2);
select * from t_range partition (p3);
--9.	��� ����� �� ������ ����������������� �������� ��������� ALTER TABLE EXCHANGE.
create table example(
id number,
name varchar2(50)
);

alter table t_range exchange partition p0 with table example with validation;
select * from example;
select * from t_range partition (p0);