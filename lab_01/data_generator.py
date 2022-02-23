import pandas as pd
import numpy as np
from faker import Faker
from collections import defaultdict
from sqlalchemy import create_engine

fake = Faker()

def generate_user(number_of_user):
    fake_data = defaultdict(list)
    for _ in range(number_of_user):
        gender = np.random.choice(["M", "F"], p=[0.5, 0.5])
        fake_data["id"] = str(_ + 1)
        fake_data["first_name"].append(fake.first_name_male() if gender == 'M' else fake.first_name_female())
        fake_data["password"].append(fake.password())
        fake_data["gender"].append(gender)
        fake_data["birth_date"].append(fake.date_of_birth())
        fake_data["country"].append(fake.country())
    return fake_data


def generate_chat_room(room_name = None, _capacity = None):
    fake_data = defaultdict(list)
    for _ in range(number_of_user):
        gender = np.random.choice(["M", "F"], p=[0.5, 0.5])
        fake_data["id"] = _ + 1
        fake_data["chat_room"].append(fake.first_name_male() if gender == 'M' else fake.first_name_female())
        fake_data["capacity"].append(fake.password())
        fake_data["password"].append(fake.password())
    return fake_data

df_fake_data = pd.DataFrame(generate_user(1000))

print(df_fake_data)