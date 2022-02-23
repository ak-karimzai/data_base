from psycopg2 import connect
import psycopg2.extras

con = psycopg2.connect(dbname = 'rk_03', user = 'postgres',
                        password = 'khalidak11', host = 'localhost')

#####################################################################################

def task_one_sql():
    cur = con.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute('''
    select department, quantity 
    from (select department, count(*) as quantity 
    from employees group by department) as tmp where quantity >= 10
    ''')
    records = cur.fetchall()
    print(records)      

#####################################################################################

def task_two_sql():
    cur = con.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute('''
    select id 
    from employees
    where id not in( 
	    select emp_id from (
	    select emp_id, date_visit, visit_type, count(*)
	    from visits
	        group by emp_id, date_visit, visit_type
	        having visit_type = 1 and count(*) > 1 
        ) as tmp)
    ''')
    records = cur.fetchall()
    print(records)


#####################################################################################

def task_three_sql():
    year = int(input('Input year: '))
    month = int(input('Input month: '))
    day = int(input('Input day: '))
    cur = con.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute(f"\
    select distinct department \
        from employees where id in \
	    (select distinct emp_id from visits \
        where time_visit > '9:00' and date_visit = '{day}-{month}-{year}')")
    records = cur.fetchall()
    print(records)


if __name__ == '__main__':
    task_one_sql()
    task_two_sql()
    task_three_sql()

con.close()