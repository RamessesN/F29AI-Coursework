import os
from pathlib import Path

def base_path():
    return os.path.dirname(os.path.abspath(__file__))

def load_qss(path: str | Path) -> str:
    """
    @brief Load a QSS (Qt Style Sheet) file and return its content as a string.

    This function reads the contents of a QSS file from the provided file path..

    @param path The full or relative file path of the QSS file to load.

    @return The QSS file content as a string.
    """

    with open(path, "r", encoding="UTF-8") as f:
        return f.read()