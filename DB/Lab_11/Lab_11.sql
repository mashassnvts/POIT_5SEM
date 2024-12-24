--1. ������������ ��������� ��������� 
--GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
--��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), ���������� �� ������� �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
declare
procedure get_teachers(pcode teacher.pulpit%type) as
begin
for i in (select * from teacher where pulpit = pcode)
loop
dbms_output.put_line(i.TEACHER_NAME);
end loop;
end get_teachers;
begin
get_teachers('����');
end;
--2. ������������ ��������� ������� 
--3. GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
--RETURN NUMBER
--������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� ������� �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
declare
function get_num_teachers(pcode teacher.pulpit%type) return number
is num number := 0;
begin
select count(*) into num from teacher where pulpit = pcode;
return num;
end get_num_teachers;
begin
dbms_output.put_line(get_num_teachers('����'));
end;
--4. ������������ ���������:
--GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), ���������� �� ����������, �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
--��������� ������ �������� ������ ��������� �� ������� SUBJECT, ������������ �� ��������, �������� ����� ������� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
declare procedure get_teachers (fcode faculty.faculty%type)
as begin
for i in (select * from teacher join pulpit ON teacher.pulpit = pulpit.pulpit where faculty = fcode)
loop
dbms_output.put_line(i.teacher ||  i.teacher_name || i.faculty);
end loop;
end;
begin
get_teachers('����');
end;


declare procedure get_subjects(pcode subject.pulpit%type) as
begin 
for i in (select * from subject where pulpit= pcode)
loop
dbms_output.put_line(i.subject_name || ' ' || i.pulpit);
end loop;
end;
begin
get_subjects('����');
end;
--5. ������������ ��������� ������� 
--GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--RETURN NUMBER
--������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� ����������, �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
--GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER ������� ������ �������� ���������� ��������� �� ������� SUBJECT, ������������ �� ��������, �������� ����� ������� ���������. ������������ ��������� ���� � ����������������� ���������� ���������. 
declare
function get_num_teachers(fcode faculty.faculty%type) return number
is
num number := 0;
begin
select count(*) into num from teacher
inner join PULPIT P on P.PULPIT = TEACHER.PULPIT
inner join FACULTY F on F.FACULTY = P.FACULTY
where F.FACULTY = fcode;
return num;
end get_num_teachers;
begin
dbms_output.put_line(get_num_teachers('����'));
end;

create or replace function get_num_subjects(pcode subject.pulpit%type) return number
is
num number := 0;
begin
select count(*) into num from subject
inner join PULPIT P on P.PULPIT = SUBJECT.PULPIT where P.PULPIT = pcode;
return num;
end;
begin
dbms_output.put_line(get_num_subjects('����'));
end;
--6. ������������ ����� TEACHERS, ���������� ��������� � �������:
--GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
--GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 
create or replace package teachers as
procedure get_teachers (fcode faculty.faculty%type);
procedure get_subjects(pcode subject.pulpit%type);
function get_num_teachers (fcode faculty.faculty%type)return number;
function get_num_subjects(pcode subject.pulpit%type)return number;
end;

create or replace package body teachers as
procedure get_teachers(fcode faculty.faculty%type) is
begin
for i in (select * from teacher join pulpit on teacher.pulpit = pulpit.pulpit where faculty = fcode)
loop
dbms_output.put_line(i.teacher || ' ' || i.teacher_name || ' ' || i.faculty);
end loop;
end get_teachers;

procedure get_subjects(pcode subject.pulpit%type) is
begin
for i in (select * from subject where pulpit = pcode)
loop
dbms_output.put_line(i.subject_name || ' ' || i.pulpit);
end loop;
end get_subjects;

function get_num_teachers(fcode faculty.faculty%type) return number is
num number := 0;
begin
select count(*) into num from teacher inner join pulpit p on p.pulpit = teacher.pulpit inner join faculty f on f.faculty = p.faculty where f.faculty = fcode;
return num;
end get_num_teachers;

function get_num_subjects(pcode subject.pulpit%type) return number is
num number := 0;
begin
select count(*) into num from subject inner join pulpit p on p.pulpit = subject.pulpit where p.pulpit = pcode;
return num;
end get_num_subjects;
end teachers;
--7. ������������ ��������� ���� � ����������������� ���������� �������� � ������� ������ TEACHERS.
begin
teachers.get_subjects('����');
teachers.get_teachers('����');
dbms_output.put_line(teachers.get_num_teachers('����'));
dbms_output.put_line(teachers.get_num_subjects('����'));
end;


