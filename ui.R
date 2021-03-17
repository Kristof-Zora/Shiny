library(shiny)
library(plotly)

shinyUI(fluidPage(
    titlePanel("Prediction of Savings Ratio"),
    sidebarLayout(
        sidebarPanel(
            submitButton("Submit"),
            sliderInput("sliderdpi", "Real per-capita disposable income (dpi):", 50, 5000, value = 1000),
            sliderInput("sliderddpi", "% Growth rate of dpi (ddpi):", 0, 20, value = 3.75, step = 0.01),
            sliderInput("sliderpop15", "The percentage of population less than 15 years old:", 0, 50, value = 25),
            sliderInput("sliderpop75", "The percentage of the population over 75 years old:", 0, 5, value = 2.5, step = 0.01),
            radioButtons("mod", "Chosen Model:",
                            c("Linear Regression" = "lin",
                               "Decision Tree" = "tree",
                               "Lasso" = "lasso",
                               "Random Forest" = "forest"
                              ),
                             selected = "lin")
        ),
        mainPanel(
            h3("Predicted Savings Ratio:"),
            textOutput("pred"),
            
            tags$div(
                h4("Intercountry Life-Cycle Savings Data"),
                h6("LifeCycleSavings {datasets}")
            ),
            
            tags$div(
                tags$p(tags$b("Description")),
                tags$p("Data on the savings ratio 1960-1970.")
                
            ),
            
            tags$div(
                tags$p(tags$b("Usage")),
                tags$p("LifeCycleSavings")
            ),
            
            tags$div(
                tags$p(tags$b("Format")),
                tags$p("A data frame with 50 observations on 5 variables.")
            ),
            
            tags$div(
                tags$p("sr (numeric):	aggregate personal savings"),
                tags$p("pop15 (numeric): % of population under 15"),
                tags$p("pop75 (numeric): % of population over 75"),
                tags$p("dpi (numeric): real per-capita disposable income"),
                tags$p("ddpi (numeric): % growth rate of dpi")
            ),
            
            tags$div(
                tags$p(tags$b("Details")),
                tags$p("Under the life-cycle savings hypothesis as developed by Franco Modigliani, the savings ratio
                                       (aggregate personal saving divided by disposable income) is explained by per-capita disposable income,
                                        the percentage rate of change in per-capita disposable income, and two demographic variables: 
                                       over 75 years old. The data are averaged over the decade 1960-1970 to remove the business cycle 
                                       or other short-term fluctuations."),
            ),
            
            tags$div(
                tags$p(tags$b("Source")),
                tags$p("The data were obtained from Belsley, Kuh and Welsch (1980). They in turn obtained the data from Sterling (1977).")
            ),
            
            h3("Original Data"),
            plotlyOutput("plot"),
            
            tags$div(
                tags$p(tags$b("Use of the Application")),
                tags$p("With the help of the sliders the values of the variables dpi, ddpi, pop15 and pop75 can be set respectively for the prediction.
                                        After that the model can be chosen. The chosen model will be built to the data and the prediction is made from this model with the adjusted variables.")
            )
        )
    )
))
