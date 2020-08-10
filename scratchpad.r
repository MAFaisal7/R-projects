df_pollutants <- read.csv("epa_hap_daily_summary.csv")

df_honeyProd <- read.csv("20465_26638_bundle_archive/honeyproduction.csv")

max(as.character(df_pollutants$date_local))
df_pollutants$date_local <- as.Date(as.character(df_pollutants$date_local), format = "%Y-%m-%d")
min(df_pollutants$date_local)
max(df_pollutants$date_local)

library(tidyverse)
# check distribution of pollutant parameter for comparison
df_pollutants %>% 
  filter(state_code == 42) %>%
  ggplot(aes(y = arithmetic_mean, x = parameter_name)) + geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90))

library(lubridate)
df_pollutants %>% 
  select(date_local, state_name, parameter_code, parameter_name, pollutant_standard, units_of_measure,
         arithmetic_mean) %>% 
  mutate(year = year(date_local)) -> df_pollutants_trimmed

library(USAboundaries)
df_honeyProd$state <- as.character(df_honeyProd$state)
df_honeyProd %>% 
  left_join(select(state_codes, state_abbr, state_name), 
            by = c("state" = "state_abbr")) -> df_honey_state

df_pollutants_trimmed %>% 
  group_by(year, state_name) %>% 
  summarise(pollutants_agg = sum(arithmetic_mean)) %>% 
  left_join(df_honey_state, by = c("state_name", "year")) %>% 
  drop_na() -> df_pollutants_honeyProd

ggplot(df_pollutants_honeyProd, aes(x = pollutants_agg, y = totalprod)) +
  geom_point() + facet_wrap(~ state_name)

ggplot(df_pollutants_honeyProd, aes(x = pollutants_agg, y = yieldpercol)) +
  geom_point() + facet_wrap(~ state_name)

ggplot(df_pollutants_honeyProd, aes(x = pollutants_agg, y = yieldpercol)) +
  geom_point() + facet_wrap(~ state_name) + geom_smooth(method = "lm")

ggplot(df_pollutants_honeyProd, aes(x = year, y = yieldpercol)) +
  geom_line() + facet_wrap(~ state_name)

ggplot(df_pollutants_honeyProd, aes(x = year, y = pollutants_agg)) +
  geom_line() + facet_wrap(~ state_name, scales = 'free')
