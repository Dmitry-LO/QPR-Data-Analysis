# Create the figure and first Y-axis
fig, ax1 = plt.subplots(dpi=100)

# Plot histogram on the first Y-axis
ax1.bar(self.HistoX, self.HistoY, width=step, align='center', alpha=0.7, label="Histogram")
ax1.set_xlabel("Peak Field [mT]")
ax1.set_ylabel("Point Number", color="blue")
ax1.tick_params(axis="y", labelcolor="blue")
ax1.grid(True)

# Create the second Y-axis and Plot Surface Resistance
ax2 = ax1.twinx()
ax2.scatter(Dataset[x], Dataset[y], color="red", label="Scatter Plot", s=2)
ax2.set_ylabel("Surface Resistance [nOhm]", color="red")
ax2.tick_params(axis="y", labelcolor="red")

# Add legends
ax1.legend(loc="upper left")
ax2.legend(loc="upper right")

# Set title
plt.title("Histogram with Scatter Overlay")
plt.show()
