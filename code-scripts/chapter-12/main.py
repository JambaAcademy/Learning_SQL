def check_normalization_form(table_schema: dict) -> str:
    """Evaluate a table schema and return its highest achieved normal form (1NF, 2NF, or 3NF)."""
    pass


def build_star_schema_query(fact_table: str, dimension_tables: list[str], metrics: list[str], filters: dict) -> str:
    """Generate a SQL SELECT statement joining a fact table to its dimension tables with optional filters."""
    pass


def profile_index_usage(table_name: str, query_patterns: list[str]) -> dict:
    """Analyse a set of query patterns against a table and recommend which columns should be indexed."""
    pass


def parse_data_dictionary(doc_path: str) -> list[dict]:
    """Read a data dictionary file and return a list of column metadata records including name, type, and description."""
    pass


def compare_schema_designs(snowflake_schema: dict, star_schema: dict) -> dict:
    """Compare a snowflake and star schema design and return a summary of trade-offs in join complexity and redundancy."""
    pass