library(shiny)
library(ggplot2)
library(plotly)
library(lattice)
library(caret)
library(elasticnet)
library(randomForest)

shinyServer(function(input,output) {
    model <- reactive({
                md <- switch(input$mod,
                                lin = "lm",
                                tree = "rpart",
                                lasso = "lasso",
                                forest = "rf",
                                "lm")
                set.seed("147963")
                train(sr~., data = LifeCycleSavings, method = md)
            })
    
    modelpred <- reactive({
                    dpiInput <- input$sliderdpi
                    ddpiInput <- input$sliderddpi
                    pop15Input <- input$sliderpop15
                    pop75Input <- input$sliderpop75
        
                    predict(model(),
                            newdata = data.frame(dpi=dpiInput,
                                                    ddpi=ddpiInput,
                                                    pop15=pop15Input,
                                                    pop75=pop75Input))
                })
    
    output$pred <- renderText({
        modelpred()
    })
    
    lfc <- reactive({LifeCycleSavings})
    
    output$plot <- renderPlotly({
                        country <- rownames(LifeCycleSavings)
                        lfc <- cbind(lfc,country)
                        plot_ly(lfc(),
                                x = ~pop15,
                                y = ~pop75,
                                type = "scatter",
                                color = ~sr,
                                text = ~paste(country, "<br>dpi: ", dpi, "<br>sr: ", sr),
                                size = ~dpi
        )
    })
})