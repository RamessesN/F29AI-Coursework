import csv
import time

class SudokuSolver:
    def __init__(self):
        self.board = []
        # Relevant metrics
        self.steps = 0            # Total number of steps
        self.recursive_calls = 0  # Recursive calls
        self.backtracks = 0       # Backtracks
        self.start_time = 0
        self.execution_time = 0

    def load_from_csv(self, filepath):
        """
        @brief Read and transfre `CSV` to 2D list

        This function reads a CSV file containing a 9x9 Sudoku grid, where empty cells may be 
        represented by blank entries. It trims whitespace, validates digit entries, and stores
        the parsed puzzle in `self.board`.
        
        @param self Reference to the SudokuSolver instance.
        @param filepath Full path to the CSV file to be loaded.

        @return True if the file is successfully loaded and the board is valid; 
                False otherwise.

        @exception ValueError Thrown when the CSV file does not contain exactly 9 valid rows.
        @exception Exception Catch-all for unexpected file I/O errors or malformed input.
        """
        self.board = []
        try:
            with open(filepath, 'r', encoding='utf8') as f:
                reader = csv.reader(f)
                for row in reader:
                    # Converts the string to an integer, handling possible whitespace
                    index = [int(num.strip()) for num in row if num.strip().isdigit()]
                    if len(index) == 9:
                        self.board.append(index)
            
            if len(self.board) != 9:
                raise ValueError("Invalid row count in CSV")
            
            print(f"[Succeed] File loaded: {filepath}")
            return True
        except Exception as e:
            print(f"[Error] File loading failed: {e}")
            return False

    def is_valid(self, row, col, num):
        """
        @brief Check if a given number can be legally placed in a specific cell of the Sudoku board.

        This function checks the Sudoku constraints:
        1. The number does not already exist in the same row.
        2. The number does not already exist in the same column.
        3. The number does not already exist in the 3x3 subgrid containing the cell.

        @param self Reference to the SudokuSolver instance.
        @param row The row index (0-8) of the cell to check.
        @param col The column index (0-8) of the cell to check.
        @param num The number (1-9) to validate for placement.

        @return True if the number can be legally placed in the cell;
                False if placing the number violates Sudoku rules.
        """
        # Row check
        for x in range(9):
            if self.board[row][x] == num:
                return False

        # Column check
        for x in range(9):
            if self.board[x][col] == num:
                return False

        # 3x3 box check
        start_row = row - row % 3
        start_col = col - col % 3
        for i in range(3):
            for j in range(3):
                if self.board[i + start_row][j + start_col] == num:
                    return False
        
        return True

    def solve_algorithm(self):
        """
        @brief Solve the Sudoku puzzle using backtracking with pruning.

        This function implements a recursive backtracking algorithm to fill empty cells
        in the Sudoku board. It tries numbers 1-9 for each empty cell and checks validity
        using `is_valid`. If a number is valid, it is placed in the cell and the algorithm
        proceeds recursively. If a dead-end is reached, it backtracks and tries the next number.

        Additionally, the function tracks several metrics:
        - `self.steps` counts the total number of attempted placements.
        - `self.recursive_calls` counts the total number of recursive calls.
        - `self.backtracks` counts the total number of backtracking operations performed.

        @param self Reference to the SudokuSolver instance.

        @return True if the Sudoku puzzle is successfully solved; 
                False if no valid solution exists.
        """
        self.recursive_calls += 1
        
        for i in range(9):
            for j in range(9):
                if self.board[i][j] == 0:
                    for num in range(1, 10):
                        self.steps += 1
                        # If invalid, prune it
                        if self.is_valid(i, j, num):
                            self.board[i][j] = num
                            
                            if self.solve_algorithm():
                                return True
                            
                            # Backtracking
                            self.board[i][j] = 0
                            self.backtracks += 1
                    
                    return False
        return True

    def run_solver(self):
        """
        @brief Initialize metrics and run the Sudoku solver.

        This function sets up the tracking variables for the solving process, including:
        - `self.steps` : counts the total number of attempted placements.
        - `self.recursive_calls` : counts the number of recursive calls.
        - `self.backtracks` : counts the number of backtracking operations.

        It then records the start time, calls the main solving algorithm 
        (`solve_algorithm`), measures the end time, and computes the total 
        execution time in milliseconds.

        @param self Reference to the SudokuSolver instance.

        @return True if the Sudoku puzzle is successfully solved; 
                False otherwise.
        """
        self.steps = 0
        self.recursive_calls = 0
        self.backtracks = 0
        
        self.start_time = time.perf_counter()
        
        success = self.solve_algorithm()
        
        end_time = time.perf_counter()
        self.execution_time = (end_time - self.start_time) * 1000
        
        return success

    def print_metrics(self):
        """
        @brief Print the performance metrics of the Sudoku solver.

        @param self Reference to the SudokuSolver instance.
        """
        print("\n")
        print(f"Execution Time: {self.execution_time:.4f} ms")
        print(f"Total Steps (Attempts): {self.steps}")
        print(f"Recursive Calls: {self.recursive_calls}")
        print(f"Backtracks: {self.backtracks}")
        print("\n")