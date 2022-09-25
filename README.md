# Data Visualisation: Relationship between Annual Working Hours and GDP per Capita, Relationship between Annual Working Hours and Labor Productivity
## University of Sheffield, MAS286 Assignment 3 Code

The amount and complexity of data have increased since the advent of the big data era. However, in the form of data frames, it is difficult for ordinary people to obtain relevant information quickly and accurately. By transforming invisible data phenomena into visible graphic symbols, this project provides a straightforward answer to the questions, "Do workers in richer countries work longer hours?" and "Do workers in higher labour productivity countries work longer hours?"

The data comes from a website called **Penn World Table version 10.0** and is available at https://www.rug.nl/ggdc/productivity/pwt/.

This project is a group work with 4 teammates. Our work was inspired by a similar visualisation on **Our World in Data** available at https://ourworldindata.org/grapher/annual-working-hours-vs-gdp-per-capita-pwt, and one part of our work is to reproduce that visualisation which is allowed by the module MAS286.

Here are two *shiny* apps, **GDPvsH** and **GDPvsH_al**. The difference is that **GDPvsH** uses the package *ggpubr*, combining two plots into a single *ggplot2* object, in order to set the layout of the output, while **GDPvsH_al** uses only the package *shiny* to set the layout. 
