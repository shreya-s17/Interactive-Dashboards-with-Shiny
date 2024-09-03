#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(ggplot2)

dashHeader <- dashboardHeader(title = 'Simple Dashboard')

dashSidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Home',
             tabName = 'HomeTab',
             icon = icon('dashboard')),
    menuItem('DiamondsGraphTab',
             tabName = 'DiamondsGraphTab',
             icon = icon('bar-chart-o')),
    menuItem('GeyserGraphTab',
             tabName = 'GeyserGraphTab',
             icon = icon('bar-chart-o'))
  )
)

dashBody <- dashboardBody(
  tabItems(
    tabItem(tabName = 'HomeTab',
            h1('Landing Page!'),
            p('This is the landing page for the dashboard.'),
            em('This is text emphasized')),
    tabItem(tabName = 'DiamondsGraphTab',
            h1('Graphs!'),
            selectInput(inputId = 'VarToPlot',
                        label = 'Choose a Variable',
                        choices = c('carat','depth','table','price'),
                        selected = 'price'),
            plotOutput(outputId = 'HistPlot')),
    tabItem(tabName = 'GeyserGraphTab',
            h1('Graphs!'),
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            plotOutput(outputId = 'distPlot'))
  )
)

ui <- dashboardPage(
  header=dashHeader,
  sidebar=dashSidebar,
  body=dashBody,
  title='Example Dashboard'
)




data(diamonds, package = 'ggplot2')
# Define server logic required to draw a histogram
server <- function(input, output, session) { 
  
  output$HistPlot <- renderPlot({
    ggplot(diamonds, aes_string(x=input$VarToPlot)) +
      geom_histogram(bins=30)
  })

  output$distPlot <- renderPlot({
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application
shinyApp(ui = ui, server = server)
