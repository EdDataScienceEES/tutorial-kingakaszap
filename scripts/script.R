# misc - hopefully ---- 
parks<- read.csv("datasets/parks1.csv")

parks<- parks2

glimpse(parks) #shows all the columns, and their values
head(parks) #shows the first few observations
names(parks) #shows the names of the columns


#Part 1 - importing data& title----

#Describing communities
#Kinga Kaszap
#23/11/2022

#Describing communities
#Your Name
#Date
#Any other comments you want to add

#Libraries ----
library(tidyverse)
library(ggthemes)

#part 2 - data wrangling ----
View(parks)
parks_tidy<- parks %>% gather(species, abundance, c(2:21)) %>% 
  #organizing into long format, where individual counts(value) is gathered by species (key)
  #removing NA-s
  mutate(abundance = parse_number(abundance)) %>% 
  na.omit()
  #turning values in the abundance column into numeric - removing notes like "???" and "maybe more"

View(parks_tidy)
glimpse(parks_tidy)


#part 3 - species richness----

#calculating richness for the parks

(richness<- parks_tidy%>% 
  group_by(site) %>% 
  summarise(sp_richness =length(unique(species))))
View(richness)

#visualising
(barplot<- ggplot (richness, aes(x= site, y=sp_richness)) + geom_bar(stat="identity"))

#rank- abundance curves FAILED ATTEMPT WITH VEGAN----

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


#part 4 - Diversity ----

#accounts for variation in the number of species, AND the way individuals within a community
#are distributed among species.

#Simpson's indexes
#Describes evenness - how evenly are individuals distributed among the species that are present within a community?
#Describes a community

#Simpson's dominance

parks_tidy %>% 
  group_by(site) %>% 
  summarise(simpsons_dominance = sum((abundance/sum(abundance))^2))

#All indices in one table
summary<-parks_tidy %>% 
  group_by(site) %>% 
  summarise(simpsons_dominance = sum((abundance/sum(abundance))^2), 
            sp_richness =length(unique(species)),
            simpsons_diversity = (1-simpsons_dominance),
            simpsons_reciprocal = (1/simpsons_dominance)) %>% 
  ungroup()

View(summary)

#part 5 - SAD ----

#To visualise evennes of sites, we can make a SAD diagram for each site.
#SAD meaning species-abundance distribution 

#making new dataframe

parks_frequency<- parks_tidy %>%
  group_by(site, abundance) %>% 
  summarise(frequency_of_abundance = length(species)) %>% 
  ungroup()

#Individual plots

#Plots
(sad <- parks_frequency %>%                            
    ggplot(aes(x = abundance, y=frequency_of_abundance)) +
    geom_bar(stat="identity") +
    facet_wrap(~ site, scale="free"))

#what is wrong with my graph now

### Trying to make rank abundance graphs for my parks ----

View(parks_tidy)

#We need: relative abundance (y axis) and Rank (x axis.)

#We will make new columns for that.

parks_rankabundance <- parks_tidy %>% 
  group_by(site) %>% 
  mutate(rel.abund = abundance/sum(abundance)*100,
         rank= (rank(- abundance, ties.method="random"))) %>% 
  ungroup()

(rank_abundance_plots<- parks_rankabundance %>% 
  ggplot(aes(x=rank, y=rel.abund))+
  geom_point(aes(color=species, fill= species))+
  geom_line(colour="black")+
  theme_bw()+
  labs(x="Rank", y="Relative abundance (%)")+
  theme(legend.position="none")+
  facet_wrap(~site, scale="free"))
  
  
  

# Trying to import csv data

parks<- read.csv("datasets/parks1.csv")
