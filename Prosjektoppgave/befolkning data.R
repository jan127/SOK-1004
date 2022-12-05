url_bf <- "https://data.ssb.no/api/v0/no/table/05810/"

query_bf <- ' {
  "query": [
    {
      "code": "Kjonn",
      "selection": {
        "filter": "item",
        "values": [
          "0"
        ]
      }
    },
    {
      "code": "Alder",
      "selection": {
        "filter": "item",
        "values": [
          "999B"
        ]
      }
    },
    {
      "code": "Tid",
      "selection": {
        "filter": "item",
        "values": [
          "1915",
          "1920",
          "1925",
          "1930"
        ]
      }
    }
  ],
  "response": {
    "format": "json-stat2"
  }
}'


#Lager dataframe
hent_indeks_bf.tmp <- url_bf %>%
  POST(body = query_bf, encode = "json")

#HERFRA MÅ LEGGES INN!!!

befolkning <-  hent_indeks_bf.tmp %>%
  content("text") %>%
  fromJSONstat() %>%
  as_tibble()

#Plotter grafen
befolkning %>%
  ggplot(aes(x = as.integer(år), y = value)) +
  geom_line(aes(group = 1)) +
  scale_x_continuous(limits = c(1915, 1930)) +
  labs(title = "Figur x: Befolkning i Norge 1915-1930",
       subtitle = "Befolkning i Norge i perioden 1915 til 1930",
       y = "Befolkning",
       x = "År",
       caption = "Kilde: Statistisk sentralbyrå, 2022") +
  theme_bw()
