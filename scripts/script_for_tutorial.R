# Part 1 - title & import data & libraries----

#Describing communities
#Kinga Kaszap
#23/11/2022

#Describing communities - or any other informative title
#Your Name
#Date
#Any other comments you want to add

parks<- read.csv("data/field_data.csv")
# add your own filepath

# load libraries

library(tidyverse)
library(ggthemes)

# Part 2 - data wrangling ----

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

# Part 3 - species richness ----

(richness<- parks_tidy %>% 
    group_by(site) %>% 
    summarise(sp.richness = length(unique(species)))
)

#visualising
(barplot_richness <- ggplot (richness, aes(x = site, y = sp.richness, fill = site)) +
    # setting the x and y axes, and asking R to give different colors to the sites
    geom_bar(stat = "identity") +
    # specifying that we want a barplot 
    labs( x= "\nPark", y = "Species richness\n") +
    # giving informative names to the axes
    theme_few() +
    # adding a theme from ggthemes - feel free to add a different one!
    scale_fill_brewer(palette = "Accent") + 
    #adding a color palette - feel free to add a different one!
    theme(legend.position = "none",
          # removing the legend as the axes provide enough information 
          axis.text = element_text(size = 14), 
          axis.title = element_text(size = 16),
          # increasing font size
          axis.text.x = element_text(angle = 45, hjust = 1)))
# tilting the text of the x axis

ggsave (barplot_richness, file = "outputs/richnessplot.png", width = 6, height = 6)
# save our plot - don't forget to enter your own filepath!


# Part 4 - diversity ----

# accounts for variation in the number of species
# AND the way individuals within a community are distributed among species.

# These indices work with relative abundance.
# We will add a column for that:

parks_tidy <- parks_tidy %>%
  # we don't need to make a new dataframe as we are only adding a column,
  # not changing any of the existing ones.
  group_by(site) %>% 
  mutate(relative.abundance = abundance/sum(abundance)) %>% 
  # creating a new column 
  ungroup()
# removing groupings

# Simpson's dominance
parks_tidy %>% 
  group_by(site) %>% 
  summarise(simpsons.dominance = sum(relative.abundance^2)) %>% 
  ungroup()

# shannons index
parks_tidy %>% 
  group_by(site) %>% 
  summarise(shannons.diversity = -sum(relative.abundance*log(relative.abundance))) %>% 
  ungroup()

# all indices in one table

(summary<- parks_tidy %>% 
    group_by(site) %>% 
    summarise(sp.richness = length(unique(species)),
              shannons.diversity = -sum(relative.abundance*log(relative.abundance)),
              simpsons.dominance = sum(relative.abundance^2)) %>% 
    ungroup())


# Part 5 - SAD ----

# How are species distributed in terms of abundance classes?
# SAD = species-abundance distribution 

# making new dataframe

parks_frequency<- parks_tidy %>%
  group_by(site, abundance) %>% 
  summarise(frequency.of.abundance = length(species)) %>% 
  ungroup()

#Plots

(sad <- parks_frequency %>%                            
    ggplot(aes(x = abundance, y=frequency.of.abundance, fill = site)) +
    geom_bar(stat = "identity") +
    theme_tufte() +
    facet_wrap(~ site, scale = "free") +
    labs(x = "\nNumber of individuals", y = "Number of species\n")+
    # giving informative names to the axes
    theme_few() +
    # adding a theme from ggthemes - feel free to add a different one!
    scale_fill_brewer(palette = "Accent") + 
    # adding a color palette - feel free to add a different one!
    theme(legend.position = "none",
          # removing the legend as the axes provide enough information 
          axis.text = element_text(size = 12), 
          axis.title = element_text(size = 16)))
# increasing font size

ggsave(sad, file="outputs/sad.png", width= 6, height=6)



# Part 6 - Rank-Abundance diagrams ----

#We need: relative abundance (y axis) and Rank (x axis.)

#Make a new dataframe that includes those columns

parks_rankabundance <- parks_tidy %>% 
  group_by(site) %>% 
  mutate(rel.abund.percent = relative.abundance*100,
         rank = (rank(- abundance, ties.method = "random"))) %>% 
  ungroup()

View(parks_rankabundance)

(rank_abundance_plots <- parks_rankabundance %>% 
    ggplot(aes(x = rank, y = rel.abund.percent)) +
    # specifying the x and y axes
    geom_point(aes(color = species, fill = species), size = 2) +
    # increasing default point size
    geom_line(colour = "black") +
    # adding a line connecting the points
    labs(x = "\nRank", y="Relative abundance (%)\n") +
    facet_wrap(~site) +
    #making separate plots for sites
    theme_few() +
    # adding a theme from ggthemes - feel free to add a different one!
    theme(legend.position = "none"))
#removing the legend as the axes provide enough information 

ggsave(rank_abundance_plots, file = "outputs/rank_abundance.png", width = 6, height = 6)  

