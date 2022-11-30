# Tutorial Aims:

# Tutorial Steps

1.  Setting the secene/introduction to community ecology

2.  Importing and tidying field data

3.  Species richness

    -   calculating richness

    ```{=html}
    <!-- -->
    ```
    -   visualising differences in species richness

4.  Calculating diversity indices

    -   Simpson's dominance

    -   Shannon-Wiener diversity index

    -   Making a summary table

5.  Basic visualisation - SAD diagrams

6.  A bit more complex visualisation - Rank-Abundance diagrams

This tutorial will introduce some basic methods of describing and comparing biological communities using R. It builds on some methods and concepts used in community ecology, but if you've never done community ecology before, that's also fine! The concepts used are relatively simple, and will be explained in detail in the tutorial. The tutorial is aimed at beginners, but expects you to have downloaded RStudio and are somewhat familiar with its layout. If you are completely new to RStudio, check out this tutorial! (Insert coding club reference)

# Setting the scene

Have you ever wondered how communities occupying different habitats (or micro-habitats) vary? Or about whether habitat types vary in the number of species they accomodate? For example, how your backyard might differ from the nearby forest?

...

No? Maybe it's just me then. Anyway, community ecology is a fascinating branch of biology, and on the large scale, can be used to answer some of the most relevant questions of today:

How is biodiversity distributed in the world? And how is it changing? In more practical terms, what tools do we have to answer those questions?

In this tutorial, to keep it simple and easy to grasp, we are using a small scale. But the basic concepts introduced (combined with wayyy more complicated equations, see *insert horrible equation*) can be applied on the global scale as well.

For the purpose of this tutorial, imagine that you are a field ecologist, and have been asked by Edinburgh City Council to compare how greenspaces differ in the type of habitat they provide to birds. /the communities of birds different greenspaces of the city support. You work on four main sites: Blackford Hill and the Hermitage, the Meadows, Figgate park and Craigmillar park.

You think: this is easy! I'll just go with my binoculars, have a hot chocolate (or coffee, if you prefer), and record what species I see in each park, and how many individuals of each.

But then what?

What values do you report to the council when describing each park? How do you make comparisons between the habitats they provide?

Let's begin...

# Importing and tidying field data

In ecology, there is usually a big difference between the format observations are recorded in the field, and the format a programming language such as R requires to be able to work with your data. Say you collected your data on paper, trying to make somewhat of a table, while also adding notes to your observations. You copied your observations into Excel, exactly in the same format, to reduce copying errors. Now you want to start working with your data...

-   First, open RStudio,

    Open RStudio, and click on `File/New File/R Script`.

-   Introduce your script

    It is good practice to "introduce your code" - so that anyone who may look at it knows immediately whose work it is, when was it created, and what purpose. It is also useful if you ever want to look back on your work, or find a specific script.

    ```{r}
    #Describing communities - feel free to change the title of your script!
    #Your Name
    #Date
    #Any other comments you want to add

    ```

-   set up working directory

Loading libraries

Before we start working with our data, we need to load any libraries we will be using throughout the script. We actually only need one.

```{r}
library (tidyverse) # contains packages dplyr for efficient data manipulation,
#tidyr for data wrangling
#ggplot2 for pretty data visualization
#and more...
```

-If you don't have `tidyverse` installed on your computer, run

```{r}
install.packages (tidyverse)
```

in your console (insert pic pointing at console) (so R doesn't re-install the packages each time you run the code).

Let's import our data.

```{r}
parks<- read.csv("datasets/parks1.csv") #will have to change that depending on whether i can do a csv file and add filepath
```

The dataset should appear in the environment (insert pic) section of RStudio. With using `<-`, we assigned it to a dataframe called `parks`.

Let's see what we have here!

```{r}
glimpse(parks)
head(parks)
names(parks)
```

Now we have a feel of our data. The `glimpse` function tells us we have 4 rows (one row for each site), and 21 columns. We can also see that the column names 2-21 are the bird species we observed (one for each species), and the columns themselves contain the abundance of said birds in each park, if they were present, plus field notes ( like "`5(could be morhen)`"). `R` also tells us the what type of data it thinks each column is - we can see that some of our columns contain character (`<chr>`), while others integer (`<int>`) variables.

Overall, the data looks quite messy - and wide. (21 columns is a lot for such a small dataset).

Let's do some tidying!

We want to convert our data into *long* format - where each row shows an observation, and each column represents a variable. We also want to get rid of any N/A values, and make sure each column only contains one type of variable.

For our data, our variables for each observation are: Park (Where was the observation recorded?), Species (What bird are we talking about?) and Abundance (How many individuals of said bird did we count in the specified park?). So, we have to shorten our dataset to 3 columns instead of the present 21. We can leave the first column alone, but we need to do some work on columns `2:21`!

We do this in one command with using dplyr's pipe ( `%>%`) operator. Learn more about `dplyr` and pipes here (add CC link).

```{r}
parks_tidy<- parks %>% gather(species, abundance, c(2:21)) %>% 
#organizing into long format, where individual counts(value) are gathered by    species (key)
mutate(abundance = parse_number(abundance)) %>% 
#turning values in the abundance column into numeric - this function removes notes like "???" and "maybe more"
na.omit()
#removing NA-s
```

```{r}
glimpse(parks_tidy) #see how our dataset looks like now
```

Looks good! There are only 3 columns, like we wanted, and the `abundance`column is now numeric. We don't have any N/A-s either. We can see that the number of rows increased from 4 to 44 - there is a reason why this is called "long format"...

**what is meant by a tidy format?** (maybe add box)

# Calculating species richness

Right! Our data is in a tidy format. Now we can start working with it.

The most basic index characterizing communities is *species richness*. It merely describes the number of different species present at a site. You might think of it as an useful value to report to the Council - Is there a difference between the number of species each park accomodates?

For easy visualization, we will make a dataframe containing the richness values of each park.

```{r}
(richness<- parks_tidy%>%
    #making the new dataframe by passing the tidy dataframe through a pipe
  group_by(site) %>% 
    #grouping into sites, as we want one value for each park
  summarise(sp_richness =length(unique(species)))%>% 
   # aggregating the dataframe - only showing the summary we are asking for
  ungroup()
  #it is good practice to remove any groupings at the end of your pipe.
)
  
```

Two things to note:

-   by putting the entire code into brackets, the output will be instantly displayed in the console.

-   We calculate species richness for our groups (the parks) with `length(unique(species))` - using `length(unique(variable_of_interest))` is generally useful when you want to know how many unique values a specific variable in your dataframe has. The `group_by` function was used because we are interested in the number of unique species belonging to *each park* - otherwise R would just give us one value of the total number of unique species present in *all 4 parks combined*.

From the output, we can see that we encountered 7 unique species in the Meadows and on Blackford Hill, and 17 in both Figgate and Craigmillar park. We can make a simple barplot to visualise this:

```{r}
(barplot<- ggplot (richness, aes(x= site, y=sp_richness)) +
 geom_bar(stat="identity"))
```

With only 4 sites, a barplot is not much different from the dataframe in terms of visualisation - however, they would be very useful if we were working with larger datasets, containing, let's say, 100 sites.

We can intuitively tell this number does not tell us too much - for example, what species were there? How much did the species composition overlap?

Could we use this number to compare the parks? Based on these values, we might intuitively say "Blackford Hill and the Meadows were less diverse, whereas Craigmillar and Figgate had more species, so they were less diverse". This, however, would be WRONG - since diversity as an ecological concept not only includes the number of species present at a given site, but also incorporates *how evenly the total abundance is distributed among these species.* We can say "we found 17 unique species in Figgate and Craigmillar, and 7 in the Meadows and Blackford" , **describing** each **individual site**- but species richness on its on is generally **not** the best way to make **comparisons between sites.**

This brings us to our next concept: Diversity indeces.

For this small dataset, you might say species richness is easy to calculate by hand - and you would be right! However, imagine working with large datasets, comparing large, and very rich communities - wouldn't it be better to just do it with a few lines of code?

# Diversity

Diversity indeces are considered more informative than species richness. There are many indeces out there, but a general feature of these formulas is that they incorporate species richness AND evenness - that is, how overall abundance is distributed among the species present.

For this tutorial, we will use Simpson's indeces. To make it a bit more complicated, we introduce 3 of them: Simpson's index of dominance, Simpson's diversity index, and Simpson's reciprocal index.

Let's calculate dominance first:

```{r}
parks_tidy %>% 
  group_by(site) %>% 
  summarise(simpsons_dominance = sum((abundance/sum(abundance))^2))
```

now, the last line of code may be a bit confusing - let's go through it step by step.

We want to know the value of *insert pic of simpsons dominance* for each park - so we grouped the data by site. The abundance values we use the third line therefore all correspond to abundance values *within* a site. With `sum((abundance/sum(abundance))^2)`, we are asking R to divide the *abundance of each species present in a park* by *the total number of individuals observed in that park*, then *square that value*, and finally add all these values for all species together. Hence the repeating of `sum` and `abundance`.

This should yield the output

```{r}
# A tibble: 4 × 2
  site        simpsons_dominance
  <chr>                    <dbl>
1 Blackford               0.144 
2 Craigmillar             0.217 
3 Figgate                 0.0638
4 Meadows                 0.456 
```

Great! Now let's make a summary table which includes all the indices we have introduced: species richness, Simpson's dominance, Simpson's diversity and Simpson's reciprocal diversity.

We can, of course, do this within one pipe:

```{r}
summary<-parks_tidy %>% 
  #calling our new dataframe "summary"
  group_by(site) %>% 
  # telling R we want all the values for each park separately
  summarise(sp_richness =length(unique(species)),
            #calculating species richness
            simpsons_dominance = sum((abundance/sum(abundance))^2), 
            # calculating dominance
            simpsons_diversity = (1-simpsons_dominance),
            #calculating diversity
            simpsons_reciprocal = (1/simpsons_dominance)) %>% 
            #calculating reciprocal index
ungroup()
# removing groupings
```

By looking at the summary table, we can see that it would have been wrong to only report species richness - Despite the fact that they accomodate the same number of species, Blackford Hill has a higher diversity index by *insert number* than the Meadows! Similary, despite both Figgate and Craigmillar having a species richness of 17, Figgate park is more diverse. Since these differences are not to do with richness, they must be a result of *evenness* - whether a few species are dominant, or whether abundance is relatively evenly distributed.

# Let's visualise - SAD diagrams

Based on the summary table, we concluded that despite there being only two values of species richness, the parks still differ in diversity. We hypothesized that this is due to differences in evenness.

It might be a good idea to try and visualise evenness. We will do this by making a simple SAD diagram for each park. Don't let the name fool you - SAD here stands for Species Abundance Distribution, and NOT how working in RStudio makes you feel. (Not at all. RStudio is always a happy, comforting place.) \*insert error message abt divergent transitions. Well, maybe *almost* always.

SAD models describe the distribution of population densities of the species present in a community. They display the number of species that are represented by 1,2,...n individuals in the community. For scientific purposes, this plot should be used only when the community is large and contains many species - clearly not true for our samples. However, for the purpose of this tutorial, it is perfectly fine to illustrate our data with a SAD diagram.

On graphs, SAD-s usually have abundance "classes" (how many individuals of a given species are present), and on the y axis, we have the frequency of each abundance class. The x axis usually has a log-scale. For the purpose of our "study", we won't do any log-transforms - as we are working with a small sample size. For more complex analyses, you would need to take this step.

*insert how sad diagrams usually look like*

For making a SAD diagram for each of our parks, we will first make a new dataset:one containing the *frequency of each abundance value WITHIN a site.* (For example, how many species in Figgate Park have an abundance of 10 individuals?)

For this, we make a new dataframe called parks_frequency.

```{r}
parks_frequency<- parks_tidy %>% 
  #making a new dataframe by passing parks_tidy through a pipe
  group_by(site, abundance) %>% 
  #we need to group by site, and WITHIN site, we need to group by abundance.
  summarise(frequency_of_abundance = length(species)) %>% 
  #making a new column for how often each abundance value occurs within each park
  ungroup()
  #removing groupings
```

For larger datasets, you would use abundance classes - add something??

With `length(species)`, we ask R to simply count the number of observations in the `species` column. The important part to note is that we already grouped the data into `site`, and within that grouping, to `abundance` - so R will count the number of `species` corresponding each abundance value within each site.

Great! We now have a new dataframe, based on which we will make our SAD graphs.

```{r}
(sad <- parks_frequency %>%  
    #calling our plot "sad" and making it by passing the dataset down a pipe
    ggplot(aes(x = abundance, y=frequency_of_abundance)) +
    #defining x and y axes
    geom_bar(stat="identity") +
    #telling R that we want a bar graph
    facet_wrap(~ site, scale = 'free'))
    #making a separate plot for each site, and allowing the x axis to vary for the    individual plots


```
