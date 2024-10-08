time_stamp = function (year_start, month_start, day_start, hour_start, year_stop, month_stop, day_stop, hour_stop) {
  if (
    ( year_start > year_stop ) |
    ( year_start == year_stop &&  month_start > month_stop) | 
    ( year_start == year_stop &&  month_start == month_stop && day_start > day_stop) | # nolint
    ( year_start == year_stop &&  month_start == month_stop && day_start == day_stop && hour_start > hour_stop ) # nolint
  ){
    
  } else {
    # print(paste(
    #   paste0(year_start,"/", month_start,"/", day_start,"-", hour_start,"h"),
    #   " up to ",
    #   paste0(year_stop ,"/", month_stop ,"/", day_stop ,"-", hour_stop,"h")
    #  ))
     
    df$date <- as.Date(paste0(df$year,"-",df$month,"-",df$day))

    return(
      df %>% 
        # wiping out everything before start date
        filter(date >= as.Date(paste0(year_start,"-",month_start,"-",day_start)) & hour >= hour_start) %>%
        # wiping off everything after stop date
        filter(date <= as.Date(paste0(year_stop,"-",month_stop,"-",day_stop)) & hour <= hour_stop)
    )
  
  } 
}

# the quivalent of __name__=="__main__"
if( sys.nframe() == 0 ){
    #   mutate(datetime = ISOdatetime(year, month, day, hour, 0, 0)) %>%  
    
    #airbnb_listings %>%
    #  filter(year %in% year_start : yeat_stop) %>%
    #  filter(month %in% month_start : month_stop) %>%
    #  filter(day)
    #}


    df <- data.frame(
        year = c(2022, 2022, 2023, 2024, 2024, 2024),
        month = c(8, 9, 10, 1, 2, 3),
        day = c(15, 25, 5, 10, 20, 30),
        hour = c(12, 14, 16, 18, 20, 22)
    )
    
    head(df)

    head(time_stamp(
        year_start  = 2022,
        month_start = 8,
        day_start   = 15,
        hour_start  = 13,

        year_stop  = 2024,
        month_stop = 2,
        day_stop   = 20,
        hour_stop  = 20
    ))
    print("date test")

}
