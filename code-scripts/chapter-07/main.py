import anthropic

client = anthropic.Anthropic()


def explain_why_joins_exist(scenario: str) -> str:
    """Explain why database joins exist and the problems with storing everything in one table."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Explain why database joins exist and the problems with storing everything in one table for this scenario: {scenario}. Include a concrete example with sample data showing data redundancy issues.",
            }
        ],
    )
    return message.content[0].text


def demonstrate_inner_join(
    table1_name: str, table2_name: str, join_key: str, sample_data: dict
) -> str:
    """Demonstrate INNER JOIN by showing only rows that match on both sides of the join."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Show me an INNER JOIN example between '{table1_name}' and '{table2_name}' tables using '{join_key}' as the join key. Use this sample data: {sample_data}. Show the SQL query and the resulting dataset, explaining why some rows are excluded.",
            }
        ],
    )
    return message.content[0].text


def compare_left_right_full_outer_joins(
    left_table: str, right_table: str, join_condition: str
) -> str:
    """Compare LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN behaviors with the same tables and condition."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1536,
        messages=[
            {
                "role": "user",
                "content": f"Compare LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN using '{left_table}' as the left table and '{right_table}' as the right table with join condition: {join_condition}. Show SQL for each type, sample results with NULL values highlighted, and when to use each type.",
            }
        ],
    )
    return message.content[0].text


def build_multi_table_join_query(
    tables: list[str], relationships: list[dict], filter_conditions: str = None
) -> str:
    """Build and
