import os
import tkinter as tk
from tkinter import filedialog, ttk
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk
import matplotlib.pyplot as plt
from itertools import product
from funclib.importf import *
from funclib.plotfunctions import *



import ctypes
try:
    ctypes.windll.shcore.SetProcessDpiAwareness(2)  # DPI awareness enabled
except:
    pass


class App:
    def __init__(self, root):
        self.root = root
        self.root.title("Data Processing and Plotting App")

        # Create the left frame for controls
        self.control_frame = tk.Frame(self.root)
        self.control_frame.pack(side=tk.LEFT, fill=tk.Y, padx=10, pady=10)

        # Line 1: Open Folder Button
        self.open_button = tk.Button(self.control_frame, text="Open Folder", command=self.open_folder, width=25)
        self.open_button.pack(pady=5)

        # Line 2: Selected Folder Label
        self.path_label = tk.Label(self.control_frame, text="No folder selected", wraplength=200, width=25)
        self.path_label.pack(pady=5)

        # Line 3: X Axis and Resolution
        x_axis_frame = tk.Frame(self.control_frame)
        x_axis_frame.pack(pady=5, fill=tk.X)

        tk.Label(x_axis_frame, text="X Axis").grid(row=0, column=0, padx=5, sticky="w")
        self.x_axis_var = tk.StringVar(value=FieldNames.PEAK_FIELD)  # Default Value
        self.x_axis_dropdown = ttk.Combobox(x_axis_frame, textvariable=self.x_axis_var, state="readonly", width=25)
        self.x_axis_dropdown['values'] = [getattr(FieldNames, attr) for attr in dir(FieldNames) if not attr.startswith("__")]
        self.x_axis_dropdown.grid(row=1, column=0, padx=5, sticky="w")

        tk.Label(x_axis_frame, text="Resolution").grid(row=0, column=1, padx=5, sticky="w")
        self.resolution_entry = tk.Entry(x_axis_frame, width=10)
        self.resolution_entry.insert(0, "0.1")
        self.resolution_entry.grid(row=1, column=1, padx=5, sticky="w")

        # Line 4: Y Axis
        y_axis_frame = tk.Frame(self.control_frame)
        y_axis_frame.pack(pady=5, fill=tk.X)

        tk.Label(y_axis_frame, text="Y Axis").grid(row=0, column=0, padx=5, sticky="w")
        self.y_axis_var = tk.StringVar(value=FieldNames.RS)  # Default Value
        self.y_axis_dropdown = ttk.Combobox(y_axis_frame, textvariable=self.y_axis_var, state="readonly", width=25)
        self.y_axis_dropdown['values'] = [getattr(FieldNames, attr) for attr in dir(FieldNames) if not attr.startswith("__")]
        self.y_axis_dropdown.grid(row=1, column=0, padx=5, sticky="w")

        # Line 5: Param Name, Value, and Tolerance
        param_frame = tk.Frame(self.control_frame)
        param_frame.pack(pady=5, fill=tk.X)

        tk.Label(param_frame, text="Parameter Name").grid(row=0, column=0, padx=5, sticky="w")
        self.param_name_var = tk.StringVar(value=FieldNames.SENS_B)  # Default Value
        self.param_name_dropdown = ttk.Combobox(param_frame, textvariable=self.param_name_var, state="readonly", width=25)
        self.param_name_dropdown['values'] = [getattr(FieldNames, attr) for attr in dir(FieldNames) if not attr.startswith("__")]
        self.param_name_dropdown.grid(row=1, column=0, padx=5, sticky="w")

        tk.Label(param_frame, text="Value").grid(row=0, column=1, padx=5, sticky="w")
        self.param_val_entry = tk.Entry(param_frame, width=10)
        self.param_val_entry.insert(0, "2.5")
        self.param_val_entry.grid(row=1, column=1, padx=5, sticky="w")

        tk.Label(param_frame, text="Tolerance").grid(row=0, column=2, padx=5, sticky="w")
        self.param_tol_entry = tk.Entry(param_frame, width=10)
        self.param_tol_entry.insert(0, "0.1")
        self.param_tol_entry.grid(row=1, column=2, padx=5, sticky="w")

        # Line 6: Run Selection Field
        tk.Label(self.control_frame, text="Select Runs (e.g., 1,3,4,5)").pack(pady=5, anchor="w")
        self.run_entry = tk.Entry(self.control_frame, width=27)
        self.run_entry.pack(pady=5, anchor="w")

        # Line 7 and beyond: Checkboxes and Process/Plot Button
        self.combine_run_var = tk.BooleanVar(value=True)
        tk.Checkbutton(self.control_frame, text="Combine Run", variable=self.combine_run_var).pack(pady=5, anchor="w")

        self.combine_fname_var = tk.BooleanVar(value=True)
        tk.Checkbutton(self.control_frame, text="Combine Filename", variable=self.combine_fname_var).pack(pady=5, anchor="w")

        self.combine_dc_var = tk.BooleanVar(value=True)
        tk.Checkbutton(self.control_frame, text="Combine DC", variable=self.combine_dc_var).pack(pady=5, anchor="w")

        self.plot_button = tk.Button(self.control_frame, text="Process and Plot", command=self.process_and_plot)
        self.plot_button.pack(pady=5)

        # Right frame for the plot
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
        self.root.geometry("1920x980")
        self.path_label.config(fg="black")

        # Collect user inputs
        x_axis = self.x_axis_var.get() or FieldNames.PEAK_FIELD
        y_axis = self.y_axis_var.get() or FieldNames.RS
        res = float(self.resolution_entry.get()) if self.resolution_entry.get() else 0.1
        param_name = self.param_name_var.get() or FieldNames.SENS_B
        param_val = float(self.param_val_entry.get()) if self.param_val_entry.get() else 2.5
        param_tol = float(self.param_tol_entry.get()) if self.param_tol_entry.get() else 0.1

        # Process runs input (convert to list of integers)
        run_input = self.run_entry.get()
        runs = [int(x.strip()) for x in run_input.split(",")] if run_input else None

        combine_run = self.combine_run_var.get()
        combine_fname = self.combine_fname_var.get()
        combine_dc = self.combine_dc_var.get()

        # Step 1: Load Data
        try:
            TestPath = self.folder_path
            Test1 = HandleTest(TestPath)
            Test1Data = Test1.load_data(pattern="*41*MHz*.txt")

            # Step 2: Filter Data
            filtered_data, all_filtered = Test1.filter_data(
                x=x_axis,
                y=y_axis,
                param_name=param_name,
                param_val=param_val,
                param_tol=param_tol,
                res=res,
                run=runs,
                combine_run=combine_run,
                combine_fname=combine_fname,
                combine_dc=combine_dc,
            )

            # Step 3: Clear Previous Plot
            for widget in self.plot_frame.winfo_children():
                widget.destroy()

            # Step 4: Plot Data
            self.fig = plt.figure(figsize=(9, 6))
            plot_data_forApp(data=filtered_data, scatter=all_filtered, nsig=3, x=x_axis, y=y_axis)

            # Embed the plot into Tkinter with a toolbar
            self.canvas = FigureCanvasTkAgg(self.fig, master=self.plot_frame)
            self.toolbar = NavigationToolbar2Tk(self.canvas, self.plot_frame)
            self.toolbar.update()
            self.canvas_widget = self.canvas.get_tk_widget()
            self.canvas_widget.pack(fill=tk.BOTH, expand=False)
            self.canvas.draw()

        except Exception as e:
            self.path_label.config(text=f"Error: {e}", fg="red")



if __name__ == "__main__":
    root = tk.Tk()
    app = App(root)
    root.mainloop()
