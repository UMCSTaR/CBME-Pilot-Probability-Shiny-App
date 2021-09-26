# simple color scheme
#   $color-white: #fff;
#   $color-black: #000;
#   $color-light-gray: #ddd;
#   $color-lighter-gray: #eee;
#   $color-dark-gray: #aaaaaa;
#   $color-deep-red: #A00;
#   $color-teal: #45ada6;
#   $color-dark-teal: #45646F;
#   $color-dark-blue: #454658;
#   $color-light-purple: #d1d1da;
#   $color-outline-gray: #f1f1f1;
#   $color-success: $color-teal;
#   $color-info: #9cf;
#   $color-warning: #fd6;
#   $color-error: #f66;
#   $color-error-dark: $color-deep-red;

library(highcharter)

deep_red = "#aa0000"
dark_teal = "#45646F"
dark_gray = "#aaaaaa"
black = "#000000"
lighter_gray =  "#eeeeee"
outline_gray = "#f1f1f1"
dark_blue =  "#454658"
simpl_blue = "#6abbcc"


hc_prob_plot <-
  function(main_dt_path = "CBME_predicted_readiness/data/20210921_shiny_data.csv",
           select_proc,
           select_pgy,
           select_month) {
    main_dt <- data.table::fread(main_dt_path)
    
    proc_pgy_month_dt = main_dt %>%
      filter(procName == select_proc,
             traineePGY == select_pgy,
             month == select_month) %>% 
      mutate(Estimate_perc = Estimate*100,
             Q10_perc = Q10*100,
             Q90_perc = Q90*100)
    
    hchart(proc_pgy_month_dt, "line",
               hcaes(x = priorPR,
                     y = Estimate_perc),
           color = dark_blue,
           name = "Estimate",
           marker = FALSE
    ) %>% 
    hc_add_series(
      proc_pgy_month_dt,
      type = "arearange",
      name = "90% CI (click me to hide CI)",
      hcaes(x = priorPR, low = Q10_perc, high = Q90_perc),
      linkedTo = "Estimate", # here we link the legends in one.
      showInLegend = TRUE,
      # color = hex_to_rgba("red", 0.1),  # put a semi transparent color,
      color = hex_to_rgba("gray70"),
      marker = FALSE,
      zIndex = -3 # this is for put the series in a back so the points are showed first
    ) %>% 
      hc_yAxis(max = 100,
               min = 0,
               title = list(text = "Probability",
                            style = list(
                              fontWeight = "bold",   # Bold
                              fontSize = '2.0em'   # 1.4 x tthe size of the default text
                            )),
               labels = list(format = "{value}%",
                             style = list(
                               fontSize = '1.4em'   # 1.4 x tthe size of the default text
                             )))  %>%
      hc_xAxis(max = 75,
               tickInterval = 5,
                title = list(text = "Practice Ready Evaluations",
                             style = list(
                               fontWeight = "bold",   # Bold
                               fontSize = '2.0em'   # 1.4 x tthe size of the default text
                             )),
               labels = list(style = list(
                               fontSize = '1.4em'   # 1.4 x tthe size of the default text
                             ))) %>%
      hc_tooltip(
        backgroundColor = simpl_blue,
        # shared = TRUE,
        borderWidth = 0,
        useHTML = TRUE,                              # The output should be understood to be html markup
        formatter = JS(
          "
      function(){
        outHTML = '<b> N Evaluation: ' + this.x + '</b> <br> Practice ready probability: ' + Math.round(this.y) + '%' +
      '</b> <br> 90% CI: ' + Math.round(this.point.Q10_perc) + '-' + Math.round(this.point.Q90_perc)+'%'
        return(outHTML)
      }

      "
        ) 
      ) 
  }

# # debug inputs
# hc_prob_plot(
#   select_proc = unique(main_dt$procName)[1],
#   select_pgy = 3,
#   select_month = "July"
# )
