parks<- read.csv("tutorial ideas/datasets/parks1.csv")
View(parks)
library(tidyverse)

long<-parks2 %>% gather(species, abundance, c(2:21))
View(long)
long$site<-as.factor(long$site)
str(long)
omits<-long %>% na.omit()
View(omits)
parks_long<-omits %>% mutate(abundance = parse_number(abundance))
View(parks_long)


#Part 1 - importing data----
#Libraries ----
library(tidyverse)

#part 2 - data wrangling ----
View(parks)
parks_tidy<- parks %>% gather(species, abundance, c(2:21)) %>% 
  #organizing into long format, where individual counts(value) is gathered by species (key)
  na.omit() %>%
  #removing NA-s
  mutate(abundance = parse_number(abundance)) 
  #turning values in the abundance column into numeric - removing notes like "???" and "maybe more"

View(parks_tidy)


#part 3 - species richness----
str(parks_tidy)

#calculating richness for the parks
parks_tidy$site<-as.factor(parks_tidy$site)

richness<- parks_tidy%>% 
  group_by(site) %>% 
  summarise(sp_richness =length(unique(species)))
View(richness)

#visualising
(barplot<- ggplot (richness, aes(x= site, y=sp_richness)) + geom_bar(stat="identity"))

#rank- abundance curves----

library(vegan)
library(BiodiversityR)

figgate<-subset(parks_tidy, site=="Figgate")
View(figgate)
str(figgate)
figgate$species<-as.factor(figgate$species)
for_ra<-figgate %>% select(-site)
str(for_ra)
ra1<- rankabundance(figgate)

library(vegan)
data(dune.env)
data(dune)
RankAbun.1 <- rankabundance(dune)

#part 4 - diversity indeces----

# Relative abundance of a given species
#What is the relative abundance of each species in Figgate park?

figgate_2<- figgate %>% 
  mutate(rel.abundance.percent = (abundance/sum(abundance)*100)) #how to reduce decimals
View(figgate_2)
sum(figgate_2$rel.abundance.percent)

relative<-parks_tidy %>% 
  group_by(site) %>% 
  mutate(rel.abund = (abundance/sum(abundance))) %>% 
  ungroup()

View(relative)
