---
editor_options: 
  markdown: 
    wrap: 72
---

# Tutorial Aims:

1.  Setting the scene
2.  Importing and tidying field data
3.  Species richness
4.  Species diversity
5.  Basic visualisation - SAD diagrams \*\*\*\*\*\*

This tutorial will introduce some basic methods of describing and
comparing biological communities using R. It builds on some methods and
concepts used in community ecology, but if you've never done community
ecology before, that's also fine! The concepts used are relatively
simple, and will be explained in detail in the tutorial.

# Setting the scene

Have you ever wondered how different communities of different habitats
(or micro-habitats) differ? How they vary in the number of species they
accomodate? For example, how your backyard might differ from the nearby
forest?

...

No? Maybe it's just me then. Anyway, community ecology is a fascinating
branch of biology, and on the large scale, can be used to answer some of
the most relevant questions of today: How is biodiversity distributed in
the world? And how is it changing? In more practical terms, what tools
do we have to answer those questions?

In this tutorial, to keep it simple, we are using a small scale. But the
basic concepts introduced (combined with wayyy more complicated
equations, see *insert horrible equation*) work for the global scale as
well. Here, imagine that you are a field ecologist, and have been asked
by the Edinburgh City Council to compare how greenspaces differ in the
type of habitat they provide to birds. the communities of birds
different greenspaces of the city support. You work on four main sites:
Blackford Hill and the Hermitage, the Meadows, Figgate park and
Craigmillar park. You think: this is easy! I'll just go with my
binoculars, have a hot chocolate (or coffee, if you prefer), and record
what species I see in each park, and how many individuals of each.

But then what?

What values do you report when describing each park? How do you make
comparisons between the habitats they provide?

Let's begin...

# Importing and tidying field data

In ecology, there is usually a big difference between the format
observations are recorded in the field, and the format a programming
language such as R requires to be able to work with your data. Say you
collected your data on paper, trying to make somewhat of a table, while
also adding notes to your observations. You copied your observations
into Excel, exactly in the same format, to reduce copying errors. Now
you want to start working with your data...

-   First, open RStudio,

-   set up working directory

-   import data (CSV? Excel?)

Loading libraries

Before we start working with our data, we need to load the libraries we
will be using throughout the script.

```{r}
library(dplyr) # for efficiently manipulating data 

library(ggplot2) # for making nice graphs
```

-If you don't have these packages, run

```{r}
install.packages (dplyr)
```

and

```{r}
install.packages(ggplot2)
```

in your console (insert pic pointing at console) (so R doesn't
re-install the packages each time you run the code).

Let's import our data.

```{r}
parks<- read.csv("datasets/parks1.csv") #will have to change that depending on whether i can do a csv file and add filepath
```

The dataset should appear in the environment (insert pic) section of
RStudio. With using `<-`, we assigned it to a dataframe called `parks`.

Let's see what we have here!

```{r}
glimpse(parks)
head(parks)
names(parks)
```
