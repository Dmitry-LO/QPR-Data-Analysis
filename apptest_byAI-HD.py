import os
import tkinter as tk
from tkinter import filedialog, ttk
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk
import matplotlib.pyplot as plt
import ctypes
from funclib.importf import *
from funclib.plotfunctions import *

# Enable High-DPI Awareness
# try:
#     ctypes.windll.shcore.SetProcessDpiAwareness(1)  # Per-monitor DPI awareness
# except AttributeError:
#     ctypes.windll.user32.SetProcessDPIAware()  # Fallback to system DPI awareness
# except Exception as e:
#     print(f"Could not set DPI awareness: {e}")

def enable_high_dpi_awareness(root=None, scaling=None):
    """Enable high dpi awareness.

    **Windows OS**  
    Call the method BEFORE creating the `Tk` object. No parameters
    required.

    **Linux OS**  
    Must provided the `root` and `scaling` parameters. Call the method 
    AFTER creating the `Tk` object. A number between 1.6 and 2.0 is 
    usually suffient to scale for high-dpi screen.

    !!! warning
        If the `root` argument is provided, then `scaling` must also
        be provided. Otherwise, there is no effect.

    Parameters:
    
        root (tk.Tk):
            The root widget

        scaling (float):
            Sets and queries the current scaling factor used by Tk to 
            convert between physical units (for example, points, 
            inches, or millimeters) and pixels. The number argument is 
            a floating point number that specifies the number of pixels 
            per point on window's display. If the window argument is 
            omitted, it defaults to the main window. If the number 
            argument is omitted, the current value of the scaling 
            factor is returned.

            A “point” is a unit of measurement equal to 1/72 inch. A 
            scaling factor of 1.0 corresponds to 1 pixel per point, 
            which is equivalent to a standard 72 dpi monitor. A scaling 
            factor of 1.25 would mean 1.25 pixels per point, which is 
            the setting for a 90 dpi monitor; setting the scaling factor 
            to 1.25 on a 72 dpi monitor would cause everything in the 
            application to be displayed 1.25 times as large as normal. 
            The initial value for the scaling factor is set when the 
            application starts, based on properties of the installed 
            monitor, but it can be changed at any time. Measurements 
            made after the scaling factor is changed will use the new 
            scaling factor, but it is undefined whether existing 
            widgets will resize themselves dynamically to accommodate 
            the new scaling factor.
    """
    try:
        from ctypes import windll
        windll.user32.SetProcessDPIAware()
    except:
        pass

    try:
        if root and scaling:
            root.tk.call('tk', 'scaling', scaling)
    except:
        pass


class App:
    def __init__(self, root):
        self.root = root
        self.root.title("Data Processing and Plotting App")

        scfactor = 1 / 3 + 1

        # Set the initial window size and position
        self.root.geometry(f"{int(1920 * scfactor)}x{int(1080 * scfactor)}+100+100")

        # Set scaling and fonts
        self.root.tk.call("tk", "scaling", 2)  # Adjust scaling for high DPI
        default_font = ("Segoe UI", 14)
        self.root.option_add("*Font", default_font)

        # Create a ttk style and apply a global font for ttk widgets
        style = ttk.Style()
        style.configure(".", font=default_font)
        style.configure("Custom.TCheckbutton", font=("Segoe UI", 14))

        # Create the left frame for controls
        self.control_frame = ttk.Frame(self.root)
        self.control_frame.pack(side=tk.LEFT, fill=tk.BOTH, padx=10, pady=10)

        # Add a button to open folder
        self.open_button = ttk.Button(self.control_frame, text="Open Folder", command=self.open_folder, width=25)
        self.open_button.pack(pady=5)

        # Add a label to show the selected path
        self.path_label = tk.Label(self.control_frame, text="No folder selected", wraplength=200, width=25)
        self.path_label.pack(pady=5)

        # Dropdown menus for x_axis, y_axis, param_name
        self.add_dropdown("X Axis", "x_axis_var")
        self.add_dropdown("Y Axis", "y_axis_var")
        self.add_dropdown("Parameter Name", "param_name_var")

        # Parameter value and tolerance input
        self.param_frame = ttk.Frame(self.control_frame)
        self.param_frame.pack(pady=5)
        ttk.Label(self.param_frame, text="Param Value/Tol").pack()

        self.param_val_entry = ttk.Entry(self.param_frame, width=12)
        self.param_val_entry.insert(0, "2.5")
        self.param_val_entry.pack(side=tk.LEFT, padx=5)

        self.param_tol_entry = ttk.Entry(self.param_frame, width=12)
        self.param_tol_entry.insert(0, "0.1")
        self.param_tol_entry.pack(side=tk.LEFT, padx=5)

        # Step size input
        ttk.Label(self.control_frame, text="Resolution").pack(pady=5)
        self.step_entry = ttk.Entry(self.control_frame, width=25)
        self.step_entry.insert(0, "0.1")
        self.step_entry.pack(pady=5)

        # Checkboxes for boolean options
        self.combine_run_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(self.control_frame, text="Combine Run", variable=self.combine_run_var).pack(pady=5)

        self.combine_fname_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(self.control_frame, text="Combine Filename", variable=self.combine_fname_var).pack(pady=5)

        self.combine_dc_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(self.control_frame, text="Combine DC", variable=self.combine_dc_var).pack(pady=5)

        # Add a button to process and plot
        self.plot_button = ttk.Button(self.control_frame, text="Process and Plot", command=self.process_and_plot)
        self.plot_button.pack(pady=5)

        # Create the right frame for the plot
        self.plot_frame = ttk.Frame(self.root)
        self.plot_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

        # Bind resize event to dynamically adjust the plot
        self.plot_frame.bind("<Configure>", self.resize_plot)

    def add_dropdown(self, label_text, var_name):
        label = ttk.Label(self.control_frame, text=label_text)
        label.pack(pady=5)

        var = tk.StringVar()
        dropdown = ttk.Combobox(self.control_frame, textvariable=var, state="readonly", width=25)
        dropdown['values'] = [getattr(FieldNames, attr) for attr in dir(FieldNames) if not attr.startswith("__")]
        dropdown.pack(pady=5)

        setattr(self, var_name, var)

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
        x = self.x_axis_var.get() or FieldNames.PEAK_FIELD
        y = self.y_axis_var.get() or FieldNames.RS
        param_name = self.param_name_var.get() or FieldNames.SENS_B
        param_val = float(self.param_val_entry.get()) if self.param_val_entry.get() else 2.5
        param_tol = float(self.param_tol_entry.get()) if self.param_tol_entry.get() else 0.1
        step = float(self.step_entry.get()) if self.step_entry.get() else 0.1

        combine_run = self.combine_run_var.get()
        combine_fname = self.combine_fname_var.get()
        combine_dc = self.combine_dc_var.get()

        # Handle the test
        TestPath = self.folder_path
        Test1 = HandleTest(TestPath)
        Test1Data = Test1.load_data(pattern="*41*MHz*.txt")

        # Filter and process data
        res, all_filtered = Test1.filter_data(
            x=x,
            y=y,
            param_name=param_name,
            param_val=param_val,
            param_tol=param_tol,
            res=step,
            combine_run=combine_run,
            combine_fname=combine_fname,
            combine_dc=combine_dc
        )

        # Clear any existing plot
        for widget in self.plot_frame.winfo_children():
            widget.destroy()

        # Create figure and plot inside it
        self.fig = plt.figure(figsize=(5, 4), dpi=100)
        plot_data_forApp(data=res, scatter=all_filtered, nsig=3, x=x, y=y)

        # Embed the plot into Tkinter with a toolbar
        self.canvas = FigureCanvasTkAgg(self.fig, master=self.plot_frame)
        self.toolbar = NavigationToolbar2Tk(self.canvas, self.plot_frame)
        self.toolbar.update()
        self.canvas_widget = self.canvas.get_tk_widget()
        self.canvas_widget.pack(fill=tk.BOTH, expand=True)
        self.canvas.draw()

        # Enable interactive mode
        self.canvas.mpl_connect("button_press_event", self.on_click)

        # Ensure initial resize after drawing
        self.root.after(100, self.fit_plot_to_frame)

    def resize_plot(self, event):
        """Adjust the figure size dynamically to fit the plot_frame."""
        if hasattr(self, "fig") and hasattr(self, "canvas"):
            width = event.width / self.fig.dpi
            height = event.height / self.fig.dpi
            self.fig.set_size_inches(width, height)
            self.canvas.draw()

    def fit_plot_to_frame(self):
        """Ensure the plot fits the frame at startup."""
        if hasattr(self, "fig") and hasattr(self, "canvas"):
            width = self.plot_frame.winfo_width()
            height = self.plot_frame.winfo_height()
            if width > 1 and height > 1:
                width_inches = width / self.fig.dpi
                height_inches = height / self.fig.dpi
                self.fig.set_size_inches(width_inches, height_inches)
                self.canvas.draw()

if __name__ == "__main__":
    root = tk.Tk()
    app = App(root)
    root.mainloop()
