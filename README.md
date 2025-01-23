# biodiversity_appsilon

#### Author: Javaria

This app is designed to visualize the biodiversity specifically in Poland. The app allows users to explore various species by clicking on markers representing their occurrence points. It displays scientific and vernacular names of species along with additional information available from a URL based on the species' occurrence ID.

## Introduction

This app is divided into two parts first is the preprocessing of data and then The goal of this project is to create a Shiny dashboard that allows users to visualize species observations on a map. The app will enable users to search for species by either their scientific name or common name, and then display their occurrence on an interactive map and timeline. On the backend, the app should be built using Shiny modules for better structure and maintainability. It will also be tested for various use cases to ensure functionality. The app will be deployed to https://www.shinyapps.io/ for public access, and the entire solution will be shared on GitHub for collaboration and further development.

##Technologies Used
R: Programming language used for data processing and Shiny app development.
Shiny: R package for building interactive web applications.
Leaflet: R package used to create interactive maps.
CSS: Used to style the app's layout and enhance its user interface.
HTML: Used for the structure of the app's layout.

## Main Task
The dataset shared at https://drive.google.com/file/d/1l1ymMg-K_xLriFv1b8MgddH851d6n2sU/view could not load in the local system. The dataset hosted at https://www.gbif.org/occurrence/search?dataset_key=8a863029-f435-446a-821e-275f4f641165 after applying the country filter is quite sizeable. This dataset set contains almost 85000 number of instances. After getting the dataset the main aim is to preprocess data 

## UI Design:
Theme: The app uses the Cerulean theme from the shiny themes package for a clean, professional, and mobile-responsive layout.
##### Layout:
Sidebar: Contains the app's logo, title, and a search bar for selecting species. The sidebar is styled with a background image and color adjustments to make it visually appealing.
##### Main Panel: The main content is divided into two sections:
Information Cards: Displays key statistics such as the total number of species and observations.
##### Tabs: Includes:
Map Tab: Displays the species' observations on an interactive map usinga  leaflet.
Timeline Tab: Shows the frequency of observations over time as a histogram using ggplot2.
Responsive Layout: The app’s interface is responsive and adapts to different screen sizes, making it mobile-friendly.
### Custom Styling:
#### Sidebar:
A custom background image with a clean color palette.
The logo and app title are placed at the top, with the logo adjusted for alignment.
#### Cards:
The cards displaying species and observation counts are styled with different shades of blue, with rounded corners and shadows to create a neat, visually appealing appearance.
Map: The map's height is set to cover the full screen, ensuring a good view of the species' observations.
Font and Colors: The font is set to Open Sans, a clean, easy-to-read typeface, and the color scheme uses shades of blue to keep the app's design cohesive.
### Server Logic:
Reactive Filters: The app uses reactive expressions to filter the data based on the species selected in the search bar. This ensures the map and timeline update dynamically based on the user's input.
Species Information: Displays detailed information about the selected species, such as its scientific and vernacular name, family, and kingdom, as well as the number of observations.
Map Rendering: The map updates based on the species selected and shows the observations as markers. When clicked, each marker displays the species' scientific name, vernacular name, and a link to more information.
Timeline Rendering: The timeline updates based on the species selected, showing a histogram of the observation count over time.
Total Observations: The app calculates and displays the total number of species and observations in the dataset.
#### Features:
Search for Species: The user can search for a species by typing its vernacular or scientific name in the search box.
Map with Markers: The map visualizes the species' observations, with each marker linked to additional information about that observation.
Timeline: The app shows how often the species has been observed over time through a dynamic histogram.
Responsive Layout: The app's layout adjusts based on the user's device, making it mobile-friendly.
How it Works:
User searches for a species: The search box accepts both scientific and vernacular names. Upon selection, the map and timeline are updated with the relevant data.
Map: The map shows the locations of the species' observations, with each marker providing more details about that observation, including a link to further information.
Timeline: The app generates a histogram showing the number of observations per date for the selected species, helping users see the frequency of observations over time.
Server Logic:
The server logic integrates various features, including:

Data Filtering: Based on the species the user selects, the app filters the dataset and displays relevant results on the map and timeline.
Dynamic Updates: The app dynamically updates the map and timeline based on the user’s input. Using reactive expressions and observers ensures that the app responds to user interactions efficiently.

![image](https://github.com/user-attachments/assets/7f5051d2-d5ab-444b-b6cd-d1982fe4118b)
![image](https://github.com/user-attachments/assets/a9f9cfbd-cfac-4941-a5b6-25c672a8949a)


## Refrences
GBIF.org (22 January 2025) GBIF Occurrence Download https://doi.org/10.15468/dl.edcq3s
