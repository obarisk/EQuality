library(shiny)

shinyUI(fluidPage(
  # In application css
  tags$style(HTML("h2{font-size:22px; margin-left:10px} 
                      div#Prob, div#N{font-size:20px; color:red; display:inline}
                      hr{border:0; height:1px; background:#333;
                         background-image:-webkit-linear-gradient(left, #ccc, #333, #ccc);
                         background-image:-moz-linear-gradient(left, #ccc, #333, #ccc);
                         background-image:-ms-linear-gradient(left, #ccc, #333, #ccc);
                         background-image:-o-linear-gradient(left, #ccc, #333, #ccc);}")),
  # Application title
  titlePanel("Relation between number of subjects and probability of successful randomization"),
  # Sidebar with a slider input for number of bins
  fluidRow(
    sidebarPanel(
      sliderInput("rc_N", "Pseudo-isolation criterion", .01, .50, .1, .01),
      uiOutput("sliderInputN"),
      numericInput("L_N", "The number of experimental condition", 2, 2, NA, 1),
      HTML("<br>The probability of success randomization now is "),
      textOutput("Prob")
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("PvsNPlot_N"),
      HTML("The border between blue and red line denotes the probability of successful randomization for a given sample size.")
    )
  ),tags$hr(),
  fluidRow(
    sidebarPanel(
      sliderInput("rc_P", "Pseudo-isolation criterion", .01, .50, .1, .01),
      uiOutput("sliderInputP"),
      numericInput("L_P", "The number of experimental condition", 2, 2, NA, 1),
      HTML("<br>The required sample size in each condition is "),
      textOutput("N")
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("PvsNPlot_P"),
      HTML("The border between blue and red line denotes the required sample size for a given acceptable good-randomization rate (q).")
    )
  )
))
