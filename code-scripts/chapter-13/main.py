import anthropic


def translate_stakeholder_request(vague_request: str, business_context: str) -> str:
    """Translates a vague stakeholder request into a precise analytical question with SQL query plan."""
    client = anthropic.Anthropic()
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""You are a data analyst expert. Translate this vague stakeholder request into a precise analytical question and create a SQL query plan.

Vague Request: {vague_request}
Business Context: {business_context}

Please provide:
1. A precise analytical question
2. Key metrics to measure
3. A high-level query plan (tables, joins, filters needed)
4. Potential edge cases to consider"""
            }
        ]
    )
    
    return message.content[0].text


def plan_query_logic(analytical_question: str, available_tables: list[str]) -> str:
    """Sketches the logical structure of a SQL query before writing any code."""
    client = anthropic.Anthropic()
    
    tables_str = "\n".join(f"- {table}" for table in available_tables)
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""You are a SQL expert. Create a detailed query plan for this analytical question.

Analytical Question: {analytical_question}

Available Tables:
{tables_str}

Please sketch the query logic including:
1. Which tables to use and why
2. Required joins and join keys
3. Filtering conditions
4. Aggregations needed
5. Expected output columns
6. Step-by-step query building approach"""
            }
        ]
    )
    
    return message.content[0].text


def identify_tables_and_joins(business_entities: list[str], database_schema: str) -> str:
    """Identifies the right tables, primary keys, and join relationships for a business query."""
    client = anthropic.Anthropic()
    
    entities_str = "\n".join(f"- {entity}" for entity in business_entities)
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
