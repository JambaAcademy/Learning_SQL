import anthropic

client = anthropic.Anthropic()

def sort_results_ascending(table_name: str, column_name: str) -> str:
    """Generate SQL query to sort results in ascending order by specified column."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Generate a SQL query to select all records from {table_name} and sort them by {column_name} in ascending order. Return only the SQL query, no explanation."
            }
        ]
    )
    return message.content[0].text

def sort_multiple_columns(table_name: str, primary_sort: str, secondary_sort: str, primary_order: str = "ASC", secondary_order: str = "DESC") -> str:
    """Generate SQL query with multi-column sorting to demonstrate sort priority and ordering logic."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Generate a SQL query to select all records from {table_name}, sorted first by {primary_sort} {primary_order}, then by {secondary_sort} {secondary_order}. Return only the SQL query, no explanation."
            }
        ]
    )
    return message.content[0].text

def paginate_results(table_name: str, page_number: int, page_size: int = 10) -> str:
    """Generate SQL query with LIMIT and OFFSET for paginating through large result sets."""
    offset = (page_number - 1) * page_size
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Generate a SQL query to select records from {table_name} with pagination. Use LIMIT {page_size} and OFFSET {offset} to get page {page_number}. Return only the SQL query, no explanation."
            }
        ]
    )
    return message.content[0].text

def filter_and_sort_results(table_name: str, filter_column: str, filter_value: str, sort_column: str, sort_order: str = "ASC") -> str:
    """Generate SQL query combining WHERE filter conditions with ORDER BY
