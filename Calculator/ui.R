library(shiny)

shinyUI(fluidPage(
  # In application css
  tags$style(HTML("h2{font-size:23px;margin-left:10px} h5{margin-top:-10px} div#pvalue, div#NSubj{font-size:20px;color:red;display:inline}")),
  # Application title
  titlePanel("E*Quality Calculator"),
  fluidRow(
    column(5, HTML("<form class=\"well\">"), tags$h5("Find probability"),
           numericInput("rc_p", "Pseudo-isolation criterion", .1, .01, .99, .01),
           numericInput("N_p", "The number of subjects for each condition", 40, 2, NA, NA),
           numericInput("L_p", "The number of experimental condition", 2, 64, 4, 1),
           HTML("<br>"),
           actionButton("RUN_p", "Compute"),
           HTML("<br><br>The probability of successful randomization is<br>&nbsp;&nbsp;"),
           textOutput("pvalue"),
           HTML("</form>")
    ),
    column(5, HTML("<form class=\"well\">"), tags$h5("Find sample size"),
           numericInput("rc_n", "Pseudo-isolation criterion", .1, .01, .99, .01),
           numericInput("Q_n", "Acceptable good-randomization rate", .95, .01, .99, .01),
           numericInput("L_n", "The number of experimental condition", 2, 2, NA, 1),
           HTML("<br>"),
           actionButton("RUN_n", "Compute"),
           HTML("<br><br>The required sample size for each condition is<br>&nbsp;&nbsp;"),
           textOutput("NSubj"),
           HTML("</form>")
    ),
    column(2)
  )
))
