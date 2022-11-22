parks<- read.csv("datasets/parks1.csv")
View(parks)
library(tidyverse)

glimpse(parks) #shows all the columns, and their values
head(parks) #shows the first few observations
names(parks) #shows the names of the columns

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
  #removing NA-s
  mutate(abundance = parse_number(abundance)) %>% 
  na.omit()
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

### Diversity ----

#accounts for variation in the number of species, AND the way individuals within a community
#are distributed among species.

#Simpson's indexes
#Describes evenness - how evenly are individuals distributed among the species that are present within a community?
#Describes a community

dominance<-parks_tidy %>% 
  group_by(site) %>% 
  mutate(total_individuals =sum(abundance)) %>% 
  group_by(site,species) %>% 
  summarise(simpsons_dominance = sum((abundance/total_individuals)^2) ) #NOT GOOD AT ALL

View(richness)

#calculating individual dominances

figgate<-subset(parks_tidy, site=="Figgate")
craigmillar<-subset(parks_tidy, site=="Craigmillar")
meadows<- subset(parks_tidy, site=="Meadows")
blackford<- subset(parks_tidy, site=="Blackford")

(figgate_dominance = sum((figgate$abundance/sum(figgate$abundance))^2))
(craigmillar_dominance = sum((craigmillar$abundance/sum(craigmillar$abundance))^2))
(blackford_dominance = sum((blackford$abundance/sum(blackford$abundance))^2))
(meadows_dominance = sum((meadows$abundance/sum(meadows$abundance))^2))


#trying without intermediary object
dominance<-parks_tidy %>% 
  group_by(site) %>% 
  summarise(simpsons_dominance = sum((abundance/sum(abundance))^2), 
            sp_richness =length(unique(species)),
            simpsons_diversity = (1-simpsons_dominance),
            simpsons_reciprocal = (1/simpsons_dominance))

#part 5 - SAD

#To visualise evennes of sites, we can make a SAD diagram for each site.
#SAD meaning species-abundance distribution 

View(figgate)
figgate$abundance<-as.factor(figgate$abundance)
figgate$species<-as.factor(figgate$species)
figgate_for_graph<-figgate %>% 
  group_by(abundance) %>% 
  summarise(frequency_of_abundance= (length(species)))

str(figgate_for_graph)
figgate_for_graph$frequency_of_abundance<- as.numeric(figgate_for_graph$frequency_of_abundance)

(barplot(figgate_for_graph, aes(x=frequency_of_abundance))+geom_histogram())

ggplot(figgate_for_graph, aes(x=abundance, y=frequency_of_abundance)) + geom_bar(stat="identity")
# part 5 - rank abundance diagram

#trying to do it for all of them:

parks_frequency<- parks_tidy %>% 
  mutate(abundance = as.factor(abundance)) %>% 
  group_by(site, abundance) %>% 
  summarise(frequency_of_abundance = length(species)) %>% 
  ungroup()

#Individual plots

#trying without subsets
(sad <- parks_frequency %>%                            
    ggplot(aes(x = abundance, y=frequency_of_abundance)) +
    geom_bar(stat="identity") +
    facet_wrap(~ site, scale = 'free'))

figgate_f<- subset(parks_frequency, site == "Figgate")
craigmillar_f<- subset(parks_frequency, site == "Craigmillar")
blackford_f<- subset(parks_frequency, site == "Blackford")
meadows_f<-subset(parks_frequency, site == "Meadows")

ggplot(figgate_for_graph, aes(x=abundance, y=frequency_of_abundance)) + geom_bar(stat="identity")