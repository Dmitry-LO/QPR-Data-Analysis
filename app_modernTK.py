import os
import customtkinter as ctk
from tkinter import filedialog
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk
import matplotlib.pyplot as plt
from funclib.importf import *
from funclib.plotfunctions import *

# Enable DPI awareness
import ctypes
try:
    ctypes.windll.shcore.SetProcessDpiAwareness(2)
except:
    pass

# Set CustomTkinter theme and appearance
ctk.set_appearance_mode("light")  # Options: "dark", "light", "system"
ctk.set_default_color_theme("blue")  # Options: "blue", "green", "dark-blue"


class App:
    def __init__(self, root):
        self.root = root
        self.root.title("Data Processing and Plotting App")
        self.sc = 1.5
        self.windowscale=f"{int(np.floor(1920/self.sc))}x{int(np.floor(980/self.sc))}"
        self.root.geometry(self.windowscale)

        # Create the left frame for controls
        self.control_frame = ctk.CTkFrame(self.root, width=300)
        self.control_frame.pack(side="left", fill="y", padx=10, pady=10)

        # Line 1: Open Folder Button
        self.open_button = ctk.CTkButton(self.control_frame, text="Open Folder", command=self.open_folder)
        self.open_button.pack(pady=10)

        # Line 2: Selected Folder Label
        self.path_label = ctk.CTkLabel(self.control_frame, text="No folder selected", wraplength=250)
        self.path_label.pack(pady=5)

        # Line 3: X Axis and Resolution
        x_axis_frame = ctk.CTkFrame(self.control_frame)
        x_axis_frame.pack(pady=5, fill="x")

        ctk.CTkLabel(x_axis_frame, text="X Axis").grid(row=0, column=0, padx=5, sticky="w")
        self.x_axis_var = ctk.StringVar(value=FieldNames.PEAK_FIELD)  # Default Value
        self.x_axis_dropdown = ctk.CTkComboBox(x_axis_frame, variable=self.x_axis_var, width=200,
                                               values=[getattr(FieldNames, attr) for attr in dir(FieldNames) if
                                                       not attr.startswith("__")])
        self.x_axis_dropdown.grid(row=1, column=0, padx=5, sticky="w")

        ctk.CTkLabel(x_axis_frame, text="Resolution").grid(row=0, column=1, padx=5, sticky="w")
        self.resolution_entry = ctk.CTkEntry(x_axis_frame, width=100)
        self.resolution_entry.insert(0, "0.1")
        self.resolution_entry.grid(row=1, column=1, padx=5, sticky="w")

        # Line 4: Y Axis
        y_axis_frame = ctk.CTkFrame(self.control_frame)
        y_axis_frame.pack(pady=5, fill="x")

        ctk.CTkLabel(y_axis_frame, text="Y Axis").grid(row=0, column=0, padx=5, sticky="w")
        self.y_axis_var = ctk.StringVar(value=FieldNames.RS)  # Default Value
        self.y_axis_dropdown = ctk.CTkComboBox(y_axis_frame, variable=self.y_axis_var, width=200,
                                               values=[getattr(FieldNames, attr) for attr in dir(FieldNames) if
                                                       not attr.startswith("__")])
        self.y_axis_dropdown.grid(row=1, column=0, padx=5, sticky="w")

        # Line 5: Param Name, Value, and Tolerance
        param_frame = ctk.CTkFrame(self.control_frame)
        param_frame.pack(pady=5, fill="x")

        ctk.CTkLabel(param_frame, text="Parameter Name").grid(row=0, column=0, padx=5, sticky="w")
        self.param_name_var = ctk.StringVar(value=FieldNames.SENS_B)  # Default Value
        self.param_name_dropdown = ctk.CTkComboBox(param_frame, variable=self.param_name_var, width=200,
                                                   values=[getattr(FieldNames, attr) for attr in dir(FieldNames) if
                                                           not attr.startswith("__")])
        self.param_name_dropdown.grid(row=1, column=0, padx=5, sticky="w")

        ctk.CTkLabel(param_frame, text="Value").grid(row=0, column=1, padx=5, sticky="w")
        self.param_val_entry = ctk.CTkEntry(param_frame, width=100)
        self.param_val_entry.insert(0, "2.5")
        self.param_val_entry.grid(row=1, column=1, padx=5, sticky="w")

        ctk.CTkLabel(param_frame, text="Tolerance").grid(row=0, column=2, padx=5, sticky="w")
        self.param_tol_entry = ctk.CTkEntry(param_frame, width=100)
        self.param_tol_entry.insert(0, "0.1")
        self.param_tol_entry.grid(row=1, column=2, padx=5, sticky="w")

        # Line 6: Run Selection Field
        ctk.CTkLabel(self.control_frame, text="Select Runs (e.g., 1,3,4,5)").pack(pady=5)
        self.run_entry = ctk.CTkEntry(self.control_frame, width=250)
        self.run_entry.pack(pady=5)

        # Line 7 and beyond: Checkboxes and Process/Plot Button
        self.combine_run_var = ctk.BooleanVar(value=True)
        ctk.CTkCheckBox(self.control_frame, text="Combine Run", variable=self.combine_run_var).pack(pady=5)

        self.combine_fname_var = ctk.BooleanVar(value=True)
        ctk.CTkCheckBox(self.control_frame, text="Combine Filename", variable=self.combine_fname_var).pack(pady=5)

        self.combine_dc_var = ctk.BooleanVar(value=True)
        ctk.CTkCheckBox(self.control_frame, text="Combine DC", variable=self.combine_dc_var).pack(pady=5)

        self.plot_button = ctk.CTkButton(self.control_frame, text="Process and Plot", command=self.process_and_plot)
        self.plot_button.pack(pady=10)

        # Right frame for the plot
        self.plot_frame = ctk.CTkFrame(self.root)
        self.plot_frame.pack(side="right", fill="both", expand=True, padx=10, pady=10)

    def open_folder(self):
        self.folder_path = filedialog.askdirectory()
        if self.folder_path:
            self.path_label.configure(text=self.folder_path)

    def process_and_plot(self):
        if not hasattr(self, 'folder_path') or not self.folder_path:
            self.path_label.configure(text="Please select a folder first!", text_color="red")
            return
        self.root.geometry(self.windowscale)
        self.path_label.configure(text_color="white")

        # Your plotting logic here
        try:
            TestPath = self.folder_path
            Test1 = HandleTest(TestPath)
            Test1Data = Test1.load_data(pattern="*41*MHz*.txt")

            # Filter Data
            x_axis = self.x_axis_var.get() or FieldNames.PEAK_FIELD
            y_axis = self.y_axis_var.get() or FieldNames.RS
            filtered_data, all_filtered = Test1.filter_data(
                x=x_axis, y=y_axis, param_name=self.param_name_var.get(),
                param_val=float(self.param_val_entry.get()),
                param_tol=float(self.param_tol_entry.get()),
                res=float(self.resolution_entry.get()),
                run=[int(x.strip()) for x in self.run_entry.get().split(",")] if self.run_entry.get() else None,
                combine_run=self.combine_run_var.get(),
                combine_fname=self.combine_fname_var.get(),
                combine_dc=self.combine_dc_var.get()
            )

            # Clear previous plot
            for widget in self.plot_frame.winfo_children():
                widget.destroy()

            # Plot data
            self.fig = plt.figure(figsize=(9, 6))
            plot_data_forApp(data=filtered_data, scatter=all_filtered, nsig=3, x=x_axis, y=y_axis)

            self.canvas = FigureCanvasTkAgg(self.fig, master=self.plot_frame)
            self.toolbar = NavigationToolbar2Tk(self.canvas, self.plot_frame)
            self.toolbar.update()
            self.canvas.get_tk_widget().pack(fill="both", expand=False)
            self.canvas.draw()

        except Exception as e:
            self.path_label.configure(text=f"Error: {e}", text_color="red")


if __name__ == "__main__":
    root = ctk.CTk()
    app = App(root)
    root.mainloop()
