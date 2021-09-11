#Análisis Airbnb

#CARGO BASES

library(tidyverse)
library(dplyr)
library(sf)

DATA_AB2019 <- read.csv("https://query.data.world/s/v7xpthpx5kvhyccn2gy2vukmx47qnx", header=TRUE, stringsAsFactors=FALSE)

DATA_AB2019 <- DATA_AB2019 %>%
  select(id, listing_url, last_scraped, summary, description, host_id, host_since, latitude, 
         longitude, property_type, bathrooms, bedrooms, square_feet, price, monthly_price, 
         minimum_nights, maximum_nights, availability_30, availability_60, number_of_reviews, 
         review_scores_rating, review_scores_location, review_scores_value)

DATA_NOV2015 <-read.csv("https://raw.githubusercontent.com/vicky-marco/AIRBNB/master/Airbnb%20listings%20in%20Buenos_Aires%2C%20November%202015.csv", header=TRUE, stringsAsFactors=FALSE)

DATA_JUL2017 <- read.csv("https://raw.githubusercontent.com/vicky-marco/AIRBNB/master/airbnb_CABA_07_2017.csv", header=TRUE, stringsAsFactors=FALSE)

summary(DATA_NOV2015)

summary(DATA_JUL2017)

DATA_AB2019 <- DATA_AB2019 %>%
  rename(id_2019=id, host_id_2019= host_id, price_2019_pe=price, availability_30_2019=availability_30)

DATA_AB2019_corte <- DATA_AB2019 %>% 
  select(id_2019, host_id_2019, price_2019_pe, availability_30_2019, latitude, longitude)

DATA_NOV2015_corte <- DATA_NOV2015 %>% 
  rename(host_id_2015= host_id, price_2015_dol=price)

DATA_NOV2015_corte <- DATA_NOV2015_corte %>% 
  select(host_id_2015, price_2015_dol, latitude, longitude)
  
DATA_JUL2017 <- DATA_JUL2017 %>% 
  rename(host_id_2017= host_id, price_2017_pe=price, room_type_2017=room_type)
  
DATA_JUL2017_corte<- DATA_JUL2017 %>% 
  select(host_id_2017, price_2017_pe, room_type_2017, latitude, longitude)


HOLA
  
