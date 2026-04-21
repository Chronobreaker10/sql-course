create table if not exists teacher (
	teacher_id serial,
	first_name varchar,
	last_name varchar,
	birthday date,
	phone varchar,
	title varchar
);


alter table teacher add column middle_name varchar;

alter table teacher drop column middle_name;

alter table teacher rename birthday to birth_date;

alter table teacher alter column phone set data type varchar(32);

create table if not exists exam (
	exam_id serial,
	exam_name varchar(256),
	exam_date date
);

insert into exam (exam_name, exam_date) values
	('Математика', '2026-05-21'),
	('Программирование', '2026-06-08'),
	('Физика', '2026-06-12');

select * from exam e order by e.exam_date desc;

truncate table exam restart identity;