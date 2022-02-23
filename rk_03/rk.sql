create table if not exists drivers (
    driver_id int primary key not null,
	driver_licence text not null,
	d_full_name text not null,
	d_phone text not null
); 

create table if not exists fines (
    fine_id int primary key not null,
    d_id int not null references drivers (driver_id),
	fine_type text,
	amount bigint,
	fine_data date
);

create table if not exists cars (
	car_id int primary key not null,
	model text,
	color text,
	year int,
	regesteration_date date
)

create table driver_fines(
	driver_id int references drivers(driver_id),
	fine_id int references fines(fine_id)
);

insert into fines values (1, 5,'red cross', 20000,      '19-08-2020'),
                        (2, 6,'stopped in road', 30000, '19-08-2019'),
                        (3, 7,'drinked', 40000,         '20-08-2020'),
                        (4, 8,'car lamp', 50000,        '19-03-2020'),
                        (5, 9,'no licence', 60000,      '19-04-2020'),
                        (6, 10,'emxp ', 70000,          '19-02-2020'),
                        (7, 2,'something', 340000,      '19-02-2020'),
                        (8, 3,'exmp', 205400,           '12-08-2020'),
                        (9, 2,'red cross', 2054000,     '19-08-2018'),
                        (10, 2,'edeev', 2003400,        '19-08-2017');


insert into car values (1, 'Toyota','white', 2020, '19-08-2022'),
                       (2, 'Nissan','white', 2021, '19-08-2019'),
                       (3, 'Toyota','white', 2010, '19-08-2018'),
                       (4, 'Toyota','white', 2000, '19-08-2017'),
                       (5, 'Toyota','white', 2021, '19-08-2011'),
                       (6, 'lada', 'black',  1998, '19-08-2012'),
                       (7, 'M-benz','red',  2009, '19-08-2001'),
                       (8, 'M-benz','red', 2007, '19-08-2020'),
                       (9, 'Toyota','red', 1997,'19-08-2002'),
                       (10,'Toyota','red', 2021, '19-08-2004');

insert into driver_fines values 
(1, 2),
(1, 1),
(1, 3),
(4, 2),
(9, 5),
(3, 8),
(4, 2),
(6, 4),
(6, 3),
(7, 3);

select drivers.driver_licence, fines.fine_type, fines.fine_data
from drivers join fines on drives.driver_id = fines.d_id;

set datestyle to 'iso, mdy';

insert into visits values
		(1, '12-14-2018', 'Saturday', '9:00', 1),                                                           
		(1, '12-14-2018', 'Saturday', '9:20', 2),
        (1, '12-14-2018', 'Saturday', '9:25', 1),
        (2, '12-14-2018', 'Saturday', '9:05', 1);
       
insert into employees values
	(1,'Иванов Иван Иванович','09-25-1990','ИТ'),
	(2,'Петров Петр ПЕтрович','11-12-1987','Бухгалтерия');

create or replace function getWorker(date) returns int as
$$
    begin
	return(
	select count(*)
	from(select distinct id from employees 
	where extract(year from age(current_date,birth_date)) between 18 and 40
	and id in (select emp_id from (select emp_id, date_visit, visit_type, count(*)
	from visits
		where date_visit = $1
		group by emp_id, date_visit, visit_type
		having visit_type = 2 and count(*) > 3) as tmp0
		))as tmp1
	);
	end;
$$ language plpgsql;

select getWorker('12-14-2018');

select distinct department
        from employees where id in
	    (select distinct emp_id from visits
        where time_visit > '9:00' and date_visit = '12-14-2018');
        
       
       