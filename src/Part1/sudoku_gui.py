import os
import sys

from PyQt6.QtWidgets import (
    QApplication, QMainWindow, QWidget,     QGridLayout, 
    QVBoxLayout,  QHBoxLayout, QPushButton, QLineEdit, 
    QFileDialog,  QLabel,      QFrame,      QMessageBox
)
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QFont, QIntValidator

from utils import load_qss, base_path
from sudoku_solver import SudokuSolver

class SudokuCell(QLineEdit):
    """
    @brief Single Sudoku cell setting
    """
    def __init__(self):
        super().__init__()
        self.setFixedSize(50, 50)
        self.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.setFont(QFont("Arial", 20))
        self.setMaxLength(1)
        self.setValidator(QIntValidator(1, 9))

        default_style_path = os.path.join(base_path(), "css_styles", "default_style.qss")
        solved_style_path = os.path.join(base_path(), "css_styles", "solved_style.qss")

        self.default_style = load_qss(default_style_path)
        self.solved_style = load_qss(solved_style_path)

        self.setStyleSheet(self.default_style)

    def set_solved_style(self):
        self.setStyleSheet(self.solved_style)

    def reset_style(self):
        self.clear()
        self.setStyleSheet(self.default_style)


class SudokuMainWindow(QMainWindow):
    """
    @brief Main window setting
    """
    def __init__(self):
        super().__init__()
        self.setWindowTitle(None)
        self.setFixedSize(600, 750)

        self.setStyleSheet("background-color: #333333;")
        
        self.solver = SudokuSolver()
        self.cells = [[None for _ in range(9)] for _ in range(9)]

        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        self.main_layout = QVBoxLayout(central_widget) # Veritical Layout
        self.main_layout.setContentsMargins(20, 20, 20, 20)
        self.main_layout.setSpacing(15)

        title = QLabel("Sudoku")
        title.setFont(QFont("Arial", 25, QFont.Weight.Bold))
        title.setAlignment(Qt.AlignmentFlag.AlignCenter)
        title.setStyleSheet("color: #DDDDDD")
        self.main_layout.addWidget(title)

        self.grid_panel()

        self.info_panel = QLabel("Sudoku Game")
        self.info_panel.setObjectName("info_panel")
        self.info_panel.setFont(QFont("Arial", 20))

        panel_style_path = os.path.join(base_path(), "css_styles", "panel_style.qss")

        self.info_panel.setStyleSheet(load_qss(panel_style_path))
        self.info_panel.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.main_layout.addWidget(self.info_panel)

        self.button_panel()

        self.center_window()

    def grid_panel(self):
        """ 
        @brief Create and initialize the 9x9 Sudoku grid.
        """
        grid_container = QWidget()

        outer_layout = QGridLayout(grid_container)
        outer_layout.setSpacing(10)

        for br in range(3):
            for bc in range(3):
                block_frame = QFrame()
                block_frame.setStyleSheet("background-color: #DDDDDD; border-radius: 5px;") 
                inner_layout = QGridLayout(block_frame)
                inner_layout.setSpacing(2)
                inner_layout.setContentsMargins(2, 2, 2, 2)

                for i in range(3):
                    for j in range(3):
                        global_r = br * 3 + i
                        global_c = bc * 3 + j
                        
                        cell = SudokuCell()
                        self.cells[global_r][global_c] = cell
                        inner_layout.addWidget(cell, i, j)
                
                outer_layout.addWidget(block_frame, br, bc)

        self.main_layout.addWidget(
            grid_container, 
            alignment = Qt.AlignmentFlag.AlignCenter
        )

    def button_panel(self):
        """ 
        @brief Create the bottom control panel(`Load`, `Solve`, `Clear`). 
        """
        btn_layout = QHBoxLayout()
        
        button_style_path = os.path.join(base_path(), "css_styles", "button_style.qss")

        btn_load = QPushButton("Load CSV")
        btn_load.setStyleSheet(load_qss(button_style_path))
        btn_load.clicked.connect(self.load_csv)
        
        btn_solve = QPushButton("Solve Now")
        btn_solve.setStyleSheet(load_qss(button_style_path))
        btn_solve.clicked.connect(self.solve_puzzle)
        
        btn_clear = QPushButton("Clear")
        btn_clear.setStyleSheet(load_qss(button_style_path))
        btn_clear.clicked.connect(self.clear_board)

        btn_layout.addWidget(btn_load)
        btn_layout.addWidget(btn_solve)
        btn_layout.addWidget(btn_clear)
        
        self.main_layout.addLayout(btn_layout)

    def load_csv(self):
        """
        @brief Load a Sudoku puzzle from a CSV file based on `SudokuSolver::load_from_csv()`.
        """
        file_path, _ = QFileDialog.getOpenFileName(self, "Open CSV", base_path(), "CSV Files (*.csv)")
        if file_path:
            success = self.solver.load_from_csv(file_path)
            if success:
                self.update_ui_from_solver()
                self.info_panel.setText(f"File Loaded: {file_path.split('/')[-1]}")
            else:
                QMessageBox.critical(self, "Error", "File loaded failed")

    def update_ui_from_solver(self):
        """
        @brief Update the GUI grid to reflect the current state. 
        """
        for r in range(9):
            for c in range(9):
                val = self.solver.board[r][c]
                cell = self.cells[r][c]
                cell.reset_style()
                if val != 0:
                    cell.setText(str(val))
                else:
                    cell.setText("")

    def sync_gui_to_backend(self):
        """
        @brief Push current user inputs into the board.
        """
        current_board = []
        for r in range(9):
            row_data = []
            for c in range(9):
                text = self.cells[r][c].text()
                if text.isdigit():
                    row_data.append(int(text))
                else:
                    row_data.append(0)
            current_board.append(row_data)
        
        self.solver.board = current_board

    def solve_puzzle(self):
        """
        @brief Solve the Sudoku puzzle based on `SudokuSolver::run_solver()`.
        """
        try:
            self.sync_gui_to_backend()

            if not self.self_check_isvalid():
                raise ValueError("[WARNING] Contradiction appears")
            
            if not self.solver.run_solver():
                raise ValueError("[ERROR] The question is fucking difficult")
            
            for r in range(9):
                for c in range(9):
                    val = self.solver.board[r][c]
                    cell = self.cells[r][c]
                    cell.setText(str(val))
                    cell.set_solved_style()

            metrics = (f"🕒 Time: {self.solver.execution_time:.2f} ms  |  "
                    f"🔢 Steps: {self.solver.steps}  |  "
                    f"🔙 Backtracks: {self.solver.backtracks}")
            self.info_panel.setText(metrics)
            self.solver.print_metrics()
            
        except Exception as e:
            print(e)
            self.info_panel.setText("Try again!")
            QMessageBox.critical(self, "Error", str(e))

    def self_check_isvalid(self):
        """
        @brief Check if the current grid contains contradictions.
        """
        board = self.solver.board
        
        for r in range(9):
            for c in range(9):
                num = board[r][c]
                if num != 0:
                   
                    board[r][c] = 0 
                    if not self.solver.is_valid(r, c, num):
                        board[r][c] = num
                        return False
                    board[r][c] = num
        return True
    
    def center_window(self):
        """
        @brief Center the window based on the current display resolution.
        """
        screen = QApplication.primaryScreen()
        screen_geometry = screen.availableGeometry()
        window_geometry = self.frameGeometry()
        window_geometry.moveCenter(screen_geometry.center())
        self.move(window_geometry.topLeft())

    def clear_board(self):
        """
        @brief Clear the current board.
        """
        self.solver.board = [[0]*9 for _ in range(9)]
        for r in range(9):
            for c in range(9):
                self.cells[r][c].clear()
                self.cells[r][c].reset_style()
        self.info_panel.setText("Clear!")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    
    app.setStyle("Fusion") 
    
    window = SudokuMainWindow()
    window.show()
    sys.exit(app.exec())