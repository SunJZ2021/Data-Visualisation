#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Packages needed: shiny, ggplot2, tidyverse, maps, ggrepel.
# maps: to create geographical maps
# ggrepel: automatically position non-overlapping text labels with ggplot2
library(shiny)
library(ggplot2)
library(tidyverse)
library(maps)
library(ggrepel)

# Load datasets and map data
data1 <- read.csv("data1.csv")
data2 <- read.csv("data2.csv")
map <- map_data("world")

# Define UI for application
ui <- fluidPage(

    # Application title
    titlePanel("Annual Working Hours, GDP per Capita and Labor Productivity"),

    # Sidebar and buttons (year and the variable on x-axis)
    sidebarLayout(
        sidebarPanel(width=3,
          radioButtons("x_v", 
                       "Select variable on x-axis:",
                       c("GDP per Capita" = 1,
                         "Labor Productivity" = 2)),
          br(),
          sliderInput("year", 
                      "Year:", 
                      min = min(data1$year), 
                      max = max(data1$year),
                      value = max(data1$year), 
                      step = 1),
          br(),
          radioButtons("x_c", 
                       "x:",
                       c("Linear" = 1,
                         "Log" = 2))
        ),

        # Output panel
        shinyUI(fluidPage(
          
          # The first plot 
          fluidRow(    
            column(9,
                   plotOutput("p1",width="1000px",height = "600px"))),
            
          # The second plot
          fluidRow( 
            column(3),
            column(9,
                   plotOutput("p2",width="1000px",height = "500px"))),
          )
          )
        )
    )

# Define server logic
server <- function(input, output) {
  
  # Set up the information about the variable on x-axis
  info <- reactive({
    
    if(input$x_v == 1){
      
      list(x = "rgdpo.pop",
           i = "pop",
           t1 = "Population",
           t2 = "GDP per Capita",
           xlab = "GDP per Capita")
      
      }else if(input$x_v == 2){
        list(x = "rgdpo..avh.emp.",
             i = "emp",
             t1 = "Population Engaged",
             t2 = "Labor productivity",
             xlab = "Labor productivity")
        }
    })
  
  # Make data we need in plot 1 and set up different cases (x is linear or log).
  df1 <- reactive({
    if(input$x_c == 1){
      
      # The data for the first plot in the case of x is linear:
      data.frame(x=data1[data1$year==input$year,][[info()$x]],
                 y=data1[data1$year==input$year,]$avh,
                 z=data1[data1$year==input$year,][[info()$i]],
                 c=data1[data1$year==input$year,]$continent,
                 na=data1[data1$year==input$year,]$country)
      
      }else if(input$x_c == 2){
        
        # The data for the first plot in the case of x is log:
        data.frame(x=log(data1[data1$year==input$year,][[info()$x]]),
                   y=data1[data1$year==input$year,]$avh,
                   z=data1[data1$year==input$year,][[info()$i]],
                   c=data1[data1$year==input$year,]$continent,
                   na=data1[data1$year==input$year,]$country)
        }
    })
  
  # Make data we need in plot 2 and set up different cases (x is linear or log).
  df2 <- reactive({
    if(input$x_c == 1){
      
      # The data for the second plot in the case of x is linear:
      data.frame(region = data2[data2$year == input$year,2],
                 z=data2[data2$year == input$year,][[info()$x]])
      
      }else if(input$x_c == 2){
        
        # The data for the second plot in the case of x is log:
        data.frame(region = data2[data2$year == input$year,2],
                            z=log(data2[data2$year == input$year,][[info()$x]]))
        }
    })
  
  # Parameters that setting the size of dots in the first plot:
  size <- reactive(list(m = max(df1()$z),
                        n = min(df1()$z),
                        v = mean(df1()$z)/mean(data1[data1$year==2019,][[info()$i]])*3))
  
  # The data of countries which are showed (population or population engaged >= 1/3
  # *average population or population engaged) in the first plot:
  label_df <- reactive(df1() %>% filter(df1()$z >= mean(df1()$z)/3))
  
  # Combine the original map data and the data for the second plot (df2) together:
  mapdata <- reactive({
    left_join(map, df2(), by="region")
    })
  
  # Make the first plot:
  output$p1 <- renderPlot({
    
    ggplot(data = df1(),
           mapping = aes(x=x, y=y))+
      geom_point(shape=21,colour="gray30",
                 aes(fill=factor(c),size=z))+
      geom_text_repel(data = label_df(),
                      mapping = aes(x,y,label=na),
                      max.overlaps=20,
                      size=4,colour="gray65")+
      scale_fill_manual(values = c("Africa"="grey38",
                                   "Americas"="indianred1", 
                                   "Asia"="lightgoldenrod1",
                                   "Europe"="skyblue2",
                                   "Oceania"="green"))+
      theme_bw()+
      scale_size_continuous(range=log(range(df1()$z)/size()$m*9000)*size()$v,
                            breaks=seq(size()$n,size()$m,(size()$m-size()$n)/4))+
      stat_smooth(method = 'loess',formula="y~x")+
      labs(x=info()$xlab, y="Working Hours")+
      theme(legend.position="bottom")+
      guides(size=guide_legend(order=1,
                               direction="horizontal",
                               title=info()$t1),
             fill=guide_legend(order=0,
                               direction="vertical",
                               title="Continents"))
    })
  
  # Make the second plot:
  output$p2 <- renderPlot({
    
    ggplot(mapdata(), aes(x = long, 
                          y = lat, group=group)) +
      geom_polygon(aes(fill = z), color = "black")+
      scale_fill_gradient(name = info()$t2,
                          low = "blue",
                          high = "red",
                          na.value = "#B0C4DE") +
      theme(axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks = element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            rect = element_blank())
    })
  }

# Run the application 
shinyApp(ui = ui, server = server)
