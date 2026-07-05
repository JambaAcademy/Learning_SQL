import anthropic

def analyze_query_performance(sql_query: str) -> str:
    """Analyze a SQL query and explain why it might cause performance issues."""
    client = anthropic.Anthropic()
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""You are a database performance expert. Analyze this SQL query and explain:
1. Why query performance matters beyond just getting the right answer
2. Potential performance bottlenecks in this query
3. How the database engine will logically process this query

SQL Query:
{sql_query}

Provide a concise, practical analysis."""
            }
        ]
    )
    
    return message.content[0].text


def explain_execution_plan(execution_plan: str) -> str:
    """Interpret a database execution plan and translate it into plain English recommendations."""
    client = anthropic.Anthropic()
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""You are a database expert helping developers understand execution plans without being a DBA.
                
Analyze this execution plan and explain:
1. What each step means in plain English
2. Which operations are expensive and why
3. What the plan tells us about how the database is processing the query

Execution Plan:
{execution_plan}

Keep the explanation accessible to developers who aren't database administrators."""
            }
        ]
    )
    
    return message.content[0].text


def recommend_indexes(table_schema: str, common_queries: list[str]) -> str:
    """Recommend which columns to index based on table schema and query patterns."""
    client = anthropic.Anthropic()
    
    queries_text = "\n".join([f"Query {i+1}: {q}" for i, q in enumerate(common_queries)])
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""You are a database indexing expert. Based on the table schema and common queries, recommend an indexing strategy.

Table Schema:
{table_schema}

Common Queries:
{queries_text}

Provide recommendations for
