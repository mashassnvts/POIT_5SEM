GRANT CREATE TRIGGER TO SMI;
GRANT INSERT, UPDATE, DELETE ON first_table TO SMI;

--1.	�������� �������, ������� ��������� ���������, ���� �� ������� ��������� ����.
create table first_table(
id int primary key,
name varchar2(30)
);
--2.	��������� ������� �������� (10 ��.).
begin
for i in 1 .. 10
loop
insert into first_table values(i, 'hello');
end loop;
end;

select * from first_table;
--3.	�������� BEFORE � ������� ������ ��������� �� ������� INSERT, DELETE � UPDATE. 
create or replace trigger before_insert
before insert on first_table
begin
dbms_output.put_line('before_insert');
end;

create or replace trigger before_delete
before delete on first_table
begin
dbms_output.put_line('before_delete');
end;

create or replace trigger before_update
before update on first_table
begin
dbms_output.put_line('before_update');
end;

select * from first_table;

insert into first_table values(11, 'hello, world');
insert into first_table values(12, 'hello, world');
delete from first_table where id = 11;
update first_table set name = 'update hello' where id = 11;
--4.	���� � ��� ����������� �������� ������ �������� ��������� �� ��������� ������� (DMS_OUTPUT) �� ����� ����������� ������. 
--5.	�������� BEFORE-������� ������ ������ �� ������� INSERT, DELETE � UPDATE.
create or replace trigger before_insert_row
before insert on first_table
for each row
begin
dbms_output.put_line('before_insert_row');
end;

create or replace trigger before_update_row
before update on first_table
for each row
begin
dbms_output.put_line('before_update_row');
end;

create or replace trigger before_delete_row
before delete on first_table
for each row
begin
dbms_output.put_line('before_delete_row');
end;

select * from first_table;

insert into first_table values(12, 'hello, friend');
delete from first_table where id = 12;
update first_table set name = 'update hello' where id = 12;
--6.	��������� ��������� INSERTING, UPDATING � DELETING.
create or replace trigger trigger_dml
before insert on first_table
begin
if inserting then
dbms_output.put_line('trigger_dml_inserting');
elsif updating then
dbms_output.put_line('trigger_dml_updating');
elsif deleting then
dbms_output.put_line('trigger_dml_deleting');
end if;
end;

select * from first_table;

insert into first_table values(13, 'hello, friend');
delete from first_table where id = 13;
update first_table set name = 'update hello' where id = 13;
--7.	������������ AFTER-�������� ������ ��������� �� ������� INSERT, DELETE � UPDATE.
create or replace trigger after_insert
after insert on first_table
begin
dbms_output.put_line('after_insert');
end;

create or replace trigger after_delete
after delete on first_table
begin
dbms_output.put_line('after_delete');
end;

create or replace trigger after_update
after update on first_table
begin
dbms_output.put_line('after_update');
end;

select * from first_table;

insert into first_table values(14, 'hello, friend');
delete from first_table where id = 14;
update first_table set name = 'update hello' where id = 14;
--8.	������������ AFTER-�������� ������ ������ �� ������� INSERT, DELETE � UPDATE.
create or replace trigger after_insert_row
after insert on first_table
for each row
begin
dbms_output.put_line('after_insert_row');
end;

create or replace trigger after_update_row
after update on first_table
for each row
begin
dbms_output.put_line('after_update_row');
end;

create or replace trigger after_delete_row
after delete on first_table
for each row
begin
dbms_output.put_line('after_delete_row');
end;

select * from first_table;

insert into first_table values(12, 'hello, friend');
delete from first_table where id = 12;
update first_table set name = 'update hello' where id = 12;
--9.	�������� ������� � ������ AUDIT. ������� ������ ��������� ����: OperationDate, 
--OperationType (�������� �������, ���������� � ��������),
--TriggerName(��� ��������),
--Data (������ � ���������� ����� �� � ����� ��������).
create table AUDIT_(
OperationDate date,
OperationType varchar2(30),
TriggerName varchar2(30),
Data varchar2(50)
);
--10.	�������� �������� ����� �������, ����� ��� �������������� ��� �������� � �������� �������� � ������� AUDIT.
create or replace trigger dml_before_row
before insert or update or delete
on first_table for each row
begin
if inserting then
dbms_output.put_line('dml_before_row insert');
insert into AUDIT_ (operationdate, operationtype, triggername, data)
values (sysdate, 'insert', 'dml_before_row', :new.id || ' ' || :new.name);
elsif updating then
dbms_output.put_line('dml_before_row update');
insert into AUDIT_ (operationdate, operationtype, triggername, data)
values (sysdate, 'update', 'dml_before_row', :old.id || ' ' || :old.name || '->' || :new.id || ' ' || :new.name);
elsif deleting then
dbms_output.put_line('dml_before_trigger_row delete');
insert into AUDIT_ (operationdate, operationtype, triggername, data)
values (sysdate, 'delete', 'dml_before_row', :old.id || ' ' || :old.name);
end if;
end;

create or replace trigger dml_after_row
after insert or update or delete
on first_table for each row
begin
if inserting then
dbms_output.put_line('dml_after_row insert');
insert into AUDIT_ (operationdate, operationtype, triggername, data)
values (sysdate, 'insert', 'dml_after_row', :new.id || ' ' || :new.name);
elsif updating then
dbms_output.put_line('dml_after_row update');
insert into AUDIT_ (operationdate, operationtype, triggername, data)
values (sysdate, 'update', 'dml_after_row', :old.id || ' ' || :old.name || '->' || :new.id || ' ' || :new.name);
elsif deleting then
dbms_output.put_line('dml_after_row delete');
insert into AUDIT_ (operationdate, operationtype, triggername, data)
values (sysdate, 'delete', 'dml_after_row', :old.id || ' ' || :old.name);
end if;
end;

create or replace trigger dml_before
before insert or update or delete on first_table for each row
begin
if inserting then
dbms_output.put_line('dml_before insert');
insert into AUDIT_ (operationdate, operationtype, triggername, data)
values (sysdate, 'insert', 'dml_before', :new.id || ' ' || :new.name);
elsif updating then
dbms_output.put_line('dml_before update');
insert into AUDIT_ (operationdate, operationtype, triggername, data)
values (sysdate, 'update', 'dml_before', :old.id || ' ' || :old.name || '->' || :new.id || ' ' || :new.name);
elsif deleting then
dbms_output.put_line('dml_before delete');
insert into AUDIT_ (operationdate, operationtype, triggername, data)
values (sysdate, 'delete', 'dml_before', :old.id || ' ' || :old.name);
end if;
end;

create or replace trigger dml_after
after insert or update or delete on first_table for each row
begin
if inserting then
dbms_output.put_line('dml_after insert');
insert into AUDIT_ (operationdate, operationtype, triggername, data)
values (sysdate, 'insert', 'dml_after', :new.id || ' ' || :new.name);
elsif updating then
dbms_output.put_line('dml_after update');
insert into AUDIT_ (operationdate, operationtype, triggername, data)
values (sysdate, 'update', 'dml_after', :old.id || ' ' || :old.name || '->' || :new.id || ' ' || :new.name);
elsif deleting then
dbms_output.put_line('dml_after delete');
insert into AUDIT_ (operationdate, operationtype, triggername, data)
values (sysdate, 'delete', 'dml_after', :old.id || ' ' || :old.name);
end if;
end;

select * from first_table;
select * from AUDIT_;
insert into first_table (id, name) values (21, 'New text');
update first_table set name = 'Updated text' where id = 21;
delete from first_table where id = 21;
--11.	��������� ��������, ���������� ����������� ������� �� ���������� �����. ��������, ��������������� �� ������� ��� �������. ��������� ���������.
--�������� �������������� ������� ������ � ������ ��������� ���������� ��������. ���� ���������� ������, �������� �� ������ ��������� ���� ��������.
insert into first_table (id, name) values (1, 'qqq');
--12.	������� (drop) �������� �������. ��������� ���������. �������� �������, ����������� �������� �������� �������.
drop table first_table;


CREATE OR REPLACE TRIGGER prevent_drop_table
BEFORE DROP ON SCHEMA
BEGIN
IF dictionary_obj_name = 'FIRST_TABLE' THEN
RAISE_APPLICATION_ERROR(-20000, 'You cannot drop the table first_table');
END IF;
END;
select * from first_table;
drop trigger prevent_drop_table;

create table first_table(
id int primary key,
name varchar2(30)
);

begin
for i in 1 .. 10
loop
insert into first_table values(i, 'hello');
end loop;
end;
--13.	������� (drop) ������� AUDIT. ����������� ��������� ��������� � ������� SQL-DEVELOPER. ��������� ���������. �������� ��������.
drop table AUDIT_;
--14.	�������� ������������� ��� �������� ��������. ������������ INSTEADOF INSERT-�������. ������� ������ ��������� ������ � �������.
create view first_table_view as select * from first_table;

create or replace trigger instead_of_insert_trigger
instead of insert on first_table_view
begin
if inserting then
dbms_output.put_line('instead_of_insert_trigger');
insert into first_table (id, name) values (50, 'qppqpqpqppqp');
end if;
end instead_of_insert_trigger;

insert into first_table_view (id, name) values (25, 'newwewe');
select * from first_table;
--15.	�����������������, � ����� ������� ����������� ��������.