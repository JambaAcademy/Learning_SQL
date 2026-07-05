import anthropic

client = anthropic.Anthropic()


def explain_window_vs_groupby(query_example: str) -> str:
    """Explains why window functions preserve rows while GROUP BY collapses them."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Explain the difference between window functions and GROUP BY for this SQL query: {query_example}. Show how window functions preserve rows while GROUP BY collapses them.",
            }
        ],
    )
    return message.content[0].text


def generate_ranking_query(
    table_name: str, partition_column: str, order_column: str
) -> str:
    """Generates SQL examples using ROW_NUMBER, RANK, and DENSE_RANK with OVER clause."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Generate SQL examples using ROW_NUMBER(), RANK(), and DENSE_RANK() window functions for table '{table_name}', partitioned by '{partition_column}' and ordered by '{order_column}'. Show the differences between each ranking function.",
            }
        ],
    )
    return message.content[0].text


def create_lag_lead_analysis(
    table_name: str, value_column: str, time_column: str
) -> str:
    """Creates SQL queries using LAG and LEAD to compare rows with previous/next values."""
    message = client.messages.create(
        model="claude-opus-4-5",
        max_tokens=1024,
        messages=[
            {
                "role": "user",
                "content": f"Create SQL queries using LAG() and LEAD() window functions for table '{table_name}' to compare '{value_column}' values across time column '{time_column}'. Include examples showing period-over-period changes.",
            }
        ],
    )
    return message.content[0].text


def build_running_totals_query(
    table_name: str, amount_column: str, date_column: str, partition_column: str = None
) -> str:
    """Builds SQL for running totals and moving averages using SUM and AVG window functions."""
    partition_info = (
