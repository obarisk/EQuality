library(shiny)

shinyUI(fluidPage(
  # In application css
  tags$style(HTML("h2{font-size:23px;margin-left:10px} div#pvalue{font-size:20px;color:red;display:inline}")),
  # Application title
  titlePanel("Simulating correlations between independent variable and nuisance variable"),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("rc", "Pseudo-isolation criterion", .01, .99, 0.1, .01),
      sliderInput("N", "Given sample size for each condition", 2, 250, 20, 1),
      numericInput("L", "The number of experimental condition", 2, 2, NA, step=1),
      radioButtons("R", "Number of replications", list("100"=1, "500"=2, "1000"=3), selected=1),
      actionButton("RUN", "Run simulation")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      #HTML("The probability of successful randomization is  "),
      #textOutput("pvalue"),
      plotOutput("distPlot"),
      HTML("Given pseudo-isolation criterion (r<sub>c</sub>), sample size, and number of experimental conditions, either 100, 500, or 1000 samples with given sample size were simulated to calculate probabilities of successful randomization. The independent variable X was sampled from discrete uniform distribution, and the nuisance variable ε was then independently sampled from standard normal distribution. Multiple correlations r<sup>2</sup> between X and ε in each sample were calculated and then r<sub>xε</sub> is calculated by taking square root of multiple correlation. The counts of these correlations (r<sub>xε</sub>) in different ranges were shown in the histogram. The probability of successful randomization is equal to “(counts of r<sub>xε</sub>&lt;r<sub>c</sub>)/(counts of total r<sub>xε</sub>)”.")
    )
  )
))
