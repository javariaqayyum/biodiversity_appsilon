library(shiny)
library(shinythemes)
library(leaflet)
library(dplyr)
library(ggplot2)
library(DT)
library(shinyWidgets)

# read data
df1 <- read.csv("preprocessed_dataset.csv")

# UI layout
ui <- fluidPage(
  theme = shinytheme("cerulean"),
  tags$head(
    tags$style(HTML("
      body {font-family: 'Open Sans', sans-serif;}
        .sidebar {
        background-color: #f8f9fa;
        padding: 15px;
        background-image: url('appsilonimage.png');  /* Correct path to background image */
        background-size: cover;  /* Make the image cover the entire sidebar */
        background-position: center;  /* Center the image */
        background-repeat: no-repeat;  /* Prevent the image from repeating */
        height: 100vh;  /* Set the height to cover the full viewport height */
     }
      .leaflet-container {height: 100vh;} /* Full screen height for map */
      .main-title {color: #2c3e50; text-align: left;} /* Align title to the left */
      .content {margin-left: 250px;} /* Adjusting the content area to account for the sidebar */
      
       
    
      .sidebar-logo {
        width: 40px;  /* Size of the logo */
        height: auto;
        vertical-align: middle;
        margin-right: 10px;  /* Space between logo and title */
        background-size: cover;
       background-position: center;
      }
      
      

      /* Styling for the cards */
      .card {
        background-color: #d1e7fd; /* Light blue background */
        color: #0047AB; /* Dark blue text */
        border-radius: 10px;
        padding: 10px;
        margin-bottom: 25px;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        font-weight: bold;
        width: 250px;  /* Set a fixed width for the cards */
        display: inline-block;
        text-align: center; /* Center the text inside the cards */
      }
      .card-title {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 8px;
      }
      .card-value {
        font-size: 22px;
        color: #007BFF;
      }
      .card-blue {background-color: #c0d8f7;}
      .card-light-blue {background-color: #d1e7fd;}
      
      .cards-container {
         display: flex; 
        justify-content: center; /* Center cards horizontally */
        align-items: center; /* Vertically center cards */
        gap: 30px;  /* Add space between cards */
        margin-top: 30px;
        margin-bottom: 30px;
      }
    "))
  ),
  
  
  
  sidebarLayout(
    sidebarPanel(
      class = "sidebar",
      div(style = "display: flex; align-items: center;",
          img(src = "appsilonimage.png", class = "sidebar-logo"),  # Logo
          h3("Biodiversity Dashboard", class = "main-title")  # Move the title to the sidebar
      ),
      hr(),
      selectizeInput(
        "species",
        "Search for a species (vernacularName or scientificName):",
        choices = NULL,
        multiple = FALSE,
        options = list(placeholder = "Type to search...", maxOptions = 10)
      ),
      hr(),
      h4("Selected Species Information", class = "main-title"),
      
      
        verbatimTextOutput("species_info")
    
    ),
    mainPanel(
      
      div(class = "cards-container",
          div(class = "card card-light-blue", 
              div(class = "card-title", "Total Species"), 
              div(class = "card-value", textOutput("total_species"))
          ),
          div(class = "card card-blue", 
              div(class = "card-title", "Total Observations"), 
              div(class = "card-value", textOutput("total_observations"))
          )
      ),
      tabsetPanel(
        tabPanel(
          "Map",
          leafletOutput("map")
        ),
        tabPanel(
          "Timeline",
          plotOutput("timeline")
        )
      )
    )
  )
)

# Server logic
server <- function(input, output, session) {
  updateSelectizeInput(
    session,
    "species",
    choices = unique(c(df1$vernacularName, df1$scientificName)),
    server = TRUE
  )
  
  # Reactive filter for selected species
  selected_species <- reactive({
    req(input$species)  
    df1 %>%
      filter(vernacularName == input$species | scientificName == input$species)
  })
  
  # Display species information
  output$species_info <- renderText({
    species_data <- selected_species()
    req(nrow(species_data) > 0)
    paste0(
      "Scientific Name: ", unique(species_data$scientificName), "\n",
      "Vernacular Name: ", unique(species_data$vernacularName), "\n",
      "Kingdom: ", unique(species_data$kingdom), "\n",
      "Family: ", unique(species_data$family), "\n",
      "Number of Observations: ", nrow(species_data)
    )
  })
  

  
  # cards detail
  output$total_species <- renderText({
    total_species <- length(unique(c(df1$vernacularName, df1$scientificName)))
    total_species  # Display total species
  })
  
  output$total_observations <- renderText({
    total_observations <- nrow(df1)
    total_observations 
  })
  
  # Render map
  output$map <- renderLeaflet({
    if (is.null(input$species)) {
      leaflet(df1) %>%
        addTiles() %>%
        addCircleMarkers(
          clusterOptions = markerClusterOptions(),
          lng = ~decimalLongitude, lat = ~decimalLatitude,
          popup = ~paste0("Scientific Name: ", scientificName, "<br>",
                          "Vernacular Name: ", vernacularName, "<br>",
                          "<<a href='", occurrenceID, "' target='_blank'>More Information</a>"),
          radius = 5,
          color = "#3498db",
          fillOpacity = 0.7
        )
    } else {
      species_data <- selected_species()
      req(nrow(species_data) > 0)
      leaflet(species_data) %>%
        addTiles() %>%
        addCircleMarkers(
          clusterOptions = markerClusterOptions(),
          ~decimalLongitude, ~decimalLatitude,
          popup = ~paste0("Scientific Name: ", scientificName, "<br>",
                          "Vernacular Name: ", vernacularName, "<br>",
                          "<a href='", occurrenceID, "' target='_blank'>More Information</a>"),
          radius = 5,
          color = "#0047AB",
          fillOpacity = 0.7
        )
    }
  })
  
  # Render timeline plot
  output$timeline <- renderPlot({
    if (is.null(input$species)) {
      ggplot(df1, aes(x = as.Date(date))) +
        geom_histogram(binwidth = 30, fill = "#3498db", color = "black") +
        labs(
          title = "Observations Timeline",
          x = "Date",
          y = "Count"
        ) +
        theme_minimal()
    } else {
      species_data <- selected_species()
      req(nrow(species_data) > 0)
      ggplot(species_data, aes(x = as.Date(date))) +
        geom_histogram(binwidth = 30, fill = "#4682B4", color = "black") +
        labs(
          title = paste("Observations Timeline for", input$species),
          x = "Date",
          y = "Count"
        ) +
        theme_minimal()
    }
  })
}

# Run the app
shinyApp(ui, server)
