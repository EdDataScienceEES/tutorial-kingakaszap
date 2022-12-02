  # <p align = "center">   Describing communities in R </p>
  
*<p align ="center"> A tutorial by Kinga Kaszap </p>*

# Tutorial Aims:

1. Learn how ecological communities can be described in R
2. Undestand basic indices such as richness and diversity, and learn how to calculate them in R
3. Learn the basics of visualising community composition

# Tutorial Steps

 #### <a href="#section1"> 1. Introduction</a>
 #### <a href="#section2"> 2. Setting the scene</a>
 #### <a href="#section3"> 3. Importing and tidying field data</a>
 #### <a href="#section4"> 4. Species richness</a>
 - calculating richness
 - visualising differences in species richness
 #### <a href="#section5"> 5. Calculating diversity indices</a>
 - Simpson's dominance
 - Shannon-Wiener diversity index
 - Making a summary table
 #### <a href="#section6"> 6. Basic visualisation - SAD diagrams</a>
 #### <a href="#section7"> 7. A bit more complex visualisation - Rank-Abundnce diagrams</a>
 #### <a href="#section8"> 8. Summary</a>

<a name="section1"></a>
# 1. Introduction

This tutorial will introduce some basic methods of describing and comparing biological communities using R. It builds on some methods and concepts used in community ecology, but if you've never done community ecology before, that's also fine! The concepts used are relatively simple, and will be explained in detail in the tutorial. The tutorial is aimed at beginners, but expects you to have downloaded RStudio and are somewhat familiar with its layout. If you are completely new to R and RStudio, check out this tutorial! (Insert coding club reference) We will also be making plots to visualise our data with ggplot. The terminology used when plotting with ggplot takes practice to grasp, and since it is not the main focus of this tutorial, it is not explained in detail. So don't worry if that bit is slightly confusing! If you're interested in data visualisation, check out [this](https://ourcodingclub.github.io/tutorials/datavis/) coding club tutorial.

All the material you need to complete this tutorial can be found in [this repository](https://github.com/kingakaszap/describing_communities). Click on `Code/ Download ZIP` and unzip the folder, or clone the repository to your own GitHub account.

<a name="section2"></a>
# 2. Setting the scene
![irina-iriser-2Y4dE8sdhlc-unsplash](https://user-images.githubusercontent.com/114161055/205040811-c8287fc2-2730-491f-94f1-7935a9ac327f.jpg)
*Photo by Irina Iriser on Unsplash*

Have you ever wondered how communities occupying different habitats (or micro-habitats) vary? Or whether habitat types vary in the number of species they accomodate? For example, how your backyard might differ from the nearby forest?

...

No? Maybe it's just me then. Anyway, community ecology is a fascinating branch of biology, and on the large scale, can be used to answer some of the most pressing questions of our days:

-   How is biodiversity distributed in the world?
-   And how is it changing? In more practical terms, what tools do we have to answer those questions?

In this tutorial, to keep it simple and easy to grasp, we are using a small scale. But the basic concepts introduced can be applied on the global scale as well. Of course, this comes at the cost of using way more complicated equations, like this:

<img src="https://user-images.githubusercontent.com/114161055/204779399-bda43e61-5647-4162-a74b-b0a816ff0dd5.png" alt="image" width="364"/>
*(from Jost et al 2006)

Don't worry, since our scale is small and the aim of this tutorial is to introduce you to the basic, the equations we use will be a lot easier to understand.

Let's get started!

For the purpose of this tutorial, imagine that you are a field ecologist, and have been asked by Edinburgh City Council to compare how greenspaces differ in the type and quality of habitat they provide to birds. You work on four main sites: Blackford Hill and the Hermitage, the Meadows, Figgate park and Craigmillar park. You think: this is easy! I'll just go with my binoculars, have a hot chocolate (or coffee, if you prefer), and record what species I see in each park, and how many individuals of each.

But then what?

What values do you report to the council when describing each park? How do you make comparisons between the habitats they provide?

Let's begin...

Here is a picture I took at Blackford Pond when conducting a very similar project:
<p align="center">
<img src="https://user-images.githubusercontent.com/114161055/205041839-6050f8fb-c133-405f-b917-482378c53631.jpg" alt="image" height="480"/></p>



<a name="section3"></a>
# 3. Importing and tidying field data

In ecology, there is usually a big difference between the format observations are recorded in the field, and the format a programming language such as R requires to be able to work with your data. Say you collected your data on paper, trying to make somewhat of a table, while also adding notes to your observations. You had to be quick though, because the objects you observe (the birds) move quickly (how annoying!) So it is definitely not the neatest of tables. You copied your observations into Excel, exactly in the same format as you recorded them, to reduce copying errors. Now you want to start working with your data...

Open RStudio, and click on `File/New File/R Script`. If you are completely new to R, check out [this](https://ourcodingclub.github.io/tutorials/intro-to-r/) tutorial to get started - I promise it's not difficult! (In the beginning. Then it does get difficult. But let's not talk about that.)

It is good practice to "introduce your code" - so that anyone who may look at it knows immediately whose work it is, when was it created, and for what purpose. It is also useful if you ever want to look back on your work, or find a specific script. In RStudio, you can add comments using a hashtag ( `#` ). R will interpret this as text and not attempt to run it as code.

 ``` r
    # Describing communities  (feel free to add a different title!)
    # Your Name
    # Date
    # Any other short comments you want to add to the introduction
 ```

Now, before we import our data, we need to set our working directory. This is a folder on your computer where all your work, including this script, data, plots, etc) should be saved. You can set your working directory manually by clicking on `Session` on the top left, and choosing `Set working directory/Choose directory`. However, you can also do it with code:

``` r
setwd ("your/file/path") #enter the filepath to the working directory you want to work in

getwd() #check that your working directory is where you wanted it 
```

Before we start working with our data, we will load the packages we will be using throughout the script. For this tutorial, you only need two. If you already have these packages installed, just load them with the `library` command. If you haven't used them before, you will need to install them first:

``` r
install.packages ("tidyverse")
install.packages ("ggthemes")
```

It is generally considered bad practice to type code directly into your console in R, as those code chunks will not be saved in your script. However, you can make an exemption with `install.packages` - you can type the commands above directly into the console so that R doesn't try to install them everytime you run the code. Alternatively, you can put a `#` before the commands once you have ran them.

``` r
# load libraries
library (tidyverse) # contains packages dplyr for efficient data manipulation,
# tidyr for data wrangling
# ggplot2 for pretty data visualization
# and more...
library (ggthemes) # we will use ggthemes to add a cool theme to our graphs
```

Let's import the dataset. This is a fake dataset created for this tutorial, but let's imagine it's the actual field data of your bird observations you collected in the parks. The dataset is in the ZIP folder you downloaded earlier, in the "data" folder under the name `field_data.csv`. You can import it manually with clicking on *Import dataset* -\> *From Text (base)*. But, of course, you can also do it with code.

``` r
# Import the dataset
parks<- read.csv("~Desktop/Users/Kinga/Tutorial/field_data") # Enter your own filepath here.
# the dataset is now assigned to a dataframe object called "parks".
```

The dataset should appear in the environment section of RStudio. With using `<-`, we assigned it to a dataframe called `parks`.

Let's have a look at our data!

``` r
# explore data

glimpse (parks) #literally have a glimpse of our data
head (parks) # first few observations
names (parks) #column names
```

Now we have a feel of our data. The `glimpse` function tells us we have 4 rows (one row for each site), and 21 columns. We can also see that the column names 2-21 are the bird species we observed (one for each species), and the columns themselves contain the abundance of said birds in each park, if they were present, plus field notes ( like `5(could be morhen)`). `R` also tells us the what type of data it thinks each column is - we can see that some of our columns contain character (`<chr>`), while others integer (`<int>`) variables.

Overall, the data looks quite messy - and wide. (21 columns is a lot for such a small dataset).

Let's do some data wrangling ! We need our data to be in a very specific format to efficiently work with them in `R`. We need to convert the dataset into *long* format - where each row shows an observation, and each column represents a variable. We also want to make it *tidy* - get rid of any N/A values, and make sure each column only contains one type of variable.

In our data, our variables for each observation are: Park (Where was the observation recorded?), Species (What bird are we talking about?) and Abundance (How many individuals of said bird did we count in the specified park?). So, we have to shorten our dataset to 3 columns instead of the current 21. We can leave the first column alone, but we need to do some work on columns 2:21!

We clean our data in one command with using dplyr's *fabulous* pipe ( `%>%`) operator. (Honestly, they make your life (and code) so much easier! Learn more about `dplyr` and pipes [here](https://ourcodingclub.github.io/tutorials/data-manip-efficient/).

``` r
parks_tidy <- parks %>% 
gather(species, abundance, c(2:21)) %>% 
# organizing into long format, where individual counts (value) are gathered by species (key)
mutate (abundance = parse_number(abundance)) %>% 
#turning values in the abundance column into numeric - this function removes notes like "???" and "maybe more"
na.omit()
#removing NA-s
```

Let's view our clean dataset! Note: The `View` function works perfectly in our case, as we have a small dataset, but for larger datasets, the functions we used before to explore our data ( such as `glimpse`) can give more information about the dataset.

``` r
View(parks_tidy) # see how our dataset looks like now
```

Looks good! There are only 3 columns, like we wanted, and the `abundance` column is now numeric. We don't have any N/A-s either. We can see that the number of rows increased from 4 to 44 - there is a reason why this is called "long format"...

<a name="section4"></a>
# 4. Calculating species richness

Right! Our data is in a tidy format. Now we can start working on it, and start extracting information on the community composition of birds in each parks- after all, that's what the City Council pays us for!

The most basic index characterizing communities is *species richness*. It merely describes the number of different species present at a site. You might think of it as an useful value to report to the Council. The basic question we can answer with this index is "Is there a difference between the number of species found in each park ?"

For easy visualization, we will make a new dataframe containing the richness values of each park. To calculate richness for each park separately, we use the `group_by` function - this tells `R` that we want separate richness values for each parks, and assigns abundances to sites. We then calculate richness with combining two commands: `length` and `unique`. `unique(species)` collects the different names in the `species` column of the dataframe. `length` then calculates how many unique species there are. Using `length(unique(variable_of_interest))` is generally useful when you want to know how many unique values a specific variable in your dataframe has.The `summarise` function then returns the calculated `sp.richness` values only.

``` r
(richness <- parks_tidy %>% 
# create the new dataframe by passing the tidy data through a pipe
  group_by(site) %>% 
# grouping data into parks
  summarise(sp.richness = length(unique(species))) %>% 
# calculating richness 
ungroup()
# it is good practice to remove any groupings at the end of your pipe.
)
# By putting the entire code in brackets, the dataframe is displayed immediately in the console.
```

For this small dataset, you might say species richness is easy to calculate by hand - and you would be right! However, imagine working with large datasets, comparing large, and very rich communities - wouldn't it be better to just do it with a few lines of code? From the output, we can see that we encountered 7 species in the Meadows and on Blackford Hill, and 17 in both Figgate and Craigmillar park. We can make a simple barplot in `ggplot` to visualise this:

``` r
(barplot_richness<- ggplot (richness, aes(x = site, y = sp.richness, fill = site)) +
    # setting the x and y axes, and asking R to use different colors for each park
    geom_bar (stat = "identity") +
    # specifying that we want a barplot ?
    labs (x = "\nPark", y = "Species richness\n") +
    # giving informative names to the axes
    theme_few() +
    # adding a theme from ggthemes - feel free to add a different one!
    scale_fill_brewer (palette = "Accent") + 
    #adding a color palette - feel free to add a different one!
    theme (legend.position = "none",
    # removing the legend as the axes provide enough information 
    axis.text = element_text(size = 14), 
    axis.title = element_text(size = 16),
    #increasing font size
    axis.text.x = element_text(angle = 45, hjust = 1)))
    #tilting the text of the x axis
```
<p align="center">
<img src="barplot_richness.png" alt="image" width="450"/>
</p>

With only 4 sites, a barplot is not much different from the dataframe in terms of visualisation - however, it would show be more if we were working with larger datasets, containing, let's say, 100 sites. Remember that the aim of this tutorial is just to introduce you to exploring community composition - hence why our dataset is simple and small! Also, it's kind of amazing how `ggplot` can make and customize plots from basically nothing. If you are also fascinated by `ggplot`, check out [this](https://ourcodingclub.github.io/tutorials/datavis/) coding club tutorial on making beautiful figures!

For now, let's save our plot - we can also do this with code using `ggsave` and entering the folder within the working directory we want to save it to.

``` r
ggsave(barplot_richness, file="background/barplot_richness.png", width= 6, height=6)
#save our plot - don't forget to enter your own filepath!
```

We can intuitively tell these values don't tell us too much - for example, what species were there? How much did the species composition overlap?

Could we use this number to compare the parks? Based on these values, we might say "Blackford Hill and the Meadows were less diverse, whereas Craigmillar and Figgate had more species, so they were more diverse". This, however, would be WRONG - since diversity as an ecological concept not only includes the number of species present at a given site, but also incorporates *how evenly the total abundance is distributed among these species.* We can say "we found 20 unique species in Figgate and Craigmillar, and 7 in the Meadows and Blackford" , **describing** each **individual site**- but species richness on its on is generally **not** the best way to make **comparisons between sites.** We should also be careful with saying " Craigmillar Park and Figgate Park have similar community composition because both have a species richness of 17 ". Despite having identical species richness, the way communities are assembled may still be very different among sites.

This brings us to our next concept: **Diversity** .

<a name="section5"></a>
# 5. Diversity

Diversity indices are considered more informative than species richness. Diversity incorporates both richness and comonness and rarity of species - evenness. It accounts for how many species can be found at a site, and also how individuals within the community are distributed among species. There are many diversity indices out there, and it's a hot topic in science which is best. For this tutorial, we will use two of the most simple and basic measures of diversity: the Shannon-Wiener diversity index (H') and Simpson's index of dominance (D).

Simpson's dominance focuses on common species, and as the name suggests, it's most useful for determining dominance. It gives us a probability that if we randomly point at two individuals in a given community, they will belong to the same species. As it is essentially a measure of probability, it ranges between 1 (high dominance) and 0 (low dominance). The reciprocal of D, 1/D can be used as a measure of diversity, and is not surprisingly called *Simpson's reciprocal index*.

The *Shannon-Wiener diversity index* or *Shannon's diversity* tells us about rare species. It is less sensitive to sample size than Simpson's reciprocal, and it is the most popular index to determine diversity.

Something all diversity indices have in common is that they work with *relative abundance*. This value is specific to each species, and indicates how common or rare a given species relative to others. It is calculated as the number of individuals belonging to a given species divided by the number of all individuals present in the area. Relative abundances in a community should add up to 1.

Based on relative abundance, Simpson's dominance is given by the following formula:

<img src="https://user-images.githubusercontent.com/114161055/204814382-a2e97f90-de4e-4c7b-b385-f15df2d2a9a7.png" alt="image" width="200" height="100"/>

where (Pi) stands for relative abundance.

Also using relative abundance, Shannon's diversity is determined as

<img src="https://user-images.githubusercontent.com/114161055/204815826-0d2819ee-7af1-42ac-a0fe-ff2f29970dbd.png" alt="image" width="200" height="90"/>

We will first add a new column to our existing `parks_tidy` dataframe for relative abundance of each species within the four parks.

``` r
parks_tidy <- parks_tidy %>%
  # we don't need to make a new dataframe as we are only adding a column,
  # not changing any of the existing ones.
  group_by(site) %>% 
  mutate(relative.abundance = abundance/sum(abundance)) %>% 
  # creating a new column 
  ungroup()
  # removing groupings
```

Note that **it's usually bad practice to overwrite the dataframe when we change things in it, and it's recommended that you make a new dataframe and keep the previous one**. However, in this instance that would be redundant as we are not altering or removing any columns, only adding a new column based on existing ones. So here, we can overwrite the dataframe, by passing our old object down a pipe, and assigning the new object the same name as the old one.

Let's calculate dominance first:

``` r
parks_tidy %>% 
  group_by(site) %>% 
  summarise(simpsons.dominance = sum(relative.abundance^2)) %>% 
  ungroup()
```

This should yield the output

<img src="https://user-images.githubusercontent.com/114161055/204817971-fb60be6a-374e-4753-a1de-662b99ff6c6f.png" alt="image" width="330"/>

Now let's calculate Shannon's diversity:

``` r
parks_tidy %>% 
  group_by(site) %>% 
  summarise(shannons.div = -sum(relative.abundance*log(relative.abundance))) %>%
  ungroup()
```
for which you should get

<img src="https://user-images.githubusercontent.com/114161055/204818496-bd0b29af-4496-4ff9-becf-b0e842cae8d2.png" alt="image" width="320"/>

Great! Now let's make a summary table which includes all the indices we have introduced: species richness, Simpson's dominance and Shannon's diversity. We can, of course, do this within one pipe:

``` r
summary<- parks_tidy %>% 
#calling the new dataframe "summary"
  group_by(site) %>% 
  # grouping the data into parks
  summarise(sp.richness = length(unique(species)),
            shannons.diversity = -sum(relative.abundance*log(relative.abundance)),
            simpsons.dominance = sum(relative.abundance^2)) %>% 
  # calculating all indices
  ungroup()
  # removing groupings

View(summary)
# having a look at our summary table
```

The summary table should look like this:

<img src="https://user-images.githubusercontent.com/114161055/204820676-43632500-91d4-4010-b271-b1370a9b88cf.png" alt="image" width="616"/>

By looking at the summary table, we can see that it would have been wrong to only report species richness - Despite the fact that they accomodate the same number of species, Blackford Hill has a diversity around 30% higher than the Meadows! Similary, despite both Figgate and Craigmillar having a species richness of 20, Figgate park is 30% more diverse. Since these differences are not to do with richness, they must be a result of *evenness* - whether a few species are dominant, or whether abundance is relatively evenly distributed. If we look at the values of Simpson's dominance, they seem to support this point. The most striking is the difference between Figgate and Craigmillar - even though they have the same number of species present, the dominance for Craigmillar is more than 3.5 times the value for Figgate Park!

But these indices are difficult to interpret from just a number - and looking at tables must be quite boring by now.

Let's visualise!

<a name="section6"></a>
# 6. Basic visualisation - SAD diagrams

Based on the summary table, we concluded that despite the fact that we only observed  two values of species richness, the parks still differ in diversity. Since diversity is determined by richness and evenness, and richness is identical for the two "pairs" (Meadows & Blackford, and Craigmillar & Figgate), the differences must be in evenness. Species evenness is highest when all species in a sample have a similar abundance, and approaches zero if one or more species is dominant in the community, or if there is a large variation in abundances of different species.

It might be a good idea to try and visualise evenness. We will first do this by making a simple SAD diagram for each park. Don't let the name fool you - SAD here stands for Species Abundance Distribution, and NOT how working in RStudio makes you feel. Not at all. RStudio is always a happy, comforting place.

...

<img src="https://user-images.githubusercontent.com/114161055/205046446-e537867b-4fd5-4010-b582-238f1e6460f0.png" alt="image" height="300"/>

Well, maybe *almost* always.

Anyway, SAD diagrams describe how total abundance is distributed among species in the community. They display how many species that are represented by 1,2,...n individuals, with "abundance (classes)" on the x axis and "number of species" on the y axis. For scientific purposes, this plot should be used only when the community is large and contains many species - clearly not true for our samples. However, for the purpose and level of this tutorial, it is perfectly fine to illustrate our data with a SAD diagram. SAD-s usually have abundance "classes" (how many individuals are observed) on the x axis, and the frequency of each abundance class on the y axis (how many species fall within the "class", i.e. how many species has an abundance of, say, 5). The x axis usually has a log-scale. For the purpose of our "study", we won't do any log-transformations - as we are working with a small sample size. For more complex analyses, you would need to take this step.

This is how a SAD diagram with log scale would look like - we will just stick to the basics. 

<img src="https://user-images.githubusercontent.com/114161055/205047016-857e8793-8845-4c67-9bed-f3cff20535dd.png" alt="image" height="300"/>

*image sourced from Khaluzny et al. 2015*


For making a SAD diagram for each of our parks, we will first make a new dataset: one that contains the *frequency of each abundance value WITHIN a site.* (For example, how many species in Figgate Park have an abundance of 10 individuals?)

For this, we will create a new dataframe called parks_frequency.

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

With `length(species)`, we ask R to simply count the number of observations in the `species` column. The important part to note is that we already grouped the data into `site`, and within that grouping, to `abundance` - so R will count the number of `species` corresponding each abundance value within each park.

Great! We now have a new dataframe, based on which we will make our SAD graphs. Instead of making a separate graph for each site "by hand", which would be tedious and long, we will use `facet_wrap` to do that for us.

``` r
(sad <- parks_frequency %>%  
    # calling our graph sad
    ggplot(aes(x = abundance, y = frequency_of_abundance, fill = site)) +
    geom_bar(stat = "identity") +
    # specifying that we want a bar graph
    theme_tufte()+
    facet_wrap(~ site, scale = "free") +
    # making separate plots for sites, and allowing the scales (x and y axes to vary)
  labs(x = "\nNumber of individuals", y = "Number of species\n")+
  # giving informative names to the axes
  theme_few()+
  # adding a theme from ggthemes - feel free to add a different one!
  scale_fill_brewer(palette = "Accent") + 
  # adding a color palette - feel free to add a different one!
  theme(legend.position = "none",
        #removing the legend as the axes provide enough information 
        axis.text = element_text(size = 14), 
        axis.title = element_text(size = 16)))
        #increasing font size
```

This is how our plot looks like:

<img src="https://user-images.githubusercontent.com/114161055/204835023-7a553909-a56d-4561-8395-62c5b2f744a0.png" alt="image" width="400" height="400"/>

Interesting. Definitely not the best plot - what are those gaps doing in the Meadows and Craigmillar? Also, why is Figgate just one big block? Worry not - this all has to do with oversimplification, and the `scale = free` command. In real life, log-transformation and abundance classes instead of discrete numbers are used so that there are no "empty gaps" like in our Meadows and Blackford plots. And using a uniform scale would get rid of the "block" that currently represents Figgate park. But we will not bother with that - there are still many inferences we can make from our graph.

Let's save it first:

``` r
ggsave(sad, file =" background/sad.png", width = 6, height = 6)
# save our plot - don't forget to enter your own filepath!
```

These plots represent *evenness* - and intuitively, based on the bars, we can tell that Figgate is *very even* - that is, there are only 4 abundance classes present, and an equal number of species belong to each - it is the equal height of the bars that make that plot look like a block. How unlikely! Maybe, just maybe this surprising evenness has to do with the fact that we are working with a fake dataset? Who knows. Anyway, the differences shown by our indices in the previous part are now also more apparent - there is certainly a big difference between the SAD graph for Figgate and Craigmillar, and those for Meadows and Blackford. Figgate and Blackford have a relatively even species composition, whereas the other two look very uneven - most species have only one individual present, and there one species dominates - by having an abundance of 30 individuals in Craigmillar and 10 in the Meadows.

Still, there might be a better way to visualise evenness. That brings us to the last section of this tutorial - Rank-Abundance plots.

<a name="section7"></a>
# 7. A bit more complex visualisation - Rank-Abundance diagrams

Let's have a look at how we can plot the same data a different way! A common way to visualise community composition is creating Rank-Abundance diagrams. These are similar to SAD graphs as they visualise evenness and commonness/rarity. Species are assigned a **rank** based on abundance, with most abundant ranked 1 and least abundant S (where S is the number of species in the community). Like our diversity indices, rank-abundance requires a knowledge of the **relative abundance** of each species. We then plot relative abundance against rank to visualise the community. This way, we will get rid of the annoying gaps present in the previous graphs, and are able to visualise richness as well as evenness, as we have individual species, represented by their rank on the x axis!

Since this is a general tutorial, and it is already getting too long, we will only include the very basics of rank-abundance diagrams. However, if you want to know more about them, and how to make them prettier, or starting from scratch, check out [this](https://darahubert.github.io/rank-abundance-tutorial/) tutorial.

To make the plots, we will first make a new dataframe containing columns for a) relative abundance in percentages and b) ranks assigned to each species. As with everything before, we want to retrieve these values separately for each park, as we want to compare between them.

``` r
parks_rankabundance <- parks_tidy %>% 
# making new dataframe for rank abundance plots
  group_by (site) %>% 
  mutate(rel.abund.percent = relative.abundance * 100,
  # adding new column for % relative abundance  
         rank = (rank(- abundance, ties.method="random"))) %>% 
         # new columnn for rank  
  ungroup()
  # remove groupings
  
```

Above, we used `mutate` to make new columns. Within the `mutate` command, we used `rank` and `-` to rank abundances in descending order. As each species should have a unique rank for our plots, we used `ties.method="random"` to assign a rank at random between species with equal number of individuals.

You might remember that before, we did not make a new dataframe when we added a column. However, we did now to keep the original dataframe concise - as rank is not really a relevant metric for any other purpose than making these plots, whereas the relative abundance column we added when we overwrote the tidy dataframe was used continuously throughout the tutorial.

One last thing to note before we make our final plot is the `ungroup()` function. You might have noticed that at the end of **each pipe**, we ungroup the dataset. Since we group by `site` in nearly all cases, this might seem counter-intuitive - why remove the grouping if we are going to regroup again? The simplest answer is to avoid confusion - when we group by a variable, the way the dataset looks like in the RStudio interface doesn't change - in other words, only R "knows" how it is grouped. This way it is *very easy* to confuse yourself and lose track of how your data are grouped, and get really annoying errors. To avoid this, it's generally good practice to remove any groupings at the end of your pipes.

Now, let's make our plots!

``` r
(rank_abundance_plots <- parks_rankabundance %>% 
  ggplot (aes (x = rank, y = rel.abund.percent)) +
  # specifying the x and y axes
  geom_point (aes (color = species, fill = species), size = 2) +
  # specifying that we want a scatter plot
  geom_line (colour= "black") +
  # adding a line connecting the points
  labs (x = "\nRank", y = "Relative abundance (%)\n") +
  facet_wrap (~site) +
  # making separate plots for sites
  theme_few() +
  # adding a theme from ggthemes - feel free to add a different one!
  theme (legend.position = "none"))
  # removing the legend as the axes provide enough information
```
Note that unlike for the SAD diagrams, we did not include `scale = free` in the `facet_wrap` bracket - this means that all four graphs have the same scale on the x and y axes. This allows for better comparison, however, with the already imperfect SAD plots (remember the gaps and the block that is Figgate? Maybe there is something in the name after all...), not allowing scales to vary would have made our plots look even more clustered and odd. 

You should now have this plot:

<p align="center">
<img src="rankabundance.png" alt="image" width="500" height="500"/>
</p>

Let's interpret this! On the x axis, we have ranks - species ranked from most to least abundant within each park. On the y axis, we have relative abundance, again, within parks - so the position of, say, the first "dot" tells us the relative abundance of the most abundant species (assigned rank 1), the second about the relative abundance of the second most abundant species, and so on. In other words, it tells us *how dominant* the most abundant species is in the environment. 

I mentioned before that we can also infer richness from these graphs - indeed, the number of species present is represented by the number of dots in each graph. We can see what we already know from the previous sections: that Figgate and Craigmillar have more species than the Meadows and Blackford. However, we can also intuitively tell about evenness (Probably more intuitively than from the SAD graphs). It is not hard to tell that since the line connecting the dots is straight, or nearly straight in the case of Blackford and Figgate, individuals are evenly distributed among species in these parks. However, the large drop between the first and the second dot in the graphs for Craigmillar and the Meadows show that these communities are uneven, and have one **highly dominant** species. 40% of all individuals belong to the same species in Craigmillar, *despite there being 20 species present*, and half of the birds observed in the Meadows were the same species. 

Let's save our plot:

``` r
ggsave(rank_abundance_plots, file = "background/rank_abundance.png", width = 6, height = 6) 
# add your own filepath
```
<a name="section8"></a>
# 8. Summary

Well done for making it this far! There's not much left to do but to summarize what we learnt - and, of course, make the report for the City Council! In this tutorial, we learnt the basics of describing communities in R, including...

- How to import field data into `RStudio` and convert it into a tidy format.
- How to describe communities using species richness - and why that might not be the best metric to compare sites.
- How to describe and compare communities using diversity indices
- How to make a SAD diagram, and the drawbacks of using this graph with a small sample size
- How to visualise community composition with rank-abundance diagrams, and how to infer them.


#

#### Check out our <a href="https://ourcodingclub.github.io/links/" target="_blank">Useful links</a> page where you can find loads of guides and cheatsheets.

#### If you have any questions or comments about this tutorial, please contact me on s2024589@ed.ac.uk

<ul class="social-icons">
	<li>
		<h3>
			<a href="https://twitter.com/our_codingclub" target="_blank">&nbsp;Follow our coding adventures on Twitter! <i class="fa fa-twitter"></i></a>
		</h3>
	</li>
</ul>


