time_stamp = function (year_start, month_start, day_start, hour_start, year_stop, month_stop, day_stop, hour_stop) {
  if (
    ( year_start < year_stop ) |
    ( year_start == year_stop &&  month_start < month_stop) | 
    ( year_start == year_stop &&  month_start == month_stop && day_start < day_stop) | # nolint
    ( year_start == year_stop &&  month_start == month_stop && day_start == day_stop && hour_start < hour_stop ) # nolint
  ){
    # space is neggatif
    # TODO - print the error to user
  } else {
  
#   mutate(datetime = ISOdatetime(year, month, day, hour, 0, 0)) %>%  
    
  #airbnb_listings %>%
  #  filter(year %in% year_start : yeat_stop) %>%
  #  filter(month %in% month_start : month_stop) %>%
  #  filter(day)
  #}
  
  df <- data.frame(
    year = c(2023, 2023, 2023, 2024, 2024, 2024),
    month = c(8, 9, 10, 1, 2, 3),
    day = c(15, 25, 5, 10, 20, 30),
    hour = c(12, 14, 16, 18, 20, 22)
  )
  # Filter by year range first
  year_start = 2023
  year_stop = 2024
  month_start = 8
  month_stop = 2
  df %>% 
    filter( year >= year_start & year <= year_stop ) %>%
    filter(
        (year_start == year_stop & month_start <= month & month <= month_stop) |
        # If it's the start year, filter from m_start
        (year == year_start & year != year_stop & month >= month_start) |
        # If it's the start year, filter from m_start
        (year != year_start & year == year_stop & month <= month_stop) |
        # For years in between, include all months
        (year > year_start & year < year_stop)
    ) %>%
    filter(
        (month_start == month_stop & day_start <= day & day <= day_stop) |
        # If it's the start month, filter from m_start
        (month == month_start & month != month_stop & day >= day_start) |
        # If it's the start month, filter from m_start
        (month != month_start & month == month_stop & day <= day_stop) |
        # For years in between, include all months
        (month > month_start & month < month_stop)
    ) %>%
    filter(
        (day_start == day_stop & hours_start <= hours & hours <= hours_stop) |
        # If it's the start day, filter from m_start
        (day == day_start & day != day_stop & hours >= hours_start) |
        # If it's the start day, filter from m_start
        (day != day_start & day == day_stop & hours <= hours_stop) |
        # For years in between, include all hourss
        (day > day_start & day < day_stop)
    )
  }
    
    
   
  
}