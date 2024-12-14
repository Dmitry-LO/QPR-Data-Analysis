import tkinter as tk
from tkinter import ttk
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

# Function to plot the data
def plot_data():
    x = [1, 2, 3]
    y = [1, 2, 3]

    # Create a Matplotlib figure
    fig, ax = plt.subplots()
    ax.plot(x, y, marker='o', linestyle='-', color='blue')
    ax.set_title("Simple Plot")
    ax.set_xlabel("X-axis")
    ax.set_ylabel("Y-axis")

    # Embed the Matplotlib figure into the Tkinter app
    canvas = FigureCanvasTkAgg(fig, master=left_frame)
    canvas_widget = canvas.get_tk_widget()
    canvas_widget.pack(fill=tk.BOTH, expand=True)
    canvas.draw()

# Create the main Tkinter window
root = tk.Tk()
root.title("Tkinter Plot App")
root.geometry("600x400")

# Create frames for layout
left_frame = ttk.Frame(root, width=200)
left_frame.pack(side=tk.LEFT, fill=tk.Y)
right_frame = ttk.Frame(root)
right_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

# Add a button to the left frame
plot_button = ttk.Button(left_frame, text="Plot", command=plot_data)
plot_button.pack(pady=20)

# Start the Tkinter event loop
root.mainloop()
