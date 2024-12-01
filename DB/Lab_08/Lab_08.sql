-- sqlplus SMI/12345@localhost:1521/XEPDB1
GRANT ALL PRIVILEGES TO SMI;
--1.	������������ ���������� ��������� ���� PL/SQL (��), �� ���������� ����������. 
begin
null;
end;
--2.	������������ ��, ��������� �Hello World!�. ��������� ��� � SQLDev � SQL+.
begin 
dbms_output.put_line('hello world'); 
end;
/
--SET SERVEROUTPUT ON;
--3.	����������������� ������ ���������� � ���������� ������� sqlerrm, sqlcode.
begin
declare
x number (3) := 3;
y number (3) := 0;
z number;
begin
dbms_output.put_line('x= ' || x || ', y= ' || y);
z := x/y;
dbms_output.put_line('z= '|| z);
exception
when others
then dbms_output.put_line('Error = '|| sqlerrm || ', SQLCODE of the error = ' || sqlcode);
end;
end;
--4.	������������ ��������� ����. ����������������� ������� ��������� ���������� �� ��������� ������.
begin
declare
z number(10,2) := 21;
begin
begin
z := 5/0;
exception
when OTHERS
then dbms_output.put_line('SQLCODE of the error = ' || sqlcode || chr(10) || 'Error message = ' || sqlerrm);
end;
dbms_output.put_line('z = '||z);
end;
end;
--5.	��������, ����� ���� �������������� ����������� �������������� � ������ ������.
--sys
select name, value from v$parameter where name = 'plsql_warnings';
--6.	������������ ������, ����������� ����������� ��� ����������� PL/SQL.
--sys
select keyword from v$reserved_words where length = 1;
--7.	������������ ������, ����������� ����������� ��� �������� �����  PL/SQL.
--sys
select keyword from v$reserved_words where length > 1 order by keyword;
--8.	������������ ������, ����������� ����������� ��� ��������� Oracle Server, ��������� � PL/SQL. ����������� ��� �� ��������� � ������� SQL+-������� show.
--sys
--show parameter plsqpl;
select name, value from v$parameter where name like 'plsqpl%';
--9.	������������ ��������� ����, ��������������� (��������� � �������� ��������� ����� ����������):
--10.	���������� � ������������� ����� number-����������;
--11.	�������������� �������� ��� ����� ������ number-����������, ������� ������� � ��������;
--12.	���������� � ������������� number-���������� � ������������� ������;
--13.	���������� � ������������� number-���������� � ������������� ������ � ������������� ��������� (����������);
declare
n_number number(7) := 35;
m_number number(7) := 12;
z_number number(7);
begin
z_number := n_number - m_number;
dbms_output.put_line('���������: ' || z_number);
z_number := MOD(n_number, m_number);
dbms_output.put_line('�������: ' || z_number);
end;
declare
float_number number(5,2) := 3.1458;
floatt_number number (5,-2) := 226;
begin
dbms_output.put_line('������: ' || float_number);
dbms_output.put_line('������: ' || floatt_number);
end;
--14.	���������� � ������������� BINARY_FLOAT-����������;
--15.	���������� � ������������� BINARY_DOUBLE-����������;
declare 
bin_fl BINARY_FLOAT := 655.55645;
binn_fll binary_double := 1234.555567;
begin
dbms_output.put_line('�����: ' || bin_fl);
dbms_output.put_line('������: ' || binn_fll);
end;
--16.	���������� number-���������� � ������ � ����������� ������� E (������� 10) ��� �������������/����������;
--17.	���������� � ������������� BOOLEAN-����������. 
declare
e_num number := 1.23E-3;
booool BOOLEAN := TRUE;
begin
dbms_output.put_line('e: ' || e_num);
dbms_output.put_line('�����: ' || case when booool then 'TRUE' else 'FALSE' end);    
end;
--18.	������������ ��������� ���� PL/SQL ���������� ���������� �������� (VARCHAR2, CHAR, NUMBER). �����������������  ��������� �������� �����������.  
declare
s_const constant nvarchar2(20) := '����';  -- ��������� ���������
c_const constant char := 'M';                -- ���������� ���������
n_const constant number := 14;               -- �������� ���������
begin
dbms_output.put_line('������������: ' || s_const || ' ' || c_const);
dbms_output.put_line('������� �� ���:' || n_const / 3);  
dbms_output.put_line('��������� �� ���: ' || n_const * 3);  
dbms_output.put_line('M: ' || c_const); 
end;
--19.	������������ ��, ���������� ���������� � ������ %TYPE. ����������������� �������� �����.
declare
v_faculty FACULTY.FACULTY%TYPE;
v_faculty_name FACULTY.FACULTY_NAME%TYPE;
v_pulpit PULPIT.PULPIT%TYPE;
v_pulpit_name PULPIT.PULPIT_NAME%TYPE;
v_teacher TEACHER.TEACHER%TYPE;
v_teacher_name TEACHER.TEACHER_NAME%TYPE;
BEGIN
  -- �����������, ��� �� �������� ������ �� ������
SELECT FACULTY, FACULTY_NAME INTO v_faculty, v_faculty_name FROM FACULTY WHERE ROWNUM = 1;
SELECT PULPIT, PULPIT_NAME INTO v_pulpit, v_pulpit_name FROM PULPIT WHERE ROWNUM = 1;
SELECT TEACHER, TEACHER_NAME INTO v_teacher, v_teacher_name FROM TEACHER WHERE ROWNUM = 1;

DBMS_OUTPUT.PUT_LINE('FACULTY: ' || v_faculty || ', FACULTY_NAME: ' || v_faculty_name);
DBMS_OUTPUT.PUT_LINE('PULPIT: ' || v_pulpit || ', PULPIT_NAME: ' || v_pulpit_name);
DBMS_OUTPUT.PUT_LINE('TEACHER: ' || v_teacher || ', TEACHER_NAME: ' || v_teacher_name);
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('��� ������.');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
END;
--20.	������������ ��, ���������� ���������� � ������ %ROWTYPE. ����������������� �������� �����.
DECLARE
rec FACULTY%ROWTYPE;
BEGIN
SELECT * INTO rec FROM FACULTY WHERE FACULTY = '����';
DBMS_OUTPUT.PUT_LINE('FACULTY: ' || rec.FACULTY);
DBMS_OUTPUT.PUT_LINE('FACULTY_NAME: ' || rec.FACULTY_NAME);
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('��� ������.');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
END;
--21.	������������ ��, ��������������� ��� ��������� ����������� ��������� IF .
--22.	������������ ��, ��������������� ��� ��������� ����������� ��������� IF .
DECLARE
num NUMBER := 10;
BEGIN
  -- IF-THEN
IF num > 0 THEN
DBMS_OUTPUT.PUT_LINE('����� �������������.');
END IF;
  -- IF-THEN-ELSE
IF num > 0 THEN
DBMS_OUTPUT.PUT_LINE('����� �������������.');
ELSE
DBMS_OUTPUT.PUT_LINE('����� �� �������������.');
END IF;
  -- IF-THEN-ELSIF
IF num > 0 THEN
DBMS_OUTPUT.PUT_LINE('����� �������������.');
ELSIF num < 0 THEN
DBMS_OUTPUT.PUT_LINE('����� �������������.');
ELSE
DBMS_OUTPUT.PUT_LINE('����� ����� ����.');
END IF;
END;
--23.	������������ ��, ��������������� ������ ��������� CASE.
DECLARE
num NUMBER := 1;  -- ������������� ���������� num
BEGIN
LOOP
DBMS_OUTPUT.PUT_LINE('��������: ' || num);
CASE num
WHEN 1 THEN
DBMS_OUTPUT.PUT_LINE('������ �����.');
WHEN 2 THEN
DBMS_OUTPUT.PUT_LINE('������ �����.');
WHEN 3 THEN
DBMS_OUTPUT.PUT_LINE('������ �����.');
WHEN 4 THEN
DBMS_OUTPUT.PUT_LINE('�������� �����.');
WHEN 5 THEN
DBMS_OUTPUT.PUT_LINE('����� �����.');
ELSE
DBMS_OUTPUT.PUT_LINE('����� ������ 5.');
END CASE;
 
num := num + 1; 
EXIT WHEN num > 5;  
END LOOP;
END;
/
--24.	������������ ��, ��������������� ������ ��������� LOOP.
-- ������������ ��� ���������� ����� ���� �� ��� ���, ���� �� ����� ��������� ������� ������. 
DECLARE
num NUMBER := 1;
BEGIN
LOOP
DBMS_OUTPUT.PUT_LINE('��������: ' || num);
num := num + 1;
EXIT WHEN num > 5;
END LOOP;
END;
--25.	������������ ��, ��������������� ������ ��������� WHILE.
DECLARE
num NUMBER := 1;
BEGIN
WHILE num <= 5 LOOP
DBMS_OUTPUT.PUT_LINE('��������: ' || num);
num := num + 1;
END LOOP;
END;
/
--26.	������������ ��, ��������������� ������ ��������� FOR.
BEGIN
FOR num IN 1..5 LOOP
DBMS_OUTPUT.PUT_LINE('��������: ' || num);
END LOOP;
END;
