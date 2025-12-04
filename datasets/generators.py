import random
from datetime import datetime, timedelta
from faker import Faker
import polars as pl

# Initialize Faker
fake = Faker()
Faker.seed(42)
random.seed(42)

# Generate a list of merchant categories and types
merchant_categories = [
    "Grocery", "Fuel", "Online Shopping", "Dining", "Entertainment",
    "Travel", "Utilities", "Healthcare", "Subscriptions", "Clothing"
]

card_types = ["Visa", "MasterCard", "Amex", "Discover"]

# Function to generate a single transaction record
def generate_transaction():
    transaction_date = fake.date_time_between(start_date="-1y", end_date="now")
    amount = round(random.uniform(5.00, 500.00), 2)
    card_number = fake.credit_card_number()
    card_type = random.choice(card_types)
    name = fake.name()
    merchant = fake.company()
    category = random.choice(merchant_categories)
    city = fake.city()
    state = fake.state_abbr()
    return {
        "transaction_id": fake.uuid4(),
        "timestamp": transaction_date,
        "cardholder": name,
        "card_type": card_type,
        "card_number": card_number[-4:],  # last 4 digits
        "merchant": merchant,
        "category": category,
        "city": city,
        "state": state,
        "amount": amount,
        "currency": "USD",
    }

# Generate dataset
n = 30_000
data = [generate_transaction() for _ in range(n)]

# Create Polars DataFrame
df = pl.DataFrame(data)

# Save to CSV
df.write_csv("fake_credit_card_transactions.csv")

print(df.head())
