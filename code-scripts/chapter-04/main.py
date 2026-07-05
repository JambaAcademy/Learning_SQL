import anthropic

client = anthropic.Anthropic()


def filter_rows_with_comparison_operators(table_name: str, column: str, operator: str, value: str) -> str:
    """Generate SQL query using comparison operators (=, !=, >, <, >=, <=) to filter rows."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Generate a SQL WHERE clause for table '{table_name}' filtering '{column}' using '{operator}' operator with value '{value}'. Explain the comparison operator used.",
            }
        ],
    )
    return message.content[0].text


def filter_text_with_exact_match(table_name: str, text_column: str, search_value: str) -> str:
    """Filter text data with exact matches, highlighting case sensitivity considerations."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Show SQL examples for exact text matching in table '{table_name}' on column '{text_column}' for value '{search_value}'. Include case sensitivity examples and LOWER/UPPER functions.",
            }
        ],
    )
    return message.content[0].text


def filter_numbers_and_dates_with_ranges(
    table_name: str, column: str, start_value: str, end_value: str, data_type: str
) -> str:
    """Create SQL queries for filtering numeric and date ranges using BETWEEN and boundary conditions."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Generate SQL WHERE clauses for filtering {data_type} column '{column}' in table '{table_name}' between '{start_value}' and '{end_value}'. Show BETWEEN operator and boundary edge cases.",
            }
        ],
    )
    return message.content[0].text


def combine_conditions_with_logical_operators(
    table_name: str, conditions: list[dict]
) -> str:
    """Combine multiple WHERE conditions using AND, OR, and NOT logical operators."""
    conditions_str = str(conditions)
