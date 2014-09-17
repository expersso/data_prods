#### Historical data ####
url <- "http://who.int/mediacentre/factsheets/fs103/en/"
library(XML)
library(tidyr)

df <- readHTMLTable(content(GET(url)), which = 1, 
                       colClasses = c("character", "character", "character", 
                                      "integer", "integer", "Percent"))

df <- df[complete.cases(df),] %>% tbl_df
names(df) <- tolower(names(df))
names(df) <- make.names(names(df))
df$year2 <- str_sub(df$year, end = 4) %>% as.numeric
df$year <- str_replace(df$year, fixed("\n"), "")
df$country <- revalue(df$country, c("Democratic Republic of Congo" = "DRC"))
df$case.fatality <- df$case.fatality / 100
df$label <- paste(df$year, df$country, sep = " - ")
df$survived <- df$cases - df$deaths

historical <- df
save(historical, file = "historical.RData")

#### Recent outbreak ####

url2 <- "http://en.wikipedia.org/wiki/Ebola_virus_epidemic_in_West_Africa"
df2 <- readHTMLTable(content(GET(url2)), which = 5, header = TRUE, stringsAsFactors = FALSE)
df2 <- df2[,-14]

categories <- as.character(unlist(df2[1,1:12]))
countries <- c("Total", "Guinea", "Liberia", "Sierra Leone", "Nigeria", "Senegal")
country_cat <- paste(as.vector(sapply(countries, function(x) rep(x, times = 2))), categories, sep = "_")
names(df2) <- c("date", country_cat)
df2 <- df2[-1,]
dfm <- melt(df2, id.vars = "date")
dfm$date <- dmy(dfm$date)
dfm <- tidyr::separate(dfm, "variable", into = c("country", "variable"), sep = "_")

dfm$value <- str_replace(dfm$value, "\\+\\d+", "") %>%
  str_replace("\\(.*\\)", "") %>%
  str_replace("\\n.*", "") %>%
  str_replace(",", "") %>%
  as.numeric

recent <- dfm
save(recent, file = "recent.RData")

# ggplot(filter(dfm, country != "Senegal"), 
#        aes(x = date, y = value, group = variable, color = variable, fill = variable, shape = variable)) +
#   geom_point() +
#   geom_smooth() +
#   facet_wrap(~country, scales = "free", ncol = 2) +
#   scale_color_few() +
#   scale_fill_few() +
#   theme(legend.position = c(0.60, 0.20)) +
#   labs(x = NULL, y = "Cases/Deaths", title = "West African 2014 Ebola Outbreak")

historical_melt <- historical %>%
  group_by(year2, country) %>%
  summarize(cases = sum(cases),
            deaths = sum(deaths)) %>%
  mutate(survived = cases - deaths, 
         year = year2) %>%
  melt(id.vars = c("country", "year"), measure.vars = c("deaths", "survived"), variable.name = "outcome")

historical_melt <- recent %>%
  filter(country == "Total", date == max(date)) %>%
  mutate(variable = tolower(variable)) %>%
  dcast(date + country ~ variable) %>%
  mutate(survived = cases - deaths, 
         year = year(date)) %>%
  melt(id.vars = c("country", "year"), measure.vars = c("deaths", "survived"), variable.name = "outcome") %>%
  rbind(historical_melt) %>%
  arrange(year, outcome, country)

save(historical_melt, file = "historical_melt.RData")
