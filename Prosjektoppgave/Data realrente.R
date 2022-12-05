rm(list=ls()) 
library(tidyverse)
library(ggthemes)
library(openxlsx)
library(ggpubr)
library(janitor)

#lenke til data norges bank (real rente data)
url_rr <- "https://www.norges-bank.no/globalassets/upload/hms/data/shortterm_ir.xlsx"



#HER FRA MÅ LEGGES INN
df_rr <- url_rr %>%   #laster inn data
  read.xlsx(sheet=12) %>% 
  as_tibble()

df_rr <- df_rr[-c(1:12),] #fjerner 12 første rader med tekst.
df_rr <- df_rr %>%
  row_to_names(row_number = 1) #janitor pakke: setter første rad som kolonnenavn

df_rr <- df_rr %>% mutate_all(na_if,"") #setter tomme kollonner som n/a.

colnames(df_rr)[1] = "year" #endrer kolonnenavn
colnames(df_rr)[2] = "real_marginal_rate" #endrer kolonnenavn
colnames(df_rr)[6] = "inflation_rate" #endrer kolonnenavn

df_rr <- df_rr %>% # ny variabel når inflation er over null (til bruk i plot)
  mutate(pos_inflation = inflation_rate >= 0)


df_rr %>% #plot
  filter(year >= 1919 & year <= 1930) %>% #fjerner før 1919 og etter 1930
  ggplot(aes(x=year ,y=as.numeric(real_marginal_rate))) + #aes
  geom_line(group = 1) + #lineplot
  geom_point(group = 1, color="blue") +
  labs(title = "Figur x: Realrente i Norge 1919 - 1930",
       subtitle = "Realrente i prosent (nominell rente - inflasjon)",
       y = "Realrente (%)",
       x = "År",
       caption = "Kilde: Eitrheim, 2007") + #tittler på figur, akse, osv) 
  geom_hline(yintercept = 0, linetype = "dashed", color = "#87ab69") + #hline
  theme_bw() #tema

df_rr %>%
  filter(year >= 1919 & year <= 1930) %>% #fjerner før 1919 og etter 1930
  ggplot(aes(x=factor(year) ,y=as.numeric(inflation_rate), fill=pos_inflation)) + #aes
  geom_bar(stat = "identity") + #hist
  labs(title = "Figur 6: Inflasjon i Norge 1919 - 1930",
       subtitle = "Inflasjon i prosent",
       y = "Inflasjon (%)",
       x = "År",
       caption = "Kilde: Eitrheim, 2007") + #tittler på figur, akse, osv) 
  theme_bw() + #tema
  theme(legend.position="none") #fjerner legende

