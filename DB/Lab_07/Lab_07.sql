create user SMI identified by 12345 account unlock;
grant create materialized view, create view, create public synonym, create any synonym, create cluster, create session, create sequence, create table to smi;
grant drop any materialized view, drop any view, drop public synonym, drop any synonym, drop any cluster, drop any sequence to smi;
alter user SMI default tablespace users quota unlimited on users;
drop user TEST cascade

create user SMI identified by 12345 account unlock;
GRANT CREATE MATERIALIZED VIEW, CREATE VIEW, CREATE PUBLIC SYNONYM, CREATE ANY SYNONYM, CREATE CLUSTER, CREATE SESSION,
    CREATE SEQUENCE, CREATE TABLE TO SMI;

GRANT DROP ANY MATERIALIZED VIEW, DROP ANY VIEW, DROP PUBLIC SYNONYM, DROP ANY SYNONYM, DROP ANY CLUSTER,
    DROP ANY SEQUENCE TO SMI;

ALTER USER SMI DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

--2.	�������� ������������������ S1 (SEQUENCE), �� ���������� ����������������: ��������� �������� 1000; ���������� 10; ��� ������������ ��������; 
--��� ������������� ��������; �� �����������; �������� �� ���������� � ������; ���������� �������� �� �������������. �������� ��������� �������� ������������������. 
--�������� ������� �������� ������������������.
create SEQUENCE S1
start with 1000
increment by 10
nominvalue
nomaxvalue
nocycle
nocache
noorder;

drop SEQUENCE S1
select S1.NEXTVAL from dual;
select S1.CURRVAL from dual;
--3.	�������� ������������������ S2 (SEQUENCE), �� ���������� ����������������: ��������� �������� 10; ���������� 10; ������������ �������� 100; 
--4.	�� �����������. �������� ��� �������� ������������������. ����������� �������� ��������, ��������� �� ������������ ��������.
create SEQUENCE S2
start with 10
increment by 10
maxvalue 100
nocycle
nocache
noorder;

drop SEQUENCE S2;
select S2.NEXTVAL from dual;
select S2.CURRVAL from dual;
--5.	�������� ������������������ S3 (SEQUENCE), �� ���������� ����������������: ��������� �������� 10; ���������� -10; ����������� �������� -100; �� �����������; ������������� ���������� ��������. 
--�������� ��� �������� ������������������. ����������� �������� ��������, ������ ������������ ��������.
create SEQUENCE S3
start with 10
increment by -10
minvalue -100
maxvalue 100
nocycle
order;

select S3.NEXTVAL from DUAL;
select S3.CURRVAL from DUAL;
drop SEQUENCE S3;
--6.	�������� ������������������ S4 (SEQUENCE), �� ���������� ����������������: ��������� �������� 1; ���������� 1; ����������� �������� 10; �����������; ���������� � ������ 5 ��������; ���������� �������� �� �������������. 
--����������������� ����������� ��������� �������� ������������������� S4.
create SEQUENCE S4
start with 1
increment by 1
maxvalue 10
cycle
cache 5
noorder;

select S4.NEXTVAL from DUAL;
select S4.CURRVAL from DUAL;
drop SEQUENCE S4
--7.	�������� ������ ���� ������������������� � ������� ���� ������, ���������� ������� �������� ������������ XXX.
SELECT sequence_name FROM all_sequences WHERE sequence_owner = 'SMI';
--8.	�������� ������� T1, ������� ������� N1, N2, N3, N4, ���� NUMBER (20), ���������� � ������������� � �������� ���� KEEP. � ������� ��������� INSERT �������� 7 �����, 
--�������� �������� ��� �������� ������ ������������� � ������� ������������������� S1, S2, S3, S4.
create table T1(
N1 NUMBER(20),
N2 NUMBER(20),
N3 NUMBER(20),
N4 NUMBER(20)
)CACHE STORAGE ( BUFFER_POOL KEEP );

INSERT INTO T1 (N1, N2, N3, N4) VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
INSERT INTO T1 (N1, N2, N3, N4) VALUES (S1.nextval, S2.nextval, S3.nextval, S4.nextval);
INSERT INTO T1 (N1, N2, N3, N4) VALUES (S1.nextval, S2.nextval, S3.nextval, S4.nextval);
INSERT INTO T1 (N1, N2, N3, N4) VALUES (S1.nextval, S2.nextval, S3.nextval, S4.nextval);
INSERT INTO T1 (N1, N2, N3, N4) VALUES (S1.nextval, S2.nextval, S3.nextval, S4.nextval);
INSERT INTO T1 (N1, N2, N3, N4) VALUES (S1.nextval, S2.nextval, S3.nextval, S4.nextval);
INSERT INTO T1 (N1, N2, N3, N4) VALUES (S1.nextval, S2.nextval, S3.nextval, S4.nextval);

SELECT * FROM T1;
drop table T1;
---- ��������� ������������������ S2 ��� ���������� �����������
--ALTER SEQUENCE S2 CYCLE;
--9.	�������� ������� ABC, ������� hash-��� (������ 200) � ���������� 2 ����: X (NUMBER (10)), V (VARCHAR2(12)).
create cluster ABC(
x number(10),
v varchar(12)
)hashkeys 200;
--10.	�������� ������� A, ������� ������� XA (NUMBER (10)) � VA (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.
create table A(
XA NUMBER(10),
VA VARCHAR2(12),
EXTRA_COLUMN VARCHAR2(50)
) CLUSTER ABC (XA, VA);
--11.	�������� ������� B, ������� ������� XB (NUMBER (10)) � VB (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.
CREATE TABLE B (
XB NUMBER(10),
VB VARCHAR2(12),
EXTRA_COLUMN_B VARCHAR2(50)
) CLUSTER ABC (XB, VB);
--12.	�������� ������� �, ������� ������� X� (NUMBER (10)) � V� (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������. 
CREATE TABLE C (
XC NUMBER(10),
VC VARCHAR2(12),
EXTRA_COLUMN_C VARCHAR2(50)
) CLUSTER ABC (XC, VC);

drop table A;
drop table B;
drop table C;
DROP cluster ABC;

INSERT INTO C (XC, VC, EXTRA_COLUMN_C) VALUES (1, 'ValueC1', 'ExtraC1');
--13.	������� ��������� ������� � ������� � �������������� ������� Oracle.
select * from user_tables where table_name in ('A', 'B', 'C');
select * from user_clusters where cluster_name = 'ABC';
--14.	�������� ������� ������� ��� ������� XXX.� � ����������������� ��� ����������.
CREATE SYNONYM SYNONC FOR C;
DROP SYNONYM SYNONC;
    
SELECT * FROM SYNONC;
--15.	�������� ��������� ������� ��� ������� XXX.B � ����������������� ��� ����������.
INSERT INTO B (XB, VB, EXTRA_COLUMN_B) VALUES (1, 'ValueB1', 'ExtraB1');
CREATE PUBLIC SYNONYM SYNONW FOR B;
DROP PUBLIC SYNONYM SYNONW;
SELECT * FROM SYNONW;
--16.	�������� ��� ������������ ������� A � B (� ��������� � ������� �������), ��������� �� �������, �������� ������������� V1, ���������� �� SELECT... FOR A inner join B. ����������������� ��� �����������������.
CREATE TABLE hello
(
    Some_number number(2) primary key,
    Some_string nvarchar2(20)
);
-- DROP TABLE hello;

CREATE TABLE helloo
(
    Second_string nvarchar2(20),
    Second_number number(2),
    constraint Some_number_fk foreign key (Second_number) references hello(Some_number)
);
INSERT INTO hello (Some_number, Some_string) VALUES (1, 'First string');
INSERT INTO hello (Some_number, Some_string) VALUES (2, 'Second string');
INSERT INTO helloo (Second_string, Second_number) VALUES ('First string', 1);
INSERT INTO helloo (Second_string, Second_number) VALUES ('Second string', 2);

CREATE VIEW V1 AS SELECT * FROM hello JOIN helloo St on hello.Some_number = St.Second_number;
SELECT * FROM V1;

-- DROP VIEW V1;
-- DROP TABLE helloo;
--17.	�� ������ ������ A � B �������� ����������������� ������������� MV, ������� ����� ������������� ���������� 2 ������. ����������������� ��� �����������������.
CREATE MATERIALIZED VIEW MV
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND NEXT SYSDATE + NUMTODSINTERVAL(2, 'MINUTE') AS SELECT *  FROM A INNER JOIN B ON A.XA = B.XB;

drop table A;
select * from A;
select * from B;
INSERT INTO A (XA, VA, EXTRA_COLUMN) VALUES (1, 'ValueA1', 'Extra1');
INSERT INTO B (XB, VB, EXTRA_COLUMN_B) VALUES (1, 'ValueB1', 'ExtraB1');

UPDATE A SET VA = 'UpdatedVale' WHERE XA = 1;
EXEC DBMS_MVIEW.REFRESH('MV');
select * from MV;
DROP MATERIALIZED VIEW MV;
