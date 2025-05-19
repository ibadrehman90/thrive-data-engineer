import sqlite3
import pandas as pd

DB_FILE = 'consolidated_messages_output.db'
INPUT_CSV = 'consolidated_messages_example.csv'
CREATE_SCHEMA_SQL = 'create_schema.sql'
ETL_TRANSFORM_SQL = 'etl_transform.sql'


def load_csv_to_sqlite(csv_file, table_name, conn):
    df = pd.read_csv(csv_file)
    if pd.api.types.is_numeric_dtype(df['created_at']):
        df['created_at'] = pd.to_datetime(df['created_at'], unit='s')
    else:
        df['created_at'] = pd.to_datetime(df['created_at'])
    df['created_at'] = df['created_at'].dt.strftime('%Y-%m-%d %H:%M:%S')
    df.to_sql(table_name, conn, if_exists='append', index=False)


def print_table_count(conn, table_name):
    cur = conn.cursor()
    cur.execute(f"SELECT COUNT(*) FROM {table_name}")
    count = cur.fetchone()[0]
    print(f"Table '{table_name}' has {count} records.")


def run_sql_script(conn, script_file):
    with open(script_file, 'r') as f:
        script = f.read()
    conn.executescript(script)


def main():
    conn = sqlite3.connect(DB_FILE)
    run_sql_script(conn, CREATE_SCHEMA_SQL)
    load_csv_to_sqlite(INPUT_CSV, 'staging_messages', conn)
    print_table_count(conn, 'staging_messages')

    run_sql_script(conn, ETL_TRANSFORM_SQL)
    print_table_count(conn, 'consolidated_messages')

    # Saving output data as csv for easy analysis
    df = pd.read_sql_query(
        "SELECT * FROM consolidated_messages ORDER BY conversation_id, created_at", conn)
    df.to_csv('output_data.csv', index=False)
    conn.close()


if __name__ == '__main__':
    main()
