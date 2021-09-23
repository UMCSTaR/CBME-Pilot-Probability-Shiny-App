library(shiny)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # import plot
    source("ggplot_scrap.R")
    
    #Import Data
    main_dt <- data.table::fread("data/20210921_shiny_data.csv", nrows = 1000)

    output$probablity_plot <- renderPlot({
        
        prob_plot(main_dt_path = "data/20210921_shiny_data.csv",
                  select_proc = {input$select_proc},
                  select_month = {input$select_month},
                  select_pgy = {input$select_PGY},
                  n_eval_pr_value = {input$n_eval_pr})
        
    })
    
    # for QA input
    # output$pgy_value <- renderPrint({ input$select_PGY })
    # output$proc_value <- renderPrint({ input$select_proc })
    # output$month_value <- renderPrint({ input$select_month })
    # output$n_eval_pr_value <- renderPrint({ input$n_eval_pr })

})
