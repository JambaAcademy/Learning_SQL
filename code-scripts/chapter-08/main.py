import anthropic

client = anthropic.Anthropic()

def explain_subquery_vs_join(scenario: str) -> str:
    """Explain when to use a subquery instead of a join for a given scenario."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"For this database scenario: {scenario}\n\nExplain whether to use a subquery or a JOIN, and why. Provide a concrete SQL example."
            }
        ]
    )
    return message.content[0].text


def generate_scalar_subquery_example(table_schema: str, filter_condition: str) -> str:
    """Generate a scalar subquery that returns a single value for filtering based on table schema and condition."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Given this table schema:\n{table_schema}\n\nCreate a scalar subquery that filters data based on: {filter_condition}\n\nThe subquery should return exactly one value."
            }
        ]
    )
    return message.content[0].text


def create_correlated_subquery(outer_table: str, inner_table: str, relationship: str) -> str:
    """Create a correlated subquery where the inner query references columns from the outer query."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Create a correlated subquery example with:\n- Outer table: {outer_table}\n- Inner table: {inner_table}\n- Relationship: {relationship}\n\nShow how the inner query references the outer query's columns."
            }
        ]
    )
    return message.content[0].text


def build_derived_table_query(base_query: str, aggregation_needed: str) -> str:
    """Build a query using a subquery in the FROM clause to create a temporary derived table for complex aggregations."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content":
