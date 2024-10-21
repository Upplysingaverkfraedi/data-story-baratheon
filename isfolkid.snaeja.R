library(shiny)
library(DBI)
library(RSQLite)
library(ggplot2)
library(visNetwork)

# Define UI
ui <- fluidPage(
  titlePanel("Structured Family Tree Visualization"),
  visNetworkOutput("familyNetwork"),
  plotOutput("statusPieChart"),  # Output for the pie chart
  plotOutput("chosenPieChart"),  # Output for the chosen vs not chosen pie chart
  HTML("<strong>Color Guide:</strong>"),
  HTML("Green = Good, Yellow = Converted, Red = Evil, Gray = Not Chosen")
)

# Define server logic
server <- function(input, output, session) {
  con <- dbConnect(RSQLite::SQLite(), "/Users/snaefridurkjartansdottir/Downloads/isfolkid.db")
  
  # Fetch family data including parent references, gender, and chosen_one status
  family_data <- dbGetQuery(con, "SELECT id, mom, dad, name, gender, chosen_one FROM family")
  dbDisconnect(con)
  
  # Nodes setup: Extract first names, assign shapes based on gender
  nodes <- data.frame(
    id = family_data$id,
    label = sapply(strsplit(family_data$name, " "), `[`, 1),
    shape = ifelse(family_data$gender == 'F', 'circle', 'box'),
    color = ifelse(family_data$chosen_one == 'good', '#2ECC40', ifelse(family_data$chosen_one == 'converted', '#FFFF00', ifelse(family_data$chosen_one == 'evil', '#FF0000', '#DDDDDD')))
  )
  
  # Edges setup: connecting parents to children
  edges <- rbind(
    data.frame(from = family_data$mom, to = family_data$id, arrows = 'to'),
    data.frame(from = family_data$dad, to = family_data$id, arrows = 'to')
  )
  edges <- na.omit(edges)
  
  # VisNetwork setup
  output$familyNetwork <- renderVisNetwork({
    visNetwork(nodes, edges, width = "100%", height = "100%") %>%
      visEdges(arrows = 'to') %>%
      visNodes(shape = nodes$shape, color = list(background = nodes$color)) %>%
      visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
      visLayout(randomSeed = 123, hierarchical = list(
        enabled = TRUE, levelSeparation = 150, nodeSpacing = 100, treeSpacing = 200, 
        blockShifting = TRUE, edgeMinimization = TRUE, parentCentralization = TRUE, 
        direction = 'UD', sortMethod = 'directed'
      ))
  })
  
  # Create the status distribution pie chart
  output$statusPieChart <- renderPlot({
    status_counts <- table(family_data$chosen_one)
    status_data <- as.data.frame(status_counts)
    status_data$Prop <- status_data$Freq / sum(status_data$Freq)
    ggplot(status_data, aes(x = "", y = Prop, fill = Var1)) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar(theta = "y") +
      theme_void() +
      scale_fill_manual(values = c("NULL" = "#DDDDDD", "good" = "#2ECC40", "converted" = "#FFFF00", "evil" = "#FF0000")) +
      labs(fill = "Status", title = "Distribution of Chosen Status") +
      geom_text(aes(label = scales::percent(Prop)), position = position_stack(vjust = 0.5))
  })
  
  # Create the overall chosen vs not chosen pie chart
  output$chosenPieChart <- renderPlot({
    # Reclassify the 'chosen_one' data into 'Chosen' and 'Not Chosen'
    chosen_data <- transform(family_data, Status = ifelse(chosen_one %in% c("good", "converted", "evil"), "Chosen", "Not Chosen"))
    status_counts <- table(chosen_data$Status)
    status_data <- as.data.frame(status_counts)
    status_data$Prop <- status_data$Freq / sum(status_data$Freq)
    
    ggplot(status_data, aes(x = "", y = Prop, fill = Var1)) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar(theta = "y") +
      theme_void() +
      scale_fill_manual(values = c("Not Chosen" = "#DDDDDD", "Chosen" = "#00FF00")) +
      labs(fill = "Status", title = "Overall Chosen Status") +
      geom_text(aes(label = scales::percent(Prop)), position = position_stack(vjust = 0.5))
  })
}

# Run the application
shinyApp(ui = ui, server = server)

























