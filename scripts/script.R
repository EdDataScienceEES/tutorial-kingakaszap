

#Part 1 - importing data& title----

#Describing communities
#Kinga Kaszap
#23/11/2022

#Describing communities - or any other informative title
#Your Name
#Date
#Any other comments you want to add

write.csv(parks2, file="datasets/field_data_3")
parks<- read.csv("datasets/field_data_3")
#Libraries ----
library(tidyverse)
library(ggthemes)

#part 2 - data wrangling ----
View(parks)

glimpse(parks) #shows all the columns, and their values
head(parks) #shows the first few observations
names(parks) #shows the names of the columns

parks_tidy<- parks %>% gather(species, abundance, c(2:21)) %>% 
  #organizing into long format, where counts of individuals (value) are assigned to species (key)
  mutate(abundance = parse_number(abundance)) %>% 
  #removing non-numeric parts (notes) from values in the abundance column
  na.omit()
  #removing NA-s

View (parks_tidy)
glimpse(parks_tidy)


#part 3 - species richness----

#calculating richness for the parks

(richness<- parks_tidy%>% 
  group_by(site) %>% 
  summarise(sp.richness =length(unique(species)))
 )
View(richness)

parks_tidy%>% 
    group_by(site) %>% 
    summarise(sp.richness =length(unique(species)))


#visualising
(barplot_richness<- ggplot (richness, aes(x= site, y=sp.richness, fill=site)) +
    #setting the x and y axes, and asking R to give different colors to the sites
    geom_bar(stat="identity")+
    #specifying that we want a barplot what does stat identity do?
    labs(x= "\nPark", y= "Species richness\n")+
    #giving informative names to the axes
    theme_few()+
    #adding a theme from ggthemes - feel free to add a different one!
    scale_fill_brewer(palette = "Accent")+ 
    #adding a color palette - feel free to add a different one!
    theme(legend.position = "none",
    #removing the legend as the axes provide enough information 
    axis.text = element_text(size = 14), 
    axis.title = element_text(size = 16),
    #increasing font size
     axis.text.x = element_text(angle=45, hjust=1)))
    #tilting the text of the x axis

ggsave(barplot_richness, file="plots/barplot_richness.png", width= 6, height=6)
#save our plot - don't forget to enter your own filepath!



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

#Many of the indices work with relative abundance.
#We will add a column for that:

parks_tidy<-parks_tidy %>%
  #we don't need to make a new dataframe as we are only adding a column,
  #not changing any of the existing ones.
  group_by(site) %>% 
  mutate(relative.abundance = abundance/sum(abundance)) %>% 
  #creating a new column 
  ungroup()
  #removing groupings
#Simpson's indexes
#Describes evenness - how evenly are individuals distributed among the species that are present within a community?
#Describes a community

#Simpson's dominance
parks_tidy %>% 
  group_by(site) %>% 
  summarise(simpsons.dominance =sum(relative.abundance^2)) %>% 
  ungroup()

parks_tidy %>% 
  group_by(site) %>% 
  summarise(simpsons.dominance = sum((abundance/sum(abundance))^2)) %>% 
  ungroup ()

#shannons index
parks_tidy %>% 
  group_by(site) %>% 
  summarise(shannons.diversity = -sum(relative.abundance*log(relative.abundance))) %>% 
  ungroup()


#All indices in one table
summary<-parks_tidy %>% 
  group_by(site) %>% 
  summarise(simpsons_dominance = sum((abundance/sum(abundance))^2), 
            sp.richness =length(unique(species)),
            simpsons.diversity = (1-simpsons_dominance),
            simpsons_reciprocal = (1/simpsons_dominance),
            shannons_div = -(sum((abundance/sum(abundance))*log(sum((abundance/sum(abundance))))))) %>% 
  ungroup()

View(summary)

#new indices in one table


(summary<- parks_tidy %>% 
  group_by(site) %>% 
  summarise(sp.richness = length(unique(species)),
            shannons.diversity = -sum(relative.abundance*log(relative.abundance)),
            simpsons.dominance = sum(relative.abundance^2)) %>% 
  ungroup())

View(summary)

#part 5 - SAD ----

#To visualise evennes of sites, we can make a SAD diagram for each site.
#SAD meaning species-abundance distribution 

#making new dataframe

parks_frequency<- parks_tidy %>%
  group_by(site, abundance) %>% 
  summarise(frequency.of.abundance = length(species)) %>% 
  ungroup()

#Individual plots

#Plots
(sad <- parks_frequency %>%                            
    ggplot(aes(x = abundance, y=frequency.of.abundance, fill=site)) +
    geom_bar(stat="identity") +
    theme_tufte()+
    facet_wrap(~ site, scale="free")+
labs(x= "\nNumber of individuals", y= "Number of species\n")+
  #giving informative names to the axes
  theme_few()+
  #adding a theme from ggthemes - feel free to add a different one!
  scale_fill_brewer(palette = "Accent")+ 
  #adding a color palette - feel free to add a different one!
  theme(legend.position = "none",
        #removing the legend as the axes provide enough information 
        axis.text = element_text(size = 12), 
        axis.title = element_text(size = 16)))
        #increasing font size

ggsave(sad, file="plots/sad.png", width= 6, height=6)

(sad <- parks_frequency %>%                            
    ggplot(aes(x = abundance, y=frequency.of.abundance, fill=site)) +
    geom_bar(stat="identity") +
    theme_tufte()+
    facet_wrap(~ site)+
    labs(x= "\nNumber of individuals", y= "Number of species\n")+
    #giving informative names to the axes
    theme_few()+
    #adding a theme from ggthemes - feel free to add a different one!
    scale_fill_brewer(palette = "Accent")+ 
    #adding a color palette - feel free to add a different one!
    theme(legend.position = "none",
          #removing the legend as the axes provide enough information 
          axis.text = element_text(size = 12), 
          axis.title = element_text(size = 16)))
#increasing font size

       

#what is wrong with my graph now

### Trying to make rank abundance graphs for my parks ----

View(parks_tidy)

#We need: relative abundance (y axis) and Rank (x axis.)

#We will make new columns for that.

parks_rankabundance <- parks_tidy %>% 
  group_by(site) %>% 
  mutate(rel.abund.percent = relative.abundance*100,
         rank= (rank(- abundance, ties.method="random"))) %>% 
  ungroup()

(rank_abundance_plots<- parks_rankabundance %>% 
  ggplot(aes(x=rank, y=rel.abund.percent))+
  #specifying the x and y axes
  geom_point(aes(color=species, fill= species), size=2)+
  #increasing default point size
  geom_line(colour="black")+
  #adding a line connecting the points
  labs(x="\nRank", y="Relative abundance (%)\n")+
  facet_wrap(~site, scale="free")+
  #making separate plots for sites, allowing scales of axes to vary
  theme_few()+
  #adding a theme from ggthemes - feel free to add a different one!
  theme(legend.position = "none"))
  #removing the legend as the axes provide enough information 

ggsave(rank_abundance_plots, file="plots/rank_abundance.png", width= 6, height=6)  
  
(rank_abundance_plots_2<- parks_rankabundance %>% 
    ggplot(aes(x=rank, y=rel.abund.percent))+
    #specifying the x and y axes
    geom_point(aes(color=species, fill= species), size=2)+
    #increasing default point size
    geom_line(colour="black")+
    #adding a line connecting the points
    labs(x="\nRank", y="Relative abundance (%)\n")+
    facet_wrap(~site)+
    #making separate plots for sites, allowing scales of axes to vary
    theme_few()+
    #adding a theme from ggthemes - feel free to add a different one!
    theme(legend.position = "none"))
#removing the legend as the axes provide enough information 

ggsave(rank_abundance_plots_2, file="plots/rankabundance2.png", width=6, height=6)

