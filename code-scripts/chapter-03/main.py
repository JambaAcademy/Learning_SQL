import anthropic

client = anthropic.Anthropic()


def translate_business_question_to_sql(business_question: str, table_schema: str) -> str:
    """Translate a plain English business question into a SQL SELECT statement using Claude."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""You are a SQL expert helping beginners learn SQL. 
                
Given this table schema:
{table_schema}

Translate this business question into a SQL SELECT statement:
"{business_question}"

Provide only the SQL query, no explanation.""",
            }
        ],
    )
    return message.content[0].text


def explain_select_anatomy(sql_query: str) -> str:
    """Break down a SELECT statement into its component parts and explain each clause."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""You are teaching SQL to beginners. Analyze this SELECT statement and explain each part:

SQL Query: {sql_query}

Break it down into:
1. Keywords used
2. Clauses present (SELECT, FROM, WHERE, etc.)
3. What each part does in plain English
4. Syntax rules demonstrated

Keep the explanation beginner-friendly.""",
            }
        ],
    )
    return message.content[0].text


def generate_column_aliases(table_name: str, columns: list[str]) -> str:
    """Generate readable column aliases using AS keyword for technical or abbreviated column names."""
    columns_str = ", ".join(columns)
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""You are helping make SQL query results more readable.

Table: {table_name}
Columns: {columns_str}

Generate a SELECT statement that:
1. Uses the AS keyword to create readable aliases for any technical or abbreviated column names
2. Keeps already clear column names as-is
3. Shows the difference between selecting specific columns vs using SELECT *

Provide the SQL query with aliases and a brief explanation of why each alias was chosen.""",
            }
        ],
    )
    return message.content[0].text
