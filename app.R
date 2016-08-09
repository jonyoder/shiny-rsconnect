library(knitr)
library(rsconnect)
library(shiny)
library(shinyAce)

# Default text for editor
defaultMarkdown <- '
### Sample R Markdown
```{r}
hist(rnorm(100))
```
'

#' A Shiny UI for editing R Markdown
#' @author Jeff Allen \email{jeff@@trestletech.com}
ui <- shinyUI(
  bootstrapPage(
    headerPanel("Embedded Deployment Example"),
    div(
      class="container-fluid",
      div(class="row-fluid",
        div(class="col-sm-6",
          h2("Source R-Markdown"),  
          aceEditor("rmd", mode="markdown", value=defaultMarkdown),
          actionButton("eval", "Update")
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
#' @author Jeff Allen \email{jeff@@trestletech.com}
server <- shinyServer(function(input, output, session) {
  
  # Only update and deploy when the 'Update' button is clicked
  rmd <- eventReactive(input$eval, {
    input$rmd
  })
  
  output$knitDoc <- renderUI({
    writeLines(rmd(), "out.Rmd")
    knit2html(input="out.Rmd", fragment.only = TRUE, quiet = TRUE)
    options(repos=c(CRAN="https://cran.rstudio.com"))
    rsconnect::deployDoc(doc="out.Rmd", appName="GeneratedDoc", account="admin", server="mytestserver")
    return(isolate(HTML(
      readLines("out.html")
    )))
  })  
})

# Run the application 
shinyApp(ui = ui, server = server)
