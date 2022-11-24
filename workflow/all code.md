```{r}
#Describing communities - or any other informative title
#Your Name
#Date
#Any other comments you want to add
```

```{r}
setwd(your/file/path) #enter the filepath to the working directory you want to work in
getwd() #check whether you set the working directory as you meant to
```

```{r}
library(tidyverse) #contains dplyr, tidyr, ggplot2 and more
library(ggthemes) #we will use this to add a cool theme to our graphs
```

```{r}
install.packages ("tidyverse")
install.packages ("ggthemes")
```

```{r}
parks<- read.csv("~Desktop/Users/Kinga/Tutorial/field_data_2")
#Enter your own filepath
```

```{r}
glimpse(parks) #basic information about our data - i find this the most useful to get a feel of the data
head(parks) #first few observations
names(parks) #names of the columns
```

```{r}
parks_tidy<- parks %>% gather(species, abundance, c(2:21)) %>% 
  #organizing into long format, where counts of individuals (value) are assigned    to species (key)
  mutate(abundance = parse_number(abundance)) %>% 
  #removing non-numeric parts (notes) from values in the abundance column
  na.omit()
  #removing NA-s
```

```{r}
View (parks_tidy)
```

```{r}
(richness<- parks_tidy%>% 
  group_by(site) %>% 
  summarise(sp.richness =length(unique(species)))
 )
#By putting the entire code in brackets, the entire dataframe is displayed in the console.
```

```{r}
#visualising
(barplot_richness<- ggplot (richness, aes(x= site, y=sp_richness, fill=site)) +
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
```

```{r}
ggsave(barplot_richness, file="background/barplot_richness.png", width= 6, height=6)
#save our plot - don't forget to enter your own filepath!
```

```{r}
parks_tidy<-parks_tidy %>%
  #we don't need to make a new dataframe as we are only adding a column,
  #not changing any of the existing ones.
  group_by(site) %>% 
  mutate(relative.abundance = abundance/sum(abundance)) %>% 
  #creating a new column 
  ungroup()
  #removing groupings
```

```{r}
parks_tidy %>% 
  group_by(site) %>% 
  summarise(simpsons.dom =sum(relative.abundance^2)) %>% 
  ungroup()
```

```{r}
parks_tidy %>% 
  group_by(site) %>% 
  summarise(shannons.div = -sum(relative.abundance*log(relative.abundance))) %>%
  ungroup()
```

```{r}
summary<- parks_tidy %>% 
  group_by(site) %>% 
  summarise(sp.richness = length(unique(species)),
            shannons.diversity = -sum(relative.abundance*log(relative.abundance)),
            simpsons.dominance = sum(relative.abundance^2)) %>% 
  ungroup()
```

```{r}
(sad <- parks_frequency %>%  
    #calling our graph sad
    ggplot(aes(x = abundance, y=frequency_of_abundance, fill=site)) +
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
        axis.text = element_text(size = 14), 
        axis.title = element_text(size = 16)))
        #increasing font size
```

```{r}
ggsave(sad, file="background/sad.png", width= 6, height=6)
#save our plot - don't forget to enter your own filepath!
```

```{r}
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
```

```{r}
ggsave(rank_abundance_plots, file="background/rank_abundance.png", width= 6, height=6)
#save our plot - don't forget to enter your own filepath!
```
