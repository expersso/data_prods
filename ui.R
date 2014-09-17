library(shiny)

load("historical.RData")
load("recent.RData")

shinyUI(fluidPage(

  titlePanel("title"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(position = "right",
    sidebarPanel(
      h5("Description"),
      p("Explanatory text")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Recent outbreak", 
                 plotOutput("recentPlot"),
                 br(),
                 br(),
                 h6("Options"),
                 checkboxInput("points", "Add points", value = TRUE),
                 checkboxInput("smooth", "Add smooth lines"),
                 sliderInput("smoothSpan", "Span", 
                             min = 0, max = 1, value = 0.5, step = 0.1)),
        tabPanel("Earlier outbreaks", plotOutput("historicalPlot")),        
        tabPanel("Earlier outbreaks (data)", tableOutput("historicalTable")),
        tabPanel("Links",
                 tags$ul(
                 tags$li(a("Wikipedia article (source of data scrape)", 
                   href = "en.wikipedia.org/wiki/Ebola_virus_epidemic_in_West_Africa")),
                 tags$li(a("World Health Organization", 
                   href = "www.who.int/csr/disease/ebola/en/")),
                 tags$li(a("WHO Regional Office for Africa", 
                   href = "http://www.afro.who.int/en/clusters-a-programmes/dpc/epidemic-a-pandemic-alert-and-response/outbreak-news.html")),
                 tags$li(a("United States Centers for Disease Control and Prevention", 
                   href = "www.cdc.gov/vhf/ebola/outbreaks/guinea/"))
                 )
                 )
        
      )
    )
  )
))
