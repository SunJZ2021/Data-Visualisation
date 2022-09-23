# Data Visualisation: Relationship between Annual Working Hours and GDP per Capita, Relationship between Annual Working Hours and Labor Productivity
## University of Sheffield, MAS286 Assignment 3 Code

This data visualization project mainly attempts to address the question “Do workers in richer countries work longer hours?”. Hence, the relationship between annual working hours and GDP per capita in each country was first looked at. (Through the change in time, it is more intuitive to judge whether there is a certain connection between the GDP growth and average working hours of a country.) A further question, “Do workers in countries with higher labor productivity work longer hours?”, may be asked. Therefore, the relationship between annual working hours and labor productivity was also dug into.

The data comes from a website called **Penn World Table version 10.0** and is available at https://www.rug.nl/ggdc/productivity/pwt/.

This project is a group work with 4 teammates. Our work was inspired by a similar visualisation on **Our World in Data** available at https://ourworldindata.org/grapher/annual-working-hours-vs-gdp-per-capita-pwt, and one part of our work is to reproduce that visualisation which is allowed by the module MAS286.

Here are two *shiny* apps, **GDPvsH** and **GDPvsH_al**. The difference is that **GDPvsH** uses the package *ggpubr*, combining two plots into a single *ggplot2* object, in order to set the layout of the output, while **GDPvsH_al** uses only the package *shiny* to set the layout. 
