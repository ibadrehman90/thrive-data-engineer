## Project Files

### SQL Files

- **create_schema.sql**  
  SQL script that creates the database schema including:
  - Staging table for raw CSV data
  - Dimension tables (users, conversations, dates)
  - Fact table (consolidated_messages)

- **etl_transform.sql**  
  SQL script containing the transformation logic to:
  - Extract unique entities and populate dimension tables
  - Convert timestamps to appropriate date dimensions
  - Transform raw message data into the fact table
  - Handle message type classification

### Python Files

- **load_data.py**  
  Main ETL pipeline file that:
  - Loads CSV data into the staging table
  - Executes the schema creation script
  - Runs the transformation SQL
  - Outputs the consolidated data to CSV for verification

## How to Run

1. Clone the repository
```bash
git clone https://github.com/ibadrehman90/thrive-data-engineer.git
cd thrive-data-task
```

2. Install dependencies
```bash
pip install -r requirements.txt
```

3. Run the ETL pipeline
```bash
python load_data.py
```

This will:
- Create a SQLite database (`messages.db`)
- Process the input CSV file into the dimensional model
- Generate an output sample file (`output_sample.csv`)

## Data Model

The solution implements a star schema with:
- A fact table (`consolidated_messages`) containing message details
- Dimension tables for users, conversations, and dates
- Foreign key relationships for data integrity and query optimization