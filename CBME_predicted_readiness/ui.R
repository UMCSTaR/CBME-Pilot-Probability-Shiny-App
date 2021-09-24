library(shiny)
library(shinyWidgets)

# Define UI for application that draws a histogram
shinyUI(
    # load procedure list dt
    fluidPage(
    # Application title
    titlePanel("CBME Pilot"),
    
    slient_load = load("data/proc_name_list.rdata"),
    
    
    sidebarLayout(
        sidebarPanel(
            # Sidebar with a slider input for number of bins
            pickerInput(
                "select_PGY",
                label = h4("Trainee PGY"),
                choices = list(
                    "PGY1" = 1,
                    "PGY2" = 2,
                    "PGY3" = 3,
                    "PGY4" = 4,
                    "PGY5" = 5
                ),
                selected = 1
            ),
            # allow typing guide select
            pickerInput(
                "select_proc",
                label = h4("Procedure Name"),
                # use procedure names as dropdown
                choices = proc_name_list,
                selected = proc_name_list[1]
            ),
            
            # choose month
            
            sliderTextInput(
                inputId = "select_month",
                label =  h4("Month"),
                choices = c(
                    "July",
                    "August" ,
                    "September" ,
                    "October"  ,
                    "November" ,
                    "December",
                    "January" ,
                    "February" ,
                    "March"    ,
                    "April"   ,
                    "May" ,
                    "June"
                )
            ),
            
            
            # n eval for practice ready
            sliderInput(
                "n_eval_pr",
                h4("Number of Practice Ready Evaluations:"),
                min = 0,
                max = 75,
                value = 75
            ),
            
            # confidence interval
            materialSwitch(
                inputId = "ci_yes_no",
                label = h4("Confidence Interval"),
                value = FALSE, 
                status = "info"
            )
        ),
    
    mainPanel(
        # verbatimTextOutput("pgy_value"),
        # verbatimTextOutput("proc_value"),
        # verbatimTextOutput("month_value"),
        # verbatimTextOutput("n_eval_pr_value"),
        # Output: plot ----
        plotOutput(outputId = "probablity_plot")
    ))
))
