create table if not exists director(
    id serial primary key not null,
    full_name varchar,
    birth_year int,
    work_year int,
    phone_number varchar
);

create table if not exists krujok(
    id serial primary key not null,
    director_id int references director(id) not null,
    _name varchar,
    est_year int,
    info text
);

create table if not exists visitor(
    id serial primary key not null,
    full_name varchar,
    birth_year int,
    address varchar,
    e_mail varchar
);

insert into director values ('abab', 1999, 2021, '+789899'),
                            ('vbab', 2000, 2013, '+781899'),
                            ('cbab', 2002, 2002, '+789299'),
                            ('vbab', 2000, 2004, '+789399'),
                            ('nbab', 1992, 2003, '+789849'),
                            ('nbab', 1990, 2004, '+789895'),
                            ('sbab', 2002, 2006, '+789896'),
                            ('dbab', 2003, 2004, '+789889'),
                            ('fbab', 2005, 2006, '+789999'),
                            ('gbab', 2001, 2008, '+789099'),
                            ('hbab', 2009, 2007, '+781899'),
                            ('jbab', 2003, 2004, '+738599'),
                            ('kbab', 1992, 2006, '+7489899'),
                            ('lbab', 1989, 2008, '+789399');

insert into krujok values (1, 'asdasd', 2001, 'someting for test'),
                          (2, 'fsdasd', 2002, 'someting for test'),
                          (4, 'hsdasd', 2003, 'someting for test'),
                          (2, 'dsdasd', 2004, 'someting for test'),
                          (5, 'vsdasd', 2005, 'someting for test'),
                          (6, 'bsdasd', 2006, 'someting for test'),
                          (3, 'vsdasd', 2007, 'someting for test'),
                          (4, 'csdasd', 2008, 'someting for test'),
                          (5, 'xsdasd', 2009, 'someting for test'),
                          (3, 'zsdasd', 2010, 'someting for test'),
                          (6, 'msdasd', 2011, 'someting for test'),
                          (8, 'nsdasd', 2012, 'someting for test'),
                          (4, 'lsdasd', 2013, 'someting for test'),
                          (5, 'jsdasd', 2014, 'someting for test'),
                          (6, 'osdasd', 2015, 'someting for test'),
                          (3, 'psdasd', 2016, 'someting for test');

insert info visitor values ('Some one', 1990, 'Moscow', 'new@mail.ru'),
                           ('come one', 1991, 'noscow', 'nsew@mail.ru'),
                           ('vome one', 1992, 'boscow', 'nedw@mail.ru'),
                           ('bome one', 1993, 'voscow', 'newv@mail.ru'),
                           ('nome one', 1994, 'coscow', 'newb@mail.ru'),
                           ('mome one', 1995, 'xoscow', 'neewf@mail.ru'),
                           ('fome one', 1996, 'zoscow', 'nrew@mail.ru'),
                           ('dome one', 1997, 'doscow', 'netw@mail.ru'),
                           ('home one', 1998, 'roscow', 'neew@mail.ru'),
                           ('jome one', 1980, 'fMoscow', 'netw@mail.ru'),
                           ('lome one', 1991, 'toscow', 'netwr@mail.ru'),
                           ('eome one', 1992, 'hoscow', 'neew@mail.ru'),
                           ('rome one', 1993, 'joscow', 'neew@mail.ru'),
                           ('tome one', 1994, 'roscow', 'newww@mail.ru'),
                           ('yome one', 1995, 'eoscow', 'n22ew@mail.ru'),
                           ('pome one', 1996, 'woscow', 'ne34w@mail.ru');

create table if not exists chain (
    visitor_id int references visitor(id) not null,
    krujok_id int references krujok(id) not null
);

insert into chain values (1, 2),
                         (6, 2),
                         (5, 3),
                         (3, 4),
                         (2, 5),
                         (3, 2),
                         (2, 2),
                         (4, 2),
                         (5, 9),
                         (8, 3),
                         (3, 2),
                         (3, 4),
                         (4, 3);

select *,
        case when birth_year = 2000 then 'Age 20+-'
        else 'age 20+'
        end
from director;

select _name, birth_year, avg(birth_year) over (partition by phone_num) from director;

select birth_year, count(*), as year_count from visitor
group by birth_year
having count(*) >= 1;



CREATE TABLE driver( 
    id INTEGER PRIMARY KEY,
    driver_number int,
    phone varchar(32),
    full_name varchar(32),
    car varchar(32)
);

CREATE TABLE fine (
   	id INTEGER PRIMARY KEY,
    fine_type VARCHAR(32),
    fine_amount int,
    msg text
);

CREATE TABLE car (
    id INTEGER PRIMARY KEY,
    driver_id int,
    brand VARCHAR(32),
    model VARCHAR(32),
    year_brand int,
    constraint car_driver foreign key(driver_id) references driver(id)
);

CREATE TABLE driver_fines(
    driver_id INTEGER REFERENCES driver(id),
    fine_id INTEGER REFERENCES fine(id)
);

insert into driver values (1, 32323, '+7343443434', 'A', 'corolla'),
						  (2, 32323, '+7353463434', 'B', 'nissan'),
						  (3, 32523, '+7343433434','V', '4runner'),
						  (4, 32623, '+7343633434', 'D','4x4'),
						  (5, 32723, '+7346433434', 'R','land curiser'),
						  (6, 32823, '+7344433434', 'E','new land'),
						  (7, 32343, '+7343633434', 'Q','benz'),
						  (8, 32353, '+7343453434', 'Q','amg'),
						  (9, 32373, '+7343443434', 'Z','d4d'),
						  (10, 32883, '+7343333434', 'O','camery');

insert into fine values (1, 'red cross', 20000, 'dont repeat'),
						 (2, 'stopped in road', 30000, 'dont repeat'),
						  (3, 'drinked', 40000, 'dont repeat'),
						   (4, 'car lamp', 50000, 'dont repeat'),
						    (5, 'no licence', 60000, 'dont repeat'),
						     (6, 'emxp ', 70000, 'dont repeat'),
						      (7, 'something', 340000, 'dont repeat'),
						       (8, 'exmp', 205400, 'dont repeat'),
						        (9, 'red cross', 2054000, 'dont repeat'),
						         (10, 'edeev', 2003400, 'dont repeat');

insert into car values (1, 1, 'Toyota', 'corolla', 2020),
 					   (2, 2, 'Nissan', 'nissan', 2021),
 					   (3, 3, 'Toyota', '4runner', 2010),
 					   (4, 4, 'Toyota', '4x4', 2000),
 					   (5, 5, 'Toyota', 'land curiser', 2021),
 					   (6, 6, 'lada', 'new land', 1998),
					   (7, 7, 'M-benz', 'benz', 2009),
					   (8, 8, 'M-benz', 'amg', 2007),
					   (9, 9, 'Toyota', 'd4d', 1997),
					   (10, 10, 'Toyota', 'camery', 2021);

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
						

--
--1						
select * from driver
	join car on 
		model = driver.car
where 
	brand = 'Toyota';

--2
select fine_type, avg(fine_amount) over (partition by fine_type),
				  max(fine_amount) over (partition by fine_type),
  				  min(fine_amount) over (partition by fine_type)
					from fine;

--3
select  *
from (
	select id, phone from driver dr
	where  dr.id in(
		select driver_id from driver_fines
	)
) as example;