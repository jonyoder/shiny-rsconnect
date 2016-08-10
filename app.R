library(knitr)
library(rsconnect)
library(shiny)
library(shinyAce)
library(rmarkdown)

# Default text for editor
defaultMarkdown <- '
---
title: "Sample R Markdown Doc"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r cars}
summary(cars)
```

## Including Plots

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
'

#' A Shiny UI for editing R Markdown
ui <- shinyUI(
  bootstrapPage(
    headerPanel("Embedded Deployment Example"),
    div(
      class="container-fluid",
      div(class="row-fluid",
          div(class="col-sm-6",
              h2("Source R-Markdown"),  
              aceEditor("rmd", mode="markdown", value=defaultMarkdown),
              textInput("appName", "Doc Name", value = "GeneratedDoc"),
              textInput("user", "Connect User", value = "admin"),
              textInput("server", "Connect Server Name", value = "mytestserver"),
              actionButton("eval", "Update Output"),
              actionButton("deploy", "Deploy Output")
          ),
          div(class="col-sm-6",
              h2("Knitted Output"),
              htmlOutput("knitDoc")
          )
      )
    )
  )
)

#' A Shiny application that generates and deploys R Markdown content
server <- shinyServer(function(input, output, session) {
  
  # Render the doc when the 'Update' button is clicked
  rmd <- eventReactive(input$eval, {
    input$rmd
  })
  
  # Deploy the doc when the 'Deploy' button is clicked
  observeEvent(input$deploy, {
    options(repos=c(CRAN="https://cran.rstudio.com"))
    tryCatch({
      rsconnect::deployDoc(doc="out.Rmd", appName=input$appName, account=input$user, server=input$server)
    },
    error=function(e) {
      message("", e)
    })
  })
  
  output$knitDoc <- renderUI({
    writeLines(rmd(), "out.Rmd")
    result <- "error"
    tryCatch({
      knit2html(input="out.Rmd", fragment.only = TRUE, quiet = TRUE)
      result <- isolate(HTML(readLines("out.html")))
    },
    error=function(e) {
      message("", e)
    })
    result
  })
  
})

# Run the application 
shinyApp(ui = ui, server = server)
