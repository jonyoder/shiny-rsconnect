library(shiny)
library(shinyAce)
library(knitr)
library(rsconnect)

#' Define UI for application that demonstrates a simple Ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
ui <- shinyUI(
  bootstrapPage(
    headerPanel("Shiny Ace knitr Example"),
    div(
      class="container-fluid",
      div(class="row-fluid",
        div(class="col-sm-6",
          h2("Source R-Markdown"),  
          aceEditor("rmd", mode="markdown", value='### Sample knitr Doc
This is some markdown text. It may also have embedded R code
which will be executed.
```{r}
2*3
rnorm(5)
```
It can even include graphical elements.
```{r}
hist(rnorm(100))
```
'),
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

#' Define server logic required to generate simple ace editor
#' @author Jeff Allen \email{jeff@@trestletech.com}
server <- shinyServer(function(input, output, session) {
  
  rmd <- eventReactive(input$eval, {
    input$rmd
  })
  
  output$knitDoc <- renderUI({
    writeLines(rmd(), "out.Rmd")
    knit2html(input="out.Rmd", fragment.only = TRUE, quiet = TRUE)
    options(repos=c(CRAN="https://cran.rstudio.com"))
    rsconnect::deployDoc(doc="out.Rmd", appName="JonsDoc", account="admin", server="mytestserver")
    return(isolate(HTML(
      readLines("out.html")
    )))
  })  
})

# Run the application 
shinyApp(ui = ui, server = server)
