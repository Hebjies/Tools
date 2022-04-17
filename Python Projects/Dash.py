# Import required libraries for the current project
import pandas as pd
import dash
import dash_html_components as html
import dash_core_components as dcc
from dash.dependencies import Input, Output
import plotly.express as px

# We access to the data required
spacex_df = pd.read_csv("spacex_launch_dash.csv")

# Max and Min values for Payload, needed for scatter plot
max_payload = spacex_df['Payload Mass (kg)'].max()
min_payload = spacex_df['Payload Mass (kg)'].min()

# We create a new dataframe we the values needed for pie chart
filtered = spacex_df[['Launch Site', 'class']]



# Creation of dash application
app = dash.Dash(__name__)

# Creation of app layout
app.layout = html.Div(children=[html.H1('SpaceX Launch Records Dashboard',
                                        style={'textAlign': 'center', 'color': '#503D36',
                                               'font-size': 40}) ,  # Dash Title

                                dcc.Dropdown(id='sitedropdown', # List of sites, needed to the data visualization
                                options = [
                                    {'label': 'All Sites', 'value': 'ALL'},
                                    {'label': launch_sites_df['Launch Site'].iloc[0], 'value': launch_sites_df['Launch Site'].iloc[0]},
                                    {'label': launch_sites_df['Launch Site'].iloc[1], 'value': launch_sites_df['Launch Site'].iloc[1]},
                                    {'label': launch_sites_df['Launch Site'].iloc[2], 'value': launch_sites_df['Launch Site'].iloc[2]},
                                    {'label': launch_sites_df['Launch Site'].iloc[3], 'value': launch_sites_df['Launch Site'].iloc[3]},
                                ],
                                value = 'ALL',
                                placeholder = "place holder here",
                                searchable= True
                                ),
                                html.Br(),

                                html.Div(dcc.Graph(id='success_pie_chart')), # Definition of pie chart
                                
                                html.P("Payload range (Kg):"), # Slider Title
                                
                                dcc.RangeSlider(id='payloadslider', # Slider needed to create a limit in payload mass, for scatter plot
                                min= 0 , max = 10000, step = 1000,
                                marks = {0:"0", 
                                        1000: "1000",
                                        2000: "2000",
                                        3000: "3000",
                                        4000: "4000",
                                        5000: "5000",
                                        6000: "6000",
                                        7000: "7000",
                                        8000: "8000",
                                        9000: "9000",
                                        10000: "10000",},
                                value = [min_payload, max_payload] 
                                ),

                                html.Div(dcc.Graph(id='success-payload-scatter-chart')), # Definition of scatter plot
                                ])

# Callback function with sitedropdown input and success_pie_chart output
@app.callback(Output("success_pie_chart", "figure"),
              Input("sitedropdown", "value"))

def get_pie_chart(sitedropdown): # Pie chart function

        filtered2 = filtered[filtered["Launch Site"] == sitedropdown] # Subfilter for an specific launch site

        if sitedropdown == "ALL": # Site verification
            fig = px.pie(filtered, values =  "class", # Pie chart creation
            names = "Launch Site",
            title = "Total Success Launches By Site")
            return fig
        else:
            fig = px.pie(filtered2, # Pie chart creation
            names = "class",
            title = "Total Success Launches for Site " + sitedropdown )
            return fig

# Callback function with sitedropdown, payloadslider input and success_pie_chart output
@app.callback(Output("success-payload-scatter-chart", "figure"),
              Input("sitedropdown", "value"),
              Input("payloadslider", "value"))

def get_scatter_chart(sitedropdown,payloadslider): # Scatter plot function
        low, high = payloadslider # Important values defined on slider
        rang = (spacex_df["Payload Mass (kg)"] > low) & (spacex_df["Payload Mass (kg)"] < high) # Sub filter for Payload mass
        filtered = spacex_df[spacex_df["Launch Site"] == sitedropdown] # Sub sub filter for site location

        if sitedropdown == "ALL": # Site verification
            fig = px.scatter(spacex_df[rang], x = "Payload Mass (kg)", y = "class", # Scatter plot creation
            color = "Booster Version Category",
            title = "Correlation between Payload and Success for all Sites")
            return fig
        else: 
            fig = px.scatter(filtered[rang], x = "Payload Mass (kg)", y = "class",  # Scatter plot creation
            color = "Booster Version Category",
            title = "Correlation between Payload and Success for Site " + sitedropdown)
            return fig





# Run the app
if __name__ == '__main__':
    app.run_server()
