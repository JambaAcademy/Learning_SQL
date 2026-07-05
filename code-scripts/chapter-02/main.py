import anthropic


def explain_table_structure(table_name: str, columns: list[dict]) -> str:
    """Explain the structure and purpose of a database table using the filing cabinet analogy."""
    client = anthropic.Anthropic()
    
    columns_description = "\n".join([f"- {col['name']}: {col['type']}" for col in columns])
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Using the filing cabinet analogy, explain the structure of a database table called '{table_name}' with these columns:\n{columns_description}\n\nExplain what this table represents, how the columns define the anatomy of each record, and what a single row (record) means in real-world terms."
            }
        ]
    )
    
    return message.content[0].text


def analyze_row_as_record(table_name: str, row_data: dict) -> str:
    """Analyze a single database row to explain what it means as a complete unit of data."""
    client = anthropic.Anthropic()
    
    row_description = "\n".join([f"- {key}: {value}" for key, value in row_data.items()])
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Analyze this single row from the '{table_name}' table and explain what it represents as a complete unit of data:\n{row_description}\n\nExplain how this row is a complete record, what real-world entity it represents, and why each field contributes to making it a meaningful unit of information."
            }
        ]
    )
    
    return message.content[0].text


def explain_column_data_types(column_definitions: list[dict]) -> str:
    """Explain the anatomy of database columns including their data types and constraints."""
    client = anthropic.Anthropic()
    
    columns_info = "\n".join([
        f"- Column: {col['name']}, Type: {col['type']}, Constraints: {col.get('constraints', 'none')}"
        for col in column_definitions
    ])
    
    message = client.messages.create(
        model="claude
