--1. ������������ ��, ��������������� ������ ��������� SELECT � ������ ��������. 
declare
faculty_rec faculty%rowtype;
begin
select * into faculty_rec from faculty where faculty = '���';
dbms_output.put_line(rtrim(faculty_rec.faculty) || ': ' || faculty_rec.faculty_name);
exception
when others then
dbms_output.put_line('error = ' || sqlerrm);
end;
--2. ������������ ��, ��������������� ������ ��������� SELECT � �������� ������ ��������. ����������� ����������� WHEN OTHERS ������ ���������� � ���������� ������� SQLERRM, SQLCODE ��� ���������������� �������� �������.
declare 
faculty_rec faculty%rowtype;
begin
select * into faculty_rec from faculty;
dbms_output.put_line(rtrim(faculty_rec.faculty) || ': ' || faculty_rec.faculty_name);
exception
when others then
dbms_output.put_line('error = ' || sqlerrm || sqlcode);
end;
--3. ������������ ��, ��������������� ������ ����������� WHEN TO_MANY_ROWS ������ ���������� ��� ���������������� �������� �������. 
declare 
faculty_rec faculty%rowtype;
begin
select * into faculty_rec from faculty;
dbms_output.put_line(rtrim(faculty_rec.faculty) || ': ' || faculty_rec.faculty_name);
exception
when too_many_rows
then dbms_output.put_line('error too_many_rows:' || sqlerrm || sqlcode);
end;
--4. ������������ ��, ��������������� ������������� � ��������� ���������� NO_DATA_FOUND. ������������ ��, ��������������� ���������� ��������� �������� �������.
declare 
faculty_rec faculty%rowtype;
begin
select * into faculty_rec from faculty where faculty = 'XXX';
dbms_output.put_line(rtrim(faculty_rec.faculty) || ': ' || faculty_rec.faculty_name);
exception
when no_data_found
then dbms_output.put_line('error no_data_found:' || sqlerrm || sqlcode);
when others then
dbms_output.put_line(sqlerrm);
end;
declare
faculty_rec faculty%rowtype;
begin
select * into faculty_rec from faculty where faculty = '���';
dbms_output.put_line(rtrim(faculty_rec.faculty) || ': ' || faculty_rec.faculty_name);
if sql%found then
dbms_output.put_line('%found:     true');
else
dbms_output.put_line('%found:     false');
end if;

if sql%isopen then
dbms_output.put_line('$isopen:    true');
else
dbms_output.put_line('$isopen:    false');
end if;

if sql%notfound then
dbms_output.put_line('%notfound:  true');
else
dbms_output.put_line('%notfound:  false');
end if;
dbms_output.put_line('%rowcount:  ' || sql%rowcount);
end;
--5. ������������ ��, ��������������� ���������� ��������� UPDATE ��������� � ����������� COMMIT/ROLLBACK. 
begin
update auditorium
set auditorium = '206-1',
auditorium_name     = '206-1',
auditorium_capacity = 90,
auditorium_type     = '��-�'
where auditorium = '206-3';
--commit;
rollback;
exception
when others
then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end;

select * from auditorium where auditorium like '206%';

delete from auditorium where auditorium like '206%';
--6. ����������������� �������� UPDATE, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
begin
update auditorium
set auditorium_capacity = 'asd' where auditorium = '206-3';
exception
when others then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end;

select * from auditorium;
--7. ������������ ��, ��������������� ���������� ��������� INSERT ��������� � ����������� COMMIT/ROLLBACK.
begin
insert into auditorium VALUES ('11-4', '11-4', 85, '��');
commit;
insert into auditorium VALUES ('11-4', '11-4', 85, '��');
rollback;
exception
when others then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end;
select * from auditorium where auditorium like '11%';

delete from auditorium where auditorium like '11-4%';
--8. ����������������� �������� INSERT, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
begin
insert into auditorium VALUES ('11-4', '11-4', '���', '��');
commit;
exception
when others then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end;
--9. ������������ ��, ��������������� ���������� ��������� DELETE ��������� � ����������� COMMIT/ROLLBACK.
insert into auditorium VALUES ('11-4', '11-4', 85, '��');
select * from auditorium where auditorium like '11%';

begin
delete from auditorium where auditorium = '11-4';
commit;
delete from auditorium where auditorium like '11-4';
rollback;
exception
when others then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end;
--10. ����������������� �������� DELETE, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
begin
delete from auditorium_type where auditorium_type = '����';
if(sql%rowcount = 0) then
raise no_data_found;
end if;
exception
when others then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end;

select * from AUDITORIUM_TYPE;
--11. �������� ��������� ����, ��������������� ������� TEACHER � ����������� ������ ������� LOOP-�����. ��������� ������ ������ ���� �������� � ����������, ����������� � ����������� ����� %TYPE.
declare
cursor curs_teach is select teacher, teacher_name, pulpit from teacher;
m_teacher teacher.teacher%type;
m_teacher_name teacher.teacher_name%type;
m_pulpit teacher.pulpit%type;
begin
open curs_teach;
loop
fetch curs_teach into m_teacher, m_teacher_name, m_pulpit;
exit when curs_teach%notfound;
dbms_output.put_line(' ' || curs_teach%rowcount || ' ' || m_teacher || ' ' || m_teacher_name || ' ' || m_pulpit);
end loop;
close curs_teach;
exception
when others then dbms_output.put_line(sqlerrm);
end;
--12. �������� ��, ��������������� ������� SUBJECT � ����������� ������ ������� �WHILE-�����. ��������� ������ ������ ���� �������� � ������ (RECORD), ����������� � ����������� ����� %ROWTYPE.
declare
cursor curs_subject is select subject, subject_name, pulpit from subject;
rec_subject subject%rowtype;
begin
open curs_subject;
dbms_output.put_line('rowcount = ' || curs_subject%rowcount);
fetch curs_subject into rec_subject;
while(curs_subject%found)
loop
dbms_output.put_line(' ' || curs_subject%rowcount || ' ' || rec_subject.subject || ' ' || rec_subject.subject_name || ' ' || rec_subject.pulpit);
fetch curs_subject into rec_subject;
end loop;
dbms_output.put_line('rowcount = ' || curs_subject%rowcount);
close curs_subject;
exception
when others then dbms_output.put_line(sqlerrm);
end;
--13. �������� ��, ��������������� ��� ������� (������� PULPIT) � ������� ���� �������������� (TEACHER) �����������, ���������� (JOIN) PULPIT � TEACHER � � ����������� ������ ������� � FOR-�����.
declare
cursor curs_pulpit is select pulpit.pulpit, teacher.teacher_name from pulpit
join teacher on pulpit.pulpit = teacher.pulpit;
rec_pulpit curs_pulpit%rowtype;
begin
for rec_pulpit in curs_pulpit
loop
dbms_output.put_line(' ' || curs_pulpit%rowcount || ' ' || rec_pulpit.pulpit || ' ' || rec_pulpit.teacher_name);
end loop;
exception
when others then
dbms_output.put_line(sqlerrm);
end;
--14. �������� ��, ��������������� ��������� ������ ���������: ��� ��������� (������� AUDITORIUM) � ������������ ������ 20, �� 21-30, �� 31-60, �� 61 �� 80, �� 81 � ����. ��������� ������ � ����������� � ��� ������� ����������� ����� �� ������� �������.
declare
cursor curs (capacity auditorium.auditorium_capacity%type, capacity1 auditorium.auditorium_capacity%type)
is select auditorium, auditorium_capacity, auditorium_type from auditorium
where auditorium_capacity >= capacity and auditorium_capacity <= capacity1;
record curs%rowtype;
begin
dbms_output.put_line('capacity < 20 :');
for aum in curs(0, 20)
loop
dbms_output.put_line(aum.auditorium || ' ');
end loop;

dbms_output.put_line('21 < capacity < 30 :');
open curs(21, 30);
fetch curs into record;
while curs%found
loop
dbms_output.put_line(record.auditorium || ' ');
fetch curs into record;
end loop;
close curs;

dbms_output.put_line('31 < capacity < 60 :');
for aum in curs(31, 60)
loop
dbms_output.put_line(aum.auditorium || ' ');
end loop;

dbms_output.put_line('61 < capacity < 80 :');
open curs(61, 80);
fetch curs into record;
loop
dbms_output.put_line(record.auditorium || ' ');
fetch curs into record;
exit when curs%notfound;
end loop;
close curs;

dbms_output.put_line('81 < capacity:');
for aum in curs(81, 1000)
loop
dbms_output.put_line(aum.auditorium || ' ');
end loop;
exception
when others
then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end;
--15. �������� A�. �������� ��������� ���������� � ������� ���������� ���� refcursor. ����������������� �� ���������� ��� ������� c �����������. 
declare
type auditorium_ref is ref cursor return auditorium%rowtype;
xcurs auditorium_ref;
xcurs_row xcurs%rowtype;
begin
open xcurs for select * from auditorium;
fetch xcurs into xcurs_row;
loop
exit when xcurs%notfound;
dbms_output.put_line(' ' || xcurs_row.auditorium || ' ' || xcurs_row.auditorium_capacity);
fetch xcurs into xcurs_row;
end loop;
close xcurs;
exception
when others then dbms_output.put_line(sqlerrm);
end;
--16. �������� A�. ����������������� ������� ��������� ���������?
declare
cursor curs_aut is select auditorium_type, cursor (select auditorium from auditorium aum where aut.auditorium_type = aum.auditorium_type) from auditorium_type aut;
curs_aum sys_refcursor;
aut auditorium_type.auditorium_type%type;
txt varchar2(1000);
aum auditorium.auditorium%type;
begin
open curs_aut;
fetch curs_aut into aut, curs_aum;
while(curs_aut%found)
loop
txt := rtrim(aut) || ': ';

loop
fetch curs_aum into aum;
exit when curs_aum%notfound;
txt := txt || rtrim(aum) || '; ';
end loop;

dbms_output.put_line(txt);
fetch curs_aut into aut, curs_aum;
end loop;

close curs_aut;
exception
when others then
dbms_output.put_line(sqlerrm);
end;
--17. �������� A�. ��������� ����������� ���� ��������� (������� AUDITORIUM) ������������ �� 40 �� 80 �� 10%. ����������� ����� ������ � �����������, ���� FOR, ����������� UPDATE CURRENT OF. 
select * from auditorium order by auditorium;
declare
cursor auditorium_cursor (start_capacity auditorium.auditorium_capacity%type, end_capacity auditorium.auditorium_capacity%type) is select auditorium, auditorium_capacity from auditorium where auditorium_capacity >= start_capacity and auditorium_capacity <= end_capacity for update;
auditorium_column auditorium.auditorium%type;
auditorium_capacity_column auditorium.auditorium_capacity%type;

begin
open auditorium_cursor(40, 80);
fetch auditorium_cursor into auditorium_column, auditorium_capacity_column;
while (auditorium_cursor%found) loop
auditorium_capacity_column := auditorium_capacity_column * 0.9;
update auditorium 
set auditorium_capacity = auditorium_capacity_column where current of auditorium_cursor;
dbms_output.put_line(auditorium_column || ' ' || auditorium_capacity_column);
fetch auditorium_cursor into auditorium_column, auditorium_capacity_column;
end loop;
close auditorium_cursor;
rollback;

exception
when others then 
dbms_output.put_line(sqlerrm);
end;
--18. �������� A�. ������� ��� ��������� (������� AUDITORIUM) ������������ �� 0 �� 20. ����������� ����� ������ � �����������, ���� WHILE, ����������� UPDATE CURRENT OF. 
declare
cursor auditorium_cursor (start_capacity auditorium.auditorium_capacity%type, end_capacity auditorium.auditorium_capacity%type) is select auditorium, auditorium_capacity from auditorium where auditorium_capacity >= start_capacity and auditorium_capacity <= end_capacity for update;
auditorium_column auditorium.auditorium%type;
auditorium_capacity_column auditorium.auditorium_capacity%type;
begin
open auditorium_cursor(0, 20);
fetch auditorium_cursor into auditorium_column, auditorium_capacity_column;
while (auditorium_cursor%found) loop
delete from auditorium where current of auditorium_cursor;
dbms_output.put_line(auditorium_column || ' ' || auditorium_capacity_column);
fetch auditorium_cursor into auditorium_column, auditorium_capacity_column;
end loop;
close auditorium_cursor;
commit;

exception
when others then 
dbms_output.put_line(sqlerrm);
end;


select auditorium, auditorium_capacity from auditorium order by auditorium_capacity;
--19. �������� A�. ����������������� ���������� ������������� ROWID � ���������� UPDATE � DELETE. 
declare
cursor cur(capacity auditorium.AUDITORIUM_CAPACITY%type)is select auditorium, auditorium_capacity, rowid from auditorium where auditorium_capacity >= capacity for update;
aum auditorium.auditorium%type;
cap auditorium.auditorium_capacity%type;
begin
for xxx in cur(80)
loop
if xxx.auditorium_capacity >= 90
then
delete auditorium where rowid = xxx.rowid and xxx.auditorium_capacity >= 90;
elsif xxx.auditorium_capacity >= 40
then
update auditorium
set auditorium_capacity = auditorium_capacity + 3 where rowid = xxx.rowid;
end if;
end loop;
for yyy in cur(80)
loop
dbms_output.put_line(yyy.auditorium || ' ' || yyy.auditorium_capacity);
end loop;
commit;
--rollback;
end;
--20. ������������ � ����� ����� ���� �������������� (TEACHER), �������� �������� �� ��� (�������� ������ ������ -------------). 
declare
cursor curs_teachers is select TEACHER, TEACHER_NAME, PULPIT from teacher;
m_teacher      teacher.teacher%type;
m_teacher_name teacher.teacher_name%type;
m_pulpit       teacher.pulpit%type;
begin
open curs_teachers;
loop
fetch curs_teachers into m_teacher, m_teacher_name, m_pulpit;
exit when curs_teachers%notfound;
dbms_output.put_line(' ' || curs_teachers%rowcount || ' ' || m_teacher || ' ' || m_teacher_name || ' ' || m_pulpit);
if (mod(curs_teachers%rowcount, 3) = 0) then
dbms_output.put_line('-----------------------');
end if;
end loop;
close curs_teachers;
exception
when others
then dbms_output.put_line(sqlcode || ' ' || sqlerrm);
end;