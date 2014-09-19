library(shiny)

load("historical.RData")
load("recent.RData")
few_pal()(1)
shinyUI(fluidPage(
  
  tags$head(
    tags$style(HTML("
 
      h1 {color: #7AC36A }
      a {color: #F15A60 }

    "))),

  titlePanel(h1("West African 2014 Ebola Outbreak")),

  # Sidebar with a slider input for number of bins
  sidebarLayout(position = "right",
    sidebarPanel(
      h5("Description"),
      p("The currently on-going outbreak of Ebola in West Africa began in Guinea in December 2013. Since then,
        it has spread to neighboring countries Liberia, Sierra Leone, Nigeria, and Senegal. ]\
        It is by now the largest outbreak of Ebola since its discovery in 1976. As of 10 September 2014, 
        there have been more than 5,200 suspected cases and more than 2,600 deaths."),
      p("Acquiring data on the outbreak is not trivial; the WHO does not offer downloads of e.g. CSV files.
        For this reason, data was scraped off the Wikipedia site on the outbreak. This procedure is 
        fully reproducible and would allow an app such as this to serve as a source of up-to-date 
        information on the spread of the virus.")
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
                 checkboxInput("logYscale", "Logged Y axis"),
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
