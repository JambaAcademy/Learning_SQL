import anthropic

def analyze_forgetting_curve(learning_data: dict) -> str:
    """Analyze SQL learning patterns using the Forgetting Curve principles to identify retention gaps."""
    client = anthropic.Anthropic()
    
    prompt = f"""Based on the Forgetting Curve research by Ebbinghaus, analyze this SQL learning data 
    and identify where memory retention is failing: {learning_data}
    
    Provide specific insights about:
    1. Which SQL concepts are being forgotten most quickly
    2. Optimal review intervals based on the forgetting curve
    3. Why traditional SQL tutorials fail at memory retention"""
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {"role": "user", "content": prompt}
        ]
    )
    
    return message.content[0].text


def generate_spaced_repetition_schedule(sql_topics: list, skill_level: str) -> str:
    """Generate a personalized spaced repetition schedule for SQL concepts based on cognitive science."""
    client = anthropic.Anthropic()
    
    prompt = f"""Create a spaced repetition schedule for learning these SQL topics: {sql_topics}
    
    Student skill level: {skill_level}
    
    Apply spaced repetition principles to:
    1. Schedule initial learning sessions
    2. Plan review intervals (1 day, 3 days, 1 week, 2 weeks, 1 month)
    3. Identify which topics need more frequent review
    4. Explain how this rewires technical memory for SQL"""
    
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {"role": "user", "content": prompt}
        ]
    )
    
    return message.content[0].text


def create_active_recall_exercises(sql_concept: str, passive_content: str) -> str:
    """Transform passive SQL reading material into active recall exercises using research-backed techniques."""
    client = anthropic.Anthropic()
    
    prompt = f"""Convert this passive SQL learning content into active recall exercises.
    
    SQL Concept: {sql_concept}
    Passive Content: {passive_content}
    
    Create exercises that:
    1. Test understanding without looking at notes (active recall)
    2. Use the testing effect to strengthen memory
    3. Progress from
