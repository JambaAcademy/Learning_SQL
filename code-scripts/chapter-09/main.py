import anthropic


def explain_cte_vs_subquery(complex_query: str) -> str:
    """Analyzes a complex SQL query and explains how CTEs would improve its readability."""
    client = anthropic.Anthropic()
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""Analyze this SQL query and explain how Common Table Expressions (CTEs) would improve its readability compared to the current nested subquery approach:

{complex_query}

Please explain:
1. What makes this query hard to read
2. How a CTE version would look
3. The specific readability benefits""",
            }
        ],
    )
    return message.content[0].text


def convert_subquery_to_cte(sql_with_subqueries: str) -> str:
    """Converts a SQL query with nested subqueries into an equivalent query using CTEs."""
    client = anthropic.Anthropic()
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=2048,
        messages=[
            {
                "role": "user",
                "content": f"""Convert this SQL query that uses nested subqueries into an equivalent query using Common Table Expressions (CTEs) with the WITH clause:

{sql_with_subqueries}

Provide:
1. The refactored SQL using CTEs
2. Brief explanation of each CTE's purpose
3. How the CTEs chain together""",
            }
        ],
    )
    return message.content[0].text


def generate_recursive_cte_for_hierarchy(
    table_name: str, id_column: str, parent_id_column: str, name_column: str
) -> str:
    """Generates a recursive CTE to traverse hierarchical data like org charts or category trees."""
    client = anthropic.Anthropic()
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""Generate a recursive CTE to traverse hierarchical data with these specifications:
- Table name: {table_name}
- ID column: {id_column}
- Parent ID column: {parent_id_column}
- Name column: {name_column}

Create a recursive CTE
