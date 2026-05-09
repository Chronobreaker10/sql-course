drop table if exists exam;

create table exam (
	exam_id int generated always as identity,
	exam_name varchar(64),
	exam_date date
);

alter table exam add constraint exam_exam_id_pk primary key(exam_id);

drop table if exists person;

create table person (
	person_id int generated always as identity primary key,
	first_name varchar(64) not null,
	last_name varchar(64) not null
);

insert into person(first_name, last_name) values ('Иван', 'Петров')

drop table if exists passport;

create table passport (
	passport_id int generated always as identity primary key,
	serial_number int not null,
	register_date date default now(),
	person_id int not null,
	constraint passport_person_id_fk foreign key(person_id) references person(person_id)
);

alter table passport add constraint chk_passport_serial_number check(serial_number >= 100000 and serial_number < 1000000);

insert into passport(serial_number, person_id) values (123456, 1);

drop table if exists student;

create table student (
	student_id int generated always as identity primary key,
	full_name varchar(100) not null,
	course int not null default 1
);


insert into student(full_name) values ('Сидоров Сергей');

alter table student alter course drop default;

alter table products add constraint chk_products_unit_price check(unit_price > 0);

select max(product_id) + 1 from products;

create sequence if not exists products_product_id_seq start with 79 owned by products.product_id;

alter table products alter column product_id set default nextval('product_id_seq');

INSERT INTO products (
product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued
) VALUES ('Test product', 20, 5, '20 - 2 kg bags', 20.8, 27, 5, 15, 1) returning product_id;

