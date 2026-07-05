import anthropic

client = anthropic.Anthropic()


def analyze_sales_by_category(sales_data: list[dict]) -> dict:
    """Analyze sales data by product category using aggregate functions and GROUP BY concepts."""
    
    # Format the sales data for analysis
    data_str = "\n".join([str(row) for row in sales_data])
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""You are a SQL and data analysis expert. Analyze this sales data and provide insights using aggregate functions (COUNT, SUM, AVG, MIN, MAX) grouped by category.

Sales Data:
{data_str}

Please provide:
1. Total sales (SUM) by category
2. Average sale amount (AVG) by category  
3. Count of transactions (COUNT) by category
4. Min and Max sale amounts by category
5. Identify which categories have total sales above 1000 (HAVING clause equivalent)

Format your response as a structured analysis."""
            }
        ]
    )
    
    return {
        "analysis": message.content[0].text,
        "data_points": len(sales_data)
    }


def explain_where_vs_having(query_context: str) -> str:
    """Explain the difference between WHERE and HAVING clauses with practical examples for the given context."""
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""You are a SQL teaching expert. Explain the difference between WHERE and HAVING clauses in the context of: {query_context}

Provide:
1. A clear explanation of WHERE (filters BEFORE aggregation)
2. A clear explanation of HAVING (filters AFTER aggregation)
3. A practical SQL example showing both
4. A common mistake beginners make
5. When to use each clause

Keep the explanation beginner-friendly but technically accurate."""
            }
        ]
    )
    
    return message.content[0].text


def detect_null_counting_issues(dataset_description: str) -> dict:
    """Identify potential null counting traps and explain COUNT(*) vs COUNT(column) differences."""
    
    message = client.messages.create(
        model="claude-opus-4-5",
