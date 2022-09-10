library(tidyverse)
library(ggthemes)

co2data <- read_csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

nordic_countries <- c("Norway", "Sweden", "Denmark", "Finland", "Iceland")

co2data %>%
  filter(country %in% nordic_countries) %>% 
  filter(year >= 1975) %>%
  ggplot(aes(x=year, y=co2_per_capita, color=country)) %>%
  + geom_line(size = 1.2, alpha = 0.8) %>%
  + labs(title = "CO2 utslipp per inbygger i nordiske land",
         subtitle = "Grafen viser CO2 utslipp per innbygger i nordiske land siden 1975",
         y = "Tonn CO2 per innbygger",
         x = "Årstall",
         color = "Land") %>%
  + theme_fivethirtyeight() %>%
  + theme(axis.title = element_text()) %>%
  + scale_color_brewer(palette = "Set3")
