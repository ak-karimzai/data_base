import psycopg2 as pg_lib

def connect_db(db_name, db_pass, db_host = "localhost", db_user = "postgres"):
    conn = None
    try:
        conn = pg_lib.connect(
            host = db_host,
            database = db_name,
            user = db_user,
            password = db_pass
        )
    except:
        print("Connection Err!")
    
    return conn

def get_rm_cpy(cur, rm_id):
    cur.execute(f"Select id, capacity from chat_rooms \
                 where id = {rm_id}")
    print(cur.fetchone())

def get_ag_t_ar(cur, fst_rm, snd_rm):
    query = f"SELECT username, age \
        from users \
            JOIN participants as p on users.id = p.user_id \
            JOIN chat_rooms as cr on cr.id = p.room_id \
        WHERE age > ALL( \
            SELECT avg(age) \
            FROM users \
                JOIN participants as p on users.id = p.user_id \
                JOIN chat_rooms as cr on cr.id = p.room_id \
            where cr.id = {snd_rm}) \
            AND cr.id = {fst_rm};"
    
    cur.execute(query)
    
    row = cur.fetchone()
    while row:
        print(row)
        row = cur.fetchone()

def get_usrs_in_rg(cur, begin, end):
    query = f"with test(id, username, gender) as ( \
                select id, username, gender \
                from users \
                where id between {begin} and {end} \
            ) \
            select * from test"
    
    cur.execute(query)
    
    row = cur.fetchone()
    while row:
        print(row)
        row = cur.fetchone()

def print_table_names(cur):
    query = "select tablename from pg_catalog.pg_tables \
             where schemaname != 'pg_catalog' and \
                 schemaname != 'information_schema' "
    cur.execute(query)

    row = cur.fetchone()
    id = 1
    while row:
        print((id, *row), end = ": ")
        row = cur.fetchone()
        id += 1
    print('\n')

def get_tbl_name(cur, tb_id):
    query = f"select * from ( \
             select row_number() over (order by pg_catalog.pg_tables.tablename asc) as row, tablename from pg_catalog.pg_tables \
             where schemaname != 'pg_catalog' and \
                 schemaname != 'information_schema') as foo \
             where row = {tb_id}"
    cur.execute(query)

    row = cur.fetchone()
    return row[1]

def get_tbl_rcd(cur, tb_id):
    tbl_name = get_tbl_name(cur, tb_id)
    query = f"select reltuples from pg_class where relname = '{tbl_name}'"
    
    cur.execute(query)
    row = cur.fetchone()

    print(f"Number of records in {get_tbl_name(cur, tb_id)} table = {row[0]}")

def get_urs_age_det(cur):
    query = "select * from get_age_det()"

    cur.execute(query)

    row = cur.fetchone()
    print(f"AVG = {row[0]}, MAX  = {row[1]}, MIN = {row[2]}")

def get_rm_det(cur, rm_id):
    query = f"select * from get_room_det_by_id({rm_id})"

    cur.execute(query)

    row = cur.fetchone()
    
    print(row)

#create or replace procedure insert_new_usr(usr_id int, usr_name text, usr_pass text, usr_email text, usr_gen varchar(1), age int)

def add_new_usr(cur):
    usr_id = input("New usr ID: ")
    usr_name = input("New usr name: ")
    usr_pass = input("New usr password: ")
    usr_email = input("New usr email: ")
    usr_gen = input("New usr gender f/m: ")
    usr_age = int(input("New usr age: "))

    query = f"call insert_new_usr({usr_id}, '{usr_name}', '{usr_pass}', '{usr_email}', '{usr_gen[0]}', {usr_age})"

    cur.execute(query)

    print('user successfully Added')
    get_usrs_in_rg(cur, int(usr_id), int(usr_id) + 1)

def get_info_crt_db(cur):
    query_00 = "select * from current_catalog"
    query = "select tablename from pg_catalog.pg_tables pt \
            where schemaname <> 'pg_catalog' and schemaname <> 'information_schema'"
    
    cur.execute(query_00)

    row = cur.fetchone()
    print(f"Database name = {row[0]}")

    cur.execute(query)
    row = cur.fetchone()
    id = 1
    print('tables: ', end='')
    while row:
        print((id, row[0]), end = ' - ')
        row = cur.fetchone()
        id += 1
    print('\n')

def crt_new_tbl(cur):
    query = "create table if not exists non_active_usrs( \
                usr_id int references users(id) not null, \
                usr_name varchar, \
                number_of_msgs int default 0)"
    cur.execute(query)

def add_data_to_tbl(cur):
    query_0 = 'drop table if exists non_active_usrs'
    cur.execute(query_0)

    query = "with non_ac_usr_cte(id, username, msg_cnt) as ( \
                with avg_msg_cnt(count) as ( \
                            select count(*) from messages m2 group by user_id \
                ) \
                select * from ( \
                        select u.id, username, count(m.message) as msg_cnt from users u \
                            join messages m on user_id = u.id \
                        group by u.id \
                        ) as foo \
                where msg_cnt < (select avg(count) from avg_msg_cnt ) \
                ) \
                select * into non_active_usrs from non_ac_usr_cte"
    print_query = "select * from non_active_usrs"
    cur.execute(query)

    print('values are added successfully')
    
    cur.execute(print_query)
    row = cur.fetchone()
    while row:
        print(row)
        row = cur.fetchone()

def drop_tbl(cur):
    query = "drop table if exists non_active_usrs"
    cur.execute(query)

def delete_a_row(cur, tb_id):
    print_query = "select * from non_active_usrs \
                   where usr_id = {tb_id}"

    query = f"delete from non_active_usrs \
              where usr_id = {tb_id} \
              RETURNING ({print_query}"
    
    cur.execute(query)

    row = cur.fetchone()
    while row:
        print(row)
        row = cur.fetchone()

def exectue(cur, choice):
    if choice == 1:
        rm_id = int(input("Enter room id:"))
        get_rm_cpy(cur, rm_id)
    elif choice == 2:
        fst_rm, snd_rm = map(int, input("Enter 1st and 2nd room id: ").split())
        get_ag_t_ar(cur, fst_rm, snd_rm)
    elif choice == 3:
        begin, end = map(int, input("Enter interval: ").split())
        get_usrs_in_rg(cur, begin, end)
    elif choice == 4:
        print_table_names(cur)
        table_no = int(input("Enter table number: "))
        get_tbl_rcd(cur, table_no)
    elif choice == 5:
        print('users age averge max and min')
        get_urs_age_det(cur)
    elif choice == 6:
        rm_id = int(input('Enter room id:'))
        get_rm_det(cur, rm_id)
    elif choice == 7:
        add_new_usr(cur)
    elif choice == 8:
        get_info_crt_db(cur)
    elif choice == 9:
        crt_new_tbl(cur)
    elif choice == 10:
        add_data_to_tbl(cur)
    elif choice == 11:
        usr_id = int(input("Enter user id: "))
        delete_a_row(cur, usr_id)
    else:
        drop_tbl(cur)
    print('\n\n')

def get_choice():
    print('1: print room capacity')
    print('2: compare two room capacity and print greathers')
    print('3: print users in range')
    print('4: print number of records in table')
    print('5: print age averge, max and min from users')
    print('6: print room detail')
    print('7: Add new user')
    print('8: print info of current database')
    print('9: create non active users table')
    print('10: insert data into created table')
    print('11: delete user from new table')
    print('any other key to exit\n\n')

    return int(input("Choice: "))

def main():
    conn = connect_db('chat_room', 'khalidak11')
    
    if not conn:
        exit(-1)
    print('Database Connected successfully\n')
    cur = conn.cursor()
    
    choice = get_choice()
    while choice >= 1 and choice <= 11:
        try:
            exectue(cur, choice)
        except:
            conn.rollback()
        else:
            conn.commit()

        choice = get_choice()

    cur.close()
    conn.close()

if __name__ == "__main__":
    main()