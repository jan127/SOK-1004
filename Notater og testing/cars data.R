#Cleans up previous projects
rm(list=ls())

#Add packages
library(tidyverse)
library(ggthemes)
library(plotly)
library(extrafont)

#Import all fonts
font_import()

#Import data
data <- read_csv("https://gist.github.com/seankross/a412dfbd88b3db70b74b/raw/5f23f993cd87c283ce766e7ac6b329ee7cc2e1d1/mtcars.csv") %>%
  mutate(cyl=factor(cyl))


#Graph definition
plot1 <- data %>% ggplot(aes(x = wt, y = mpg, size = hp)) %>% 
  + geom_point(alpha = 0.5)
#plo1: Bubble plot
plot2 <- data %>% ggplot(aes(x = wt, y = mpg, size= hp, color = cyl, label = model)) %>%
 + geom_point(alpha = 0.5) %>%
  + scale_size(range = c(.1, 15)) %>%
  + labs(title = "Cars: Weight and Miles per gallon",
         subtitle = "Size of circles: Larger circle - more hp, smaller circle - less hp",
        x = "Cars Weight",
        y = "Miles per gallon",
        color = "",
        size = "Cylinders") %>%
+ theme_fivethirtyeight() %>%
+ theme(axis.title = element_text(), text = element_text(family = "Rubik")) %>%
  +scale_color_brewer(palette = "Set1")
#plot2: better bubble plot

#Convert ggplot to plotly
plot <- ggplotly(plot2, widht = 500, height = 500) %>%
  layout(xaxis = list(range = c(1, 6)), 
         yaxis = list(range = c(8, 35)))
  legend = list(x=0.825, y = .975)

