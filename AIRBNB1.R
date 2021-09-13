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


DATA_AB2019_corte <- DATA_AB2019_corte %>% 
  filter(!is.na(latitude), !is.na(longitude)) %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
  
DATA_NOV2015_corte <- DATA_NOV2015_corte %>% 
  filter(!is.na(latitude), !is.na(longitude)) %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

DATA_JUL2017_corte <- DATA_JUL2017_corte %>% 
  filter(!is.na(latitude), !is.na(longitude)) %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

BASE_CONS <-st_join (DATA_AB2019_corte, DATA_JUL2017_corte)

BASE_CONS <- st_join (BASE_CONS, DATA_NOV2015_corte)

BASE_CONS <- BASE_CONS %>% 
  filter(!is.na(latitude), !is.na(longitude)) %>% 
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

BASE_CONS_filtrada <- BASE_CONS %>% 
  filter(!is.na(host_id_2017), !is.na(price_2017_pe), !is.na(host_id_2015), !is.na(price_2015_dol))

BARRIOS <- read_sf("https://raw.githubusercontent.com/SSoubie/MEU-Hackers/main/Datasets/mapaCABA.geojson") 

st_crs(BARRIOS)

BARRIOS <-st_transform(BARRIOS, crs=st_crs(BASE_CONS))

BASE_CONS_BARRIOS <- st_join(BASE_CONS, BARRIOS)


DATA_AB2019_corte <- DATA_AB2019_corte %>% 
  filter(!is.na(price_2019_pe)) %>% 
  mutate(precio=str_sub(price_2019_pe, 2,6)) %>% 
  mutate(precio2=str_replace(precio, ",", ""))

DATA_AB2019_corte <- DATA_AB2019_corte %>% 
  mutate(precio3=(as.numeric(precio2)/42.95))

DATA_AB2019_corte <- st_join(DATA_AB2019_corte, BARRIOS)

CANT_BARRIO_2019 <- DATA_AB2019_corte %>% 
  group_by(barrio) %>% 
  summarise(cantidad_2019=n())

VALOR_BARRIO_2019 <- DATA_AB2019_corte %>% 
  group_by(barrio) %>% 
  summarise(media_precio=mean(precio3))


DATA_NOV2015_corte <- st_join(DATA_NOV2015_corte, BARRIOS)

CANT_BARRIO_2015 <- DATA_NOV2015_corte %>% 
  group_by(barrio) %>% 
  summarise(cantidad_2015=n())

VALOR_BARRIO_2019 <- DATA_AB2019_corte %>% 
  group_by(barrio) %>% 
  summarise(media_precio=mean(precio3))

DENSIDAD <- CANT_BARRIO_2015 %>% 
  st_set_geometry(NULL) 

DENSIDAD <- DENSIDAD%>% 
  left_join(BARRIOS, by="barrio")

DENSIDAD <- DENSIDAD %>% 
  mutate(densidad=area/cantidad_2015)

DENSIDAD_2019 <- CANT_BARRIO_2019 %>% 
  st_set_geometry(NULL) %>% 
  left_join(BARRIOS, by="barrio")

DENSIDAD_2019 <- DENSIDAD_2019 %>% 
  mutate(densidad=area/cantidad_2019)

ggplot()+
  geom_sf(data=BARRIOS, fill="gray60")+
  geom_sf(data=DENSIDAD_2019, aes(fill=densidad))+
  labs(title = "Densidad de unidades de Airbnb por barrio", 
       fill = "Densidad", 
       subtitle =  "Abril 2019",
       x="Longitud", y="Latitud")+
  theme(title=element_text(size=8),
        axis.text=element_text(size=8), axis.title=element_text(size=10),legend.text=element_text(size=10))+
  scale_fill_viridis_c()




