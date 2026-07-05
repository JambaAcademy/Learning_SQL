import anthropic


def analyze_production_sql_gaps(tutorial_query: str, production_context: str) -> str:
    """Identify gaps between tutorial SQL patterns and production-ready SQL requirements."""
    client = anthropic.Anthropic()
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""Analyze the following SQL query written in a tutorial style and identify what changes would be needed for production use.

Tutorial Query:
{tutorial_query}

Production Context:
{production_context}

Please identify:
1. Performance optimizations needed
2. Error handling improvements
3. Security considerations
4. Documentation requirements
5. Monitoring and logging needs"""
            }
        ]
    )
    
    return message.content[0].text


def generate_portfolio_project_ideas(dataset_description: str, skill_level: str) -> str:
    """Generate SQL portfolio project ideas using real datasets with documentation structure."""
    client = anthropic.Anthropic()
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""Create a SQL portfolio project plan for the following dataset and skill level.

Dataset Description:
{dataset_description}

Skill Level: {skill_level}

Please provide:
1. Project title and objective
2. Key SQL concepts to demonstrate
3. Analysis questions to answer
4. Visualization suggestions
5. Documentation structure for GitHub"""
            }
        ]
    )
    
    return message.content[0].text


def prepare_sql_interview_response(question_type: str, question: str) -> str:
    """Structure a response approach for one of the five SQL interview question types."""
    client = anthropic.Anthropic()
    
    valid_types = ["window_functions", "joins", "aggregations", "subqueries", "optimization"]
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""Help me prepare for this SQL interview question.

Question Type: {question_type}
(Valid types: {', '.join(valid_types)})

Interview Question:
{question}

Please provide:
1. How to
