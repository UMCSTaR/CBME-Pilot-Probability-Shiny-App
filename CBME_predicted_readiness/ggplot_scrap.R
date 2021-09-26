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

deep_red = "#aa0000"
dark_teal = "#45646F"
dark_gray = "#aaaaaa"
black = "#000000"
lighter_gray =  "#eeeeee"
outline_gray = "#f1f1f1"


prob_plot <-
  function(main_dt_path = "CBME_predicted_readiness/data/20210921_shiny_data.csv",
           select_proc,
           select_pgy,
           select_month,
           n_eval_pr_value,
           ci = TRUE) {
    main_dt <- data.table::fread(main_dt_path)

    proc_pgy_month_dt = main_dt %>%
      filter(
        procName == select_proc,
        traineePGY == select_pgy,
        month == select_month
      )
    # priorPR == 74)
    
    if (ci){
      p = ggplot(data = proc_pgy_month_dt,
                 aes(x = priorPR,
                     y = Estimate)) +
        geom_ribbon(aes(
          ymin = Q10,
          ymax = Q90,
          fill = traineePGY
        ), fill = lighter_gray,
        show.legend = F) +
        geom_line(color = black, show.legend = F, size = 1) 
    } else {
      p = ggplot(data = proc_pgy_month_dt,
                 aes(x = priorPR,
                     y = Estimate)) +
        geom_line(color = black, show.legend = F, size = 1) 
    }
    
    p +
      geom_point(
        aes(
          x = n_eval_pr_value,
          y = proc_pgy_month_dt %>% filter(priorPR == n_eval_pr_value) %>% pull(Estimate)
        ),
        size = 10,
        color = deep_red
      ) +
      scale_y_continuous(labels = scales::percent_format(accuracy = 1), limits = c(0,1)) +
      scale_x_continuous(breaks = c(0, n_eval_pr_value, 75)) +
      labs(y = "Probabilty", x = "Practice Ready Evaluations") +
      theme_classic() +
      theme(plot.title = element_text(size=20),
            axis.text = element_text(size = 20),
            # axis.text.x = element_blank(),
            # axis.ticks.x = element_blank(),
            axis.title = element_text(size = 25),
            # axis.ticks.y=element_blank(),
            legend.position="bottom",
            legend.title = element_blank())
  }

# debug inputs
# prob_plot(select_proc = unique(main_dt$procName)[1],select_pgy = 3,select_month = "July", n_eval_pr_value = 75)
