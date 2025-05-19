-- Populate dim_users
INSERT OR IGNORE INTO dim_users (user_id, email)
SELECT DISTINCT user_id, email FROM staging_messages;

-- Populate dim_conversations
INSERT OR IGNORE INTO dim_conversations (conversation_id)
SELECT DISTINCT conversation_id FROM staging_messages;

-- Populate dim_dates
INSERT OR IGNORE INTO dim_dates (date_id, date, day, month, year)
SELECT DISTINCT
    CAST(strftime('%Y%m%d', created_at) AS INTEGER) AS date_id,
    date(created_at) AS date,
    CAST(strftime('%d', created_at) AS INTEGER) AS day,
    CAST(strftime('%m', created_at) AS INTEGER) AS month,
    CAST(strftime('%Y', created_at) AS INTEGER) AS year
FROM staging_messages;

-- Populate fact table
INSERT INTO consolidated_messages (
    user_id, email, conversation_id, message, message_type, created_at, date_id
)
SELECT
    user_id,
    email,
    conversation_id,
    message,
    part_type AS message_type,
    created_at,
    CAST(strftime('%Y%m%d', created_at) AS INTEGER) AS date_id
FROM staging_messages;