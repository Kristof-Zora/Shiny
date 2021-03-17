---
title       : Prediction of Savings Ratio
subtitle    : with the LifeCycleSavings dataset
author      : Kristóf Sz.
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax,bootstrap]            # {mathjax, quiz, bootstrap}
mode        : standalone # {selfcontained, standalone, draft}
knit        : slidify::knit2slides
---

## The Dataset

The **LifeCycleSavings** dataset conatins 5 variables:

1. **sr** (numeric): aggregate personal savings
2. **pop15** (numeric): % of population under 15
3. **pop75** (numeric): % of population over 75
4. **dpi** (numeric): real per-capita disposable income
5. **ddpi** (numeric): % growth rate of dpi

More details about the dataset can be seen [here](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/LifeCycleSavings.html).

--- .class #id

## Prediction

The user can chose the model, with which the model is built (*linear regression*, *decision tree*, *lasso*, or *random forest*). To the prediction, the user can set the variables **dpi**, **ddpi**, **pop15**, and **pop75**. The predicted value is the image of the chosen model under these variables.

The **Shiny** Application contains a `ui.R` and a `server.R` files.

The `ui.R` file is very similar to the one in the lecture. It contains a a `submitButton`, more `sliderInput`s, and a `radioButtons`. The `mainPanel` gives the *Predicted Savings Ratio*, the description of the dataset and the method of the prediction. In addition, it shows the origonal dataset in a *Plotly* plot (where **dpi** determines the *size* of the circles and **sr** the *color*) and explains the usage of the application. 

--- .class #id

## `server.R` Part I.

The `server.R` file creates the reactive model and the prediction. The required packages are *shiny*, *ggplot2*, *plotly*, *lattice*, *caret*, *elasticnet* and *randomForest*. The code:

```r
shinyServer(function(input,output) {
    model <- reactive({ md <- switch(input$mod, lin = "lm", tree = "rpart", lasso = "lasso",
                                        forest = "rf", "lm")
                        set.seed("147963")
                        train(sr~., data = LifeCycleSavings, method = md)  })
    modelpred <- reactive({ dpiInput <- input$sliderdpi
                            ddpiInput <- input$sliderddpi
                            pop15Input <- input$sliderpop15
                            pop75Input <- input$sliderpop75
                            predict(model(),
                                    newdata = data.frame(dpi=dpiInput, ddpi=ddpiInput,
                                                         pop15=pop15Input, pop75=pop75Input))  })
    output$pred <- renderText({modelpred()})
# ...
```

--- .class #id

## `server.R` Part II.

The code of the Plotly plot:

```r
# ...
lfc <- reactive({LifeCycleSavings})
output$plot <- renderPlotly({
                        country <- rownames(LifeCycleSavings)
                        lfc <- cbind(lfc,country)
                        plot_ly(lfc(), x = ~pop15, y = ~pop75, type = "scatter", color = ~sr,
                        text = ~paste(country, "<br>dpi: ", dpi, "<br>sr: ", sr), size = ~dpi
                                )
                            })
})

```
