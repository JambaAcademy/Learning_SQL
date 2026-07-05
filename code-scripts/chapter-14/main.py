import anthropic

client = anthropic.Anthropic()

def detect_nulls_and_placeholders(table_name: str, columns: list[str]) -> str:
    """Generate SQL queries to detect nulls, blanks, and placeholder values across specified columns."""
    prompt = f"""Generate SQL queries to detect nulls, blanks, and placeholder values in the table '{table_name}' 
    for these columns: {', '.join(columns)}. Include checks for common placeholders like 'N/A', 'NULL', 'none', 
    empty strings, and whitespace-only values. Return practical SQL queries."""
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {"role": "user", "content": prompt}
        ]
    )
    return message.content[0].text


def find_and_deduplicate_records(table_name: str, key_columns: list[str]) -> str:
    """Generate SQL queries using ROW_NUMBER to find and remove duplicate records based on key columns."""
    prompt = f"""Generate SQL queries using ROW_NUMBER() window function to:
    1. Find duplicate records in '{table_name}' based on these key columns: {', '.join(key_columns)}
    2. Show how many duplicates exist
    3. Create a deduplication query that keeps only the first occurrence
    Return practical, ready-to-use SQL queries."""
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {"role": "user", "content": prompt}
        ]
    )
    return message.content[0].text


def identify_outliers_and_impossible_values(table_name: str, numeric_column: str) -> str:
    """Generate SQL statistical filter queries to identify outliers and impossible values in numeric data."""
    prompt = f"""Generate SQL queries to identify outliers and impossible values in the '{numeric_column}' 
    column of '{table_name}'. Include:
    1. Statistical approach using mean and standard deviation (values beyond 3 standard deviations)
    2. IQR (Interquartile Range) method for outlier detection
    3. Business rule checks for impossible values (negative ages, future birthdates, etc.)
    Return practical SQL queries with explanations."""
    
    message = client.messages.create(
        model="claude-opus-4-5",
