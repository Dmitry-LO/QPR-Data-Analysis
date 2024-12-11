import tkinter as tk
from tkinter import filedialog, ttk
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import matplotlib.pyplot as plt
from funclib.importf import *

class App:
    def __init__(self, root):
        self.root = root
        self.root.title("Data Processing and Plotting App")

        # Create the left frame for controls
        self.control_frame = tk.Frame(self.root)
        self.control_frame.pack(side=tk.LEFT, fill=tk.Y, padx=10, pady=10)

        # Add a button to open folder
        self.open_button = tk.Button(self.control_frame, text="Open Folder", command=self.open_folder, width=25)
        self.open_button.pack(pady=5)

        # Add a label to show the selected path
        self.path_label = tk.Label(self.control_frame, text="No folder selected", wraplength=200, width=25)
        self.path_label.pack(pady=5)

        # Add parameter selection inputs
        self.param_label = tk.Label(self.control_frame, text="Parameter Name", width=25)
        self.param_label.pack(pady=5)

        # Parameter dropdown menu
        self.param_name_var = tk.StringVar()
        self.param_dropdown = ttk.Combobox(self.control_frame, textvariable=self.param_name_var, state="readonly", width=25)
        self.param_dropdown['values'] = [getattr(FieldNames, attribute) for attribute in dir(FieldNames) if not attribute.startswith("__")]
        self.param_dropdown.pack(pady=5)

        # Add x axis
        self.x_label = tk.Label(self.control_frame, text="X Axis")
        self.x_label.pack(pady=5)

        # x axis dropdown menu
        self.x_name_var = tk.StringVar()
        self.x_dropdown = ttk.Combobox(self.control_frame, textvariable=self.x_name_var, state="readonly", width=25)
        self.x_dropdown['values'] = [getattr(FieldNames, attribute) for attribute in dir(FieldNames) if not attribute.startswith("__")]
        self.x_dropdown.pack(pady=5)

        # Add y axis
        self.y_label = tk.Label(self.control_frame, text="Y Axis")
        self.y_label.pack(pady=5)

        # y axis dropdown menu
        self.y_name_var = tk.StringVar()
        self.y_dropdown = ttk.Combobox(self.control_frame, textvariable=self.y_name_var, state="readonly", width=25)
        self.y_dropdown['values'] = [getattr(FieldNames, attribute) for attribute in dir(FieldNames) if not attribute.startswith("__")]
        self.y_dropdown.pack(pady=5)
        


        self.param_val_label = tk.Label(self.control_frame, text="Parameter Value")
        self.param_val_label.pack(pady=5)
        self.param_val_entry = tk.Entry(self.control_frame)
        self.param_val_entry.pack(pady=5)

        self.param_tol_label = tk.Label(self.control_frame, text="Parameter Tolerance")
        self.param_tol_label.pack(pady=5)
        self.param_tol_entry = tk.Entry(self.control_frame)
        self.param_tol_entry.pack(pady=5)

        self.step_label = tk.Label(self.control_frame, text="Step")
        self.step_label.pack(pady=5)
        self.step_entry = tk.Entry(self.control_frame)
        self.step_entry.pack(pady=5)

        # Add a button to process and plot
        self.plot_button = tk.Button(self.control_frame, text="Process and Plot", command=self.process_and_plot)
        self.plot_button.pack(pady=5)

        # Create the right frame for the plot
        self.plot_frame = tk.Frame(self.root)
        self.plot_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

    def open_folder(self):
        self.folder_path = filedialog.askdirectory()
        if self.folder_path:
            self.path_label.config(text=self.folder_path)

    def process_and_plot(self):
        if not hasattr(self, 'folder_path') or not self.folder_path:
            self.path_label.config(text="Please select a folder first!", fg="red")
            return

        self.path_label.config(fg="black")

        # Get user parameters
        x = self.x_name_var.get() or FieldNames.PEAK_FIELD
        y = self.y_name_var.get() or FieldNames.RS
        param_name = self.param_name_var.get() or FieldNames.SENS_B
        param_val = float(self.param_val_entry.get()) if self.param_val_entry.get() else 2.5
        param_tol = float(self.param_tol_entry.get()) if self.param_tol_entry.get() else 0.05
        step = float(self.step_entry.get()) if self.step_entry.get() else 0.5

        # Handle the test
        TestPath = self.folder_path
        Test1 = HandleTest(TestPath)
        Test1Data = Test1.load_data(pattern="*41*MHz*.txt")

        # Generate the data for the plot
        ax, ay, bx, by = Test1.plot_histogram(x=x, y=y, step=step, ParamName=param_name, ParamVal=param_val, ParamTol=param_tol)

        # Clear any existing plot
        for widget in self.plot_frame.winfo_children():
            widget.destroy()

        # Create a matplotlib figure
        fig, ax1 = plt.subplots(dpi=100)

        # Plot histogram
        ax1.bar(ax, ay, width=step, align='center', alpha=0.7, label="Histogram")
        ax1.set_xlabel(x)
        ax1.set_ylabel("Point Number", color="blue")
        ax1.tick_params(axis="y", labelcolor="blue")
        ax1.grid(True)

        # Create the second Y-axis and plot surface resistance
        ax2 = ax1.twinx()
        ax2.scatter(bx, by, color="red", label="Scatter Plot", s=2)
        ax2.set_ylabel(y, color="red")
        ax2.tick_params(axis="y", labelcolor="red")

        # Add legends and title
        ax1.legend(loc="upper left")
        ax2.legend(loc="upper right")
        plt.title("Histogram with Scatter Overlay")

        # Embed the plot into Tkinter
        canvas = FigureCanvasTkAgg(fig, master=self.plot_frame)
        canvas_widget = canvas.get_tk_widget()
        canvas_widget.pack(fill=tk.BOTH, expand=True)
        canvas.draw()

if __name__ == "__main__":
    root = tk.Tk()
    app = App(root)
    root.mainloop()
