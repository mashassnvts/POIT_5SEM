/*1.	������� �� ���������� ���������������� ����� SQLNET.ORA � TNSNAMES.ORA � ������������ � �� ����������.*/
--cat /opt/oracle/homes/OraDBHome21cXE/network/admin/sqlnet.ora
--cat /opt/oracle/homes/OraDBHome21cXE/network/admin/tnsnames.ora
/*2.	����������� ��� ������ sqlplus � Oracle ��� ������������ SYSTEM, �������� �������� ���������� ���������� Oracle.*/
--SHOW PARAMETER INSTANCE
/*3.	����������� ��� ������ sqlplus � ������������ ����� ������ ��� ������������ SYSTEM, �������� ������ ��������� �����������, ������ ��������� �����������, ����� � �������������.*/
--select * from v$tablespace;
--select * from dba_data_files;
--select * from dba_temp_files;
--select * from all_users;
--select * from dba_role_privs;
/*4.	������������ � ����������� � HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE �� ����� ����������.*/
/*5.	��������� ������� Oracle Net Manager � ����������� ������ ����������� � ������ ���_������_������������_SID, ��� SID � ������������� ������������ ���� ������. */
--/opt/oracle/oradata/dbconfig/XE/tnsnames.ora
/*6.	������������ � ������� sqlplus ��� ����������� ������������� � � ����������� �������������� ������ �����������. */
sqlplus sys/SMI_SID as sysdba
/*7.	��������� select � ����� �������, ������� ������� ��� ������������. */
create table newtable(
y number(6),
z varchar(10)
);

insert into newtable values(9,'h');
insert into newtable values(3,'g');
insert into newtable values(1,'w');

drop table newtable;
select * from newtable;
/*8.	������������ � �������� HELP.�������� ������� �� ������� TIMING. �����������, ������� ������� ������ select � ����� �������.*/
HELP
HELP TIMING
SET TIMING ON
select * from all_users;
/*9.	������������ � �������� DESCRIBE.�������� �������� �������� ����� �������.*/
help describe
DESCRIBE DBA_USERS;
/*10.	�������� �������� ���� ���������, ���������� ������� �������� ��� ������������.*/
SELECT SEGMENT_NAME, SEGMENT_TYPE, OWNER, TABLESPACE_NAME, BYTES, BLOCKS FROM DBA_SEGMENTS WHERE OWNER = 'SYSTEM';
/*11.	�������� �������������, � ������� �������� ���������� ���� ���������, ���������� ���������, ������ ������ � ������ � ����������, ������� ��� ��������.*/
create or replace VIEW all_segments AS select owner, count(*) as segments_count, sum(extents) as total_extents, sum(blocks) as total_blocks, sum(bytes)/1024 as total_bytes from dba_segments group by owner, SEGMENT_TYPE;
select * from all_segments;

