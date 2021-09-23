
prob_plot <-
  function(main_dt_path = "CBME_predicted_readiness/data/20210921_shiny_data.csv",
           select_proc,
           select_pgy,
           select_month,
           n_eval_pr_value) {
    main_dt <- data.table::fread(main_dt_path)

    proc_pgy_month_dt = main_dt %>%
      filter(
        procName == select_proc,
        traineePGY == select_pgy,
        month == select_month
      )
    # priorPR == 74)
    
    ggplot(data = proc_pgy_month_dt,
           aes(x = priorPR,
               y = Estimate)) +
      geom_line(show.legend = F) +
      geom_ribbon(aes(
        ymin = Q10,
        ymax = Q90,
        fill = traineePGY
      ), alpha = 0.1, show.legend = F) +
      geom_point(
        aes(
          x = n_eval_pr_value,
          y = proc_pgy_month_dt %>% filter(priorPR == n_eval_pr_value) %>% pull(Estimate)
        ),
        size = 5,
        color = "red"
      ) +
      scale_y_continuous(labels = scales::percent_format(accuracy = 1), limits = c(0,1)) +
      scale_x_continuous(breaks = seq(0, 75, 5)) +
      labs(y = "Probabilty", x = "Practice Ready Evaluations") +
      theme_classic()
  }

# debug inputs
# prob_plot(select_proc = unique(main_dt$procName)[1],select_pgy = 3,select_month = "July", n_eval_pr_value = 75)
