import anthropic

client = anthropic.Anthropic()


def clean_string_data(raw_string: str, operation: str) -> str:
    """Apply SQL-equivalent string functions (UPPER, LOWER, TRIM, etc.) to clean raw text data."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Apply the {operation} string operation to this text and return only the result: '{raw_string}'",
            }
        ],
    )
    return message.content[0].text.strip()


def parse_and_format_date(date_string: str, output_format: str = "YYYY-MM-DD") -> dict:
    """Parse raw date strings and extract components (year, month, day) for time-series analysis."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"""Parse this date string: '{date_string}' and return a JSON object with these fields:
                - formatted_date: date in {output_format} format
                - year: extracted year
                - month: extracted month number
                - day: extracted day
                - day_of_week: day name
                Return only valid JSON, no explanation.""",
            }
        ],
    )
    import json

    return json.loads(message.content[0].text.strip())


def apply_numeric_function(value: float, function: str, decimal_places: int = 2) -> float:
    """Apply numeric transformation functions (ROUND, FLOOR, CEILING, ABS) to clean numeric data."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=256,
        messages=[
            {
                "role": "user",
                "content": f"Apply {function} to {value} with {decimal_places} decimal places and return only the numeric result.",
            }
        ],
    )
    return float(message.content[0].text.strip())


def create_conditional_buckets(value: float, column_name: str, thresholds: list) -> str:
    """Implement CASE WHEN logic to categorize numeric values into meaningful business buckets."""
    thresholds_str = ", ".join([f"{t['label']
