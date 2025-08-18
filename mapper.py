import pandas as pd
import folium
from folium.plugins import HeatMap

# Read CSV without headers
df = pd.read_csv("combined.csv", header=None)

# Assign proper column names
df.columns = ['Latitude', 'Longitude', 'Other']

# Convert strings to floats (in case there are extra spaces)
df['Latitude'] = df['Latitude'].astype(str).str.strip().astype(float)
df['Longitude'] = df['Longitude'].astype(str).str.strip().astype(float)

# Create dark map (Carto Dark Matter)
m = folium.Map(
    location=[df['Latitude'].mean(), df['Longitude'].mean()],
    zoom_start=8,
#    tiles="CartoDB dark_matter"
    tiles="CartoDB positron"
)

# Add heatmap
HeatMap(
    df[['Latitude', 'Longitude']].values,
    radius=6,
    blur=7,
    max_zoom=22,
).add_to(m)

m.save("heatmap.html")

