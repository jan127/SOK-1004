rm(list=ls()) 
library(tidyverse)
library(httr)

url_ss <- "https://data.ssb.no/api/v0/no/table/10260/"



#query
query_ss <- ' {
  "query": [
    {
      "code": "NACE",
      "selection": {
        "filter": "item",
        "values": [
          "HNRTOT"
        ]
      }
    },
    {
      "code": "Tid",
      "selection": {
        "filter": "item",
        "values": [
          "1918",
          "1919",
          "1920",
          "1921",
          "1922",
          "1923",
          "1924",
          "1925",
          "1926",
          "1927",
          "1928",
          "1929",
          "1930"
        ]
      }
    }
  ],
  "response": {
    "format": "json-stat2"
  }
} '


#hente ønsker data utifra spørring
hent_indeks_ss.tmp <- url_ss %>%
  POST(body = query_ss, encode = "json")


#HERFRA MÅ LEGGES INN!!

#lager dataframe
sysselsatte <-  hent_indeks_ss.tmp %>%
  content("text") %>%
  fromJSONstat() %>%
  as_tibble()

sysselsatte <- sysselsatte %>% #lager årlig prosentvis endring 
  mutate(årlig_endring_prosent = 100*((value-lag(value, n=1L))/lag(value, n=1L)))

sysselsatte <- sysselsatte %>% # ny variabel når årlig endring er over null (til bruk i plot)
  mutate(årlig_endring_prosent_pos = årlig_endring_prosent >= 0)

sysselsatte %>% #plot
  filter(år >= 1919) %>% #fjerner 1918
  ggplot(aes(x=factor(år) ,y=as.numeric(årlig_endring_prosent), fill=årlig_endring_prosent_pos)) + #aes
  geom_bar(stat = "identity") + #hist
  labs(title = "Figur x: Prosentvis årlig endring i antall sysselsatte",
       subtitle = "Prosentvis årlig endring i antall sysselsatte i alle næringer",
       y = "Årlig endring (prosent)",
       x = "År",
       caption = "Kilde: Statistisk sentralbyrå, 2013") + #tittler på figur, akse, osv)
  theme_bw() + #tema 
  theme(legend.position="none") #fjerner legende
  
