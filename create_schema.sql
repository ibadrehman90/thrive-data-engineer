DROP TABLE IF EXISTS staging_messages;
DROP TABLE IF EXISTS dim_users;
DROP TABLE IF EXISTS dim_dates;
DROP TABLE IF EXISTS dim_conversations;
DROP TABLE IF EXISTS consolidated_messages;

-- Staging table for input data
CREATE TABLE staging_messages (
    user_id INTEGER,
    conversation_id INTEGER,
    email TEXT,
    message TEXT,
    part_type TEXT,
    created_at TEXT
);

-- User dimension
CREATE TABLE dim_users (
    user_id INTEGER PRIMARY KEY,
    email TEXT
);

-- Conversation dimension
CREATE TABLE dim_conversations (
    conversation_id INTEGER PRIMARY KEY
);

-- Date dimension
CREATE TABLE dim_dates (
    date_id INTEGER PRIMARY KEY,
    date TEXT,
    day INTEGER,
    month INTEGER,
    year INTEGER
);

-- Fact table
CREATE TABLE consolidated_messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    email TEXT,
    conversation_id INTEGER,
    message TEXT,
    message_type TEXT,
    created_at TEXT,
    date_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES dim_users(user_id),
    FOREIGN KEY (conversation_id) REFERENCES dim_conversations(conversation_id),
    FOREIGN KEY (date_id) REFERENCES dim_dates(date_id)
);