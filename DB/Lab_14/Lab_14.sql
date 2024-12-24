GRANT CREATE JOB TO smi;
GRANT MANAGE SCHEDULER TO smi;
--1.	–азработайте пакет выполнени€ заданий, в котором:
DROP TABLE export_table;
DROP TABLE import_table;
DROP TABLE job_status;
    

create table export_table (
id integer,
some_string nvarchar2(50)
);

create table import_table (
id integer,
some_string nvarchar2(50)
);

create table job_status (
status nvarchar2(50),
error_message nvarchar2(700),
date_of_message date default sysdate
);

insert into export_table (id, some_string) values (1, 'first string');
insert into export_table (id, some_string) values (2, 'second string');
insert into export_table (id, some_string) values (3, 'third string');
insert into export_table (id, some_string) values (4, 'fourth string');
commit;
select * from export_table;
select * from import_table;
--2.	–аз в неделю в определенное врем€ выполн€етс€ копирование части данных по условию из одной таблицы в другую, после чего эти данные из первой таблицы удал€ютс€. 
--3.	Ќеобходимо провер€ть, было ли выполнено задание, и в какой-либо таблице сохран€ть сведени€ о попытках выполнени€, как успешных, так и неуспешных.
create or replace procedure procedure_for_job
is  cursor cursor_for_job is select * from export_table; error_message varchar2(700);
begin
for row in cursor_for_job 
loop
insert into import_table (id, some_string) values (row.id, row.some_string);
end loop;
delete from export_table;
insert into job_status (status, date_of_message) values ('success', sysdate);
commit;
exception 
when others then
error_message := sqlerrm;
insert into job_status (status, error_message) values ('failure', error_message);
commit;
end procedure_for_job;

declare 
job_number user_jobs.job%type;
begin
dbms_job.submit(job_number, 'begin procedure_for_job; end;', sysdate, 'sysdate + 7');
commit;
sys.dbms_output.put_line(job_number);
end;

select * from job_status;
select * from export_table;
select * from import_table;
--4.	Ќеобходимо провер€ть, выполн€етс€ ли сейчас это задание.
select job, what, last_date, last_sec, next_date, next_sec, next_date, broken from user_jobs;

--5.	Ќеобходимо дать возможность выполн€ть задание в другое врем€, приостановить или отменить вообще.
begin
dbms_job.run(6);
end;

select * from job_status;
select * from export_table;
select * from import_table;

begin
dbms_job.remove(6);
end;

--6.	–азработайте пакет, функционально аналогичный пакету из задани€ 1-5. »спользуйте пакет DBMS_SHEDULER. 
begin
dbms_scheduler.create_schedule(
schedule_name => 'schedule_1', 
start_date => sysdate, 
repeat_interval => 'freq=weekly', 
comments => 'schedule_1 weekly'
);
end;

select * from user_scheduler_schedules;

begin
dbms_scheduler.create_program(
program_name => 'program_1', 
program_type => 'stored_procedure', 
program_action => 'procedure_for_job', 
number_of_arguments => 0, 
enabled => true, 
comments => 'program_1'
);
end;

select * from user_scheduler_programs;

begin
dbms_scheduler.create_job(
job_name => 'scheduler_job_1', 
program_name => 'program_1', 
schedule_name => 'schedule_1', 
enabled => true
);
end;

select * from user_scheduler_jobs;

begin
dbms_scheduler.disable('scheduler_job_1');
end;

begin
dbms_scheduler.enable('scheduler_job_1');
end;

begin
dbms_scheduler.run_job('scheduler_job_1');
end;

select * from job_status;

begin
dbms_scheduler.drop_job('scheduler_job_1');
end;





BEGIN
    DBMS_SCHEDULER.DROP_SCHEDULE('schedule_1', force => TRUE);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Schedule does not exist or could not be dropped: ' || SQLERRM);
END;

BEGIN
    DBMS_SCHEDULER.DROP_PROGRAM('program_1', force => TRUE);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Program does not exist or could not be dropped: ' || SQLERRM);
END;