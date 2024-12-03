--1. �������� � ������� TEACHERS ��� ������� BIRTHDAY� SALARY, ��������� �� ����������.
alter table TEACHER add BIRTHDAY DATE;
alter table TEACHER add SALARY NUMBER;

select * from TEACHER;

UPDATE TEACHER SET BIRTHDAY = '12-02-1959' WHERE TEACHER = '����';
UPDATE TEACHER SET BIRTHDAY = '30-01-1987' WHERE TEACHER = '�����';
UPDATE TEACHER SET BIRTHDAY = '19-04-1991' WHERE TEACHER = '�����';
UPDATE TEACHER SET BIRTHDAY = '16-04-1964' WHERE TEACHER = '����';
UPDATE TEACHER SET BIRTHDAY = '19-11-1988' WHERE TEACHER = '����';
UPDATE TEACHER SET BIRTHDAY = '05-10-1966' WHERE TEACHER = '�����';
UPDATE TEACHER SET BIRTHDAY = '10-08-1976' WHERE TEACHER = '���';
UPDATE TEACHER SET BIRTHDAY = '11-09-1989' WHERE TEACHER = '���';
UPDATE TEACHER SET BIRTHDAY = '24-12-1983' WHERE TEACHER = '���';
UPDATE TEACHER SET BIRTHDAY = '03-06-1990' WHERE TEACHER = '����';
UPDATE TEACHER SET BIRTHDAY = '10-05-1970' WHERE TEACHER = '������';
UPDATE TEACHER SET BIRTHDAY = '26-10-1999' WHERE TEACHER = '?';
UPDATE TEACHER SET BIRTHDAY = '30-07-1984' WHERE TEACHER = '���';
UPDATE TEACHER SET BIRTHDAY = '11-03-1975' WHERE TEACHER = '���';
UPDATE TEACHER SET BIRTHDAY = '12-07-1969' WHERE TEACHER = '������';
UPDATE TEACHER SET BIRTHDAY = '26-02-1983' WHERE TEACHER = '�����';
UPDATE TEACHER SET BIRTHDAY = '13-12-1991' WHERE TEACHER = '������';
UPDATE TEACHER SET BIRTHDAY = '20-01-1968' WHERE TEACHER = '����';
UPDATE TEACHER SET BIRTHDAY = '21-12-1969' WHERE TEACHER = '����';
UPDATE TEACHER SET BIRTHDAY = '28-01-1975' WHERE TEACHER = '����';
UPDATE TEACHER SET BIRTHDAY = '10-07-1983' WHERE TEACHER = '������';
UPDATE TEACHER SET BIRTHDAY = '08-10-1988' WHERE TEACHER = '���';
UPDATE TEACHER SET BIRTHDAY = '30-07-1984' WHERE TEACHER = '�����';
UPDATE TEACHER SET BIRTHDAY = '16-04-1964' WHERE TEACHER = '������';
UPDATE TEACHER SET BIRTHDAY = '12-05-1985' WHERE TEACHER = '������';
UPDATE TEACHER SET BIRTHDAY = '20-10-1980' WHERE TEACHER = '�����';
UPDATE TEACHER SET BIRTHDAY = '21-08-1990' WHERE TEACHER = '���';
UPDATE TEACHER SET BIRTHDAY = '13-08-1966' WHERE TEACHER = '����';
UPDATE TEACHER SET BIRTHDAY = '11-11-1978' WHERE TEACHER = '����';

UPDATE TEACHER SET SALARY = 1030 WHERE TEACHER = '����';
UPDATE TEACHER SET SALARY = 1030 WHERE TEACHER = '�����';
UPDATE TEACHER SET SALARY = 980 WHERE TEACHER = '�����';
UPDATE TEACHER SET SALARY = 1050 WHERE TEACHER = '����';
UPDATE TEACHER SET SALARY = 590 WHERE TEACHER = '����';
UPDATE TEACHER SET SALARY = 870 WHERE TEACHER = '�����';
UPDATE TEACHER SET SALARY = 815 WHERE TEACHER = '���';
UPDATE TEACHER SET SALARY = 995 WHERE TEACHER = '���';
UPDATE TEACHER SET SALARY = 1460 WHERE TEACHER = '���';
UPDATE TEACHER SET SALARY = 1120 WHERE TEACHER = '����';
UPDATE TEACHER SET SALARY = 1250 WHERE TEACHER = '������';
UPDATE TEACHER SET SALARY = 333 WHERE TEACHER = '?';
UPDATE TEACHER SET SALARY = 1520 WHERE TEACHER = '���';
UPDATE TEACHER SET SALARY = 1430 WHERE TEACHER = '���';
UPDATE TEACHER SET SALARY = 900 WHERE TEACHER = '������';
UPDATE TEACHER SET SALARY = 875 WHERE TEACHER = '�����';
UPDATE TEACHER SET SALARY = 970 WHERE TEACHER = '������';
UPDATE TEACHER SET SALARY = 780 WHERE TEACHER = '����';
UPDATE TEACHER SET SALARY = 1150 WHERE TEACHER = '����';
UPDATE TEACHER SET SALARY = 805 WHERE TEACHER = '����';
UPDATE TEACHER SET SALARY = 905 WHERE TEACHER = '������';
UPDATE TEACHER SET SALARY = 1200 WHERE TEACHER = '���';
UPDATE TEACHER SET SALARY = 1500 WHERE TEACHER = '�����';
UPDATE TEACHER SET SALARY = 905 WHERE TEACHER = '������';
UPDATE TEACHER SET SALARY = 715 WHERE TEACHER = '������';
UPDATE TEACHER SET SALARY = 880 WHERE TEACHER = '�����';
UPDATE TEACHER SET SALARY = 735 WHERE TEACHER = '���';
UPDATE TEACHER SET SALARY = 595 WHERE TEACHER = '����';
UPDATE TEACHER SET SALARY = 850 WHERE TEACHER = '����';
--2. �������� ������ �������������� � ���� ������� �.�.
select regexp_substr(teacher_name, '(\S+)', 1, 1) || ' ' || substr(regexp_substr(teacher_name, '(\S+)', 1, 2), 1, 1) || '. ' || substr(regexp_substr(teacher_name, '(\S+)', 1, 3), 1, 1) || '. ' as ��� from teacher;
--3. �������� ������ ��������������, ���������� � �����������.
select * from teacher where to_char(birthday, 'd') = 2;
--4. �������� �������������, � ������� ��������� ������ ��������������, ������� �������� � ��������� ������.
create or replace view next_month as
select * from TEACHER where TO_CHAR(birthday, 'mm') = (select substr(to_char(trunc(last_day(sysdate)) + 1), 4, 2) from dual);

select * from next_month;
--5. �������� �������������, � ������� ��������� ���������� ��������������, ������� �������� � ������ ������.
create or replace view number_months as
select to_char(birthday, 'Month') �����, count(*) ���������� from teacher group by to_char(birthday, 'Month') having count(*) >= 1
order by ���������� desc;

select * from number_months;
--6. ������� ������ � ������� ������ ��������������, � ������� � ��������� ���� ������.
declare
cursor teacher_birthday
return teacher%rowtype is
select * from teacher where MOD(extract(YEAR from sysdate) - extract(YEAR from birthday) + 1, 5) = 0;
v_teacher  TEACHER%rowtype;
begin
open teacher_birthday;
fetch teacher_birthday into v_teacher;
while (teacher_birthday%found)
loop
dbms_output.put_line(v_teacher.teacher || ' ' || v_teacher.teacher_name || ' ' || v_teacher.pulpit || ' ' || v_teacher.birthday || ' ' || v_teacher.salary);
fetch teacher_birthday into v_teacher;
end loop;
close teacher_birthday;
end;
--7. ������� ������ � ������� ������� ���������� ����� �� �������� � ����������� ���� �� �����, ������� ������� �������� �������� ��� ������� ���������� � ��� ���� ����������� � �����.
declare
cursor teachers_avg_salary is
select pulpit, floor(avg(salary)) as AVG_SALARY from TEACHER group by pulpit;
cursor faculty_avg_salary is select FACULTY, AVG(SALARY) from TEACHER
join PULPIT P on TEACHER.PULPIT = P.PULPIT group by FACULTY;
cursor faculties_avg_salary is select AVG(SALARY) from TEACHER;
m_pulpit  TEACHER.PULPIT%type;
m_salary  TEACHER.SALARY%type;
m_faculty PULPIT.FACULTY%type;
begin
dbms_output.put_line('--------------- �� �������� -----------------');
open teachers_avg_salary;
fetch teachers_avg_salary into m_pulpit, m_salary;
while (teachers_avg_salary%found)
loop
dbms_output.put_line(m_pulpit || ' ' || m_salary);
fetch teachers_avg_salary into m_pulpit, m_salary;
end loop;
close teachers_avg_salary;
dbms_output.put_line('--------------- �� ����������� -----------------');
open faculty_avg_salary;
fetch faculty_avg_salary into m_faculty, m_salary;
while (faculty_avg_salary%found)
loop
dbms_output.put_line(m_faculty || ' ' || m_salary);
fetch faculty_avg_salary into m_faculty, m_salary;
end loop;
close faculty_avg_salary;
dbms_output.put_line('--------------- �� ���� ����������� -----------------');
open faculties_avg_salary;
fetch faculties_avg_salary into m_salary;
dbms_output.put_line(round(m_salary, 2));
close faculties_avg_salary;
end;
--8. �������� ����������� ��� PL/SQL-������ (record) � ����������������� ������ � ���. ����������������� ������ � ���������� ��������. ����������������� � ��������� �������� ����������. 
declare
type person_record is record (
name varchar2(100),
age number);

type family_record is record (
father person_record,
mother person_record,
child person_record);

myfamily family_record;
begin
myfamily.father.name := 'papa';
myfamily.father.age := 40;
myfamily.mother.name := 'mama';
myfamily.mother.age := 38;
myfamily.child.name := 'child';
myfamily.child.age := 10;
dbms_output.put_line('����: ' || myfamily.father.name || ', �������: ' || myfamily.father.age);
dbms_output.put_line('����: ' || myfamily.mother.name || ', �������: ' || myfamily.mother.age);
dbms_output.put_line('�������: ' || myfamily.child.name || ', �������: ' || myfamily.child.age);
end;