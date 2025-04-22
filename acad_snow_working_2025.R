####ACAD Snow Working Visuals#### 
####Author/POC: Miriam Ritchie 
####Sarah Nelson updated to plot snow depth (03/26/2025), correct a few typos in comments (04/22/2025),  
 ####  and increase font size in graph (4/22/2025) during paper revision (snelson@outdoors.org)
####R Version: 4.3.0 (2023-04-21 ucrt) -- "Already Tomorrow
####R Studio Version: 2023.03.0 -- "Cherry Blossom"
###Summary:This script reads in the snow and station data and rectifies the time 
###gap in the sampling dates. It then calculates the mean snow depth and standard error
###for each canopy density type for each date. The script then creates a plot using
###ggplot2 in order to visualize the mean snow depth over time. An interactive 
###version of this plot can be viewed for visual inspection of the data. The plot
###is then saved to the working directory as a png file. 

#Load required packages
library(plyr)
library(dplyr) 
library(flextable)
library(gt)
library(tidyverse)
library(ggplot2)
library(reshape2)
library(plotly)
library(cowplot)

#Set working directory to local folder containing data or refer to github
#setwd("details")

#Raw snow data containing: date, site, swe_cm, n_days, collnum, snow_dens, depth_cm
snow_raw <- read.csv("ACAD_snow_raw.csv")

#Station data containing information about each station including canopy density
station_data <- read.csv("ACAD_station_data.csv")

###The following section of code serves to rectify the time gaps between sampling
###dates. The most common date among the sites was used. This section is best utilized
###in order to view dates and then make judgement calls. 

####SWE (swe_cm) or Snow Depth (depth_cm) Over Snow Season Graph####

#Creating a dataframe containing only the dates associated with each site
snow_raw_dates <- snow_raw %>% select("date", "site")

#Pivoting to view a table of each date and if sampling occurred at each site. 
pivoted_df <- dcast(snow_raw_dates, date ~ site, value.var = "site")

#Creating an allfile that includes all of the sampling dates and the associated information
#contained in the station data
snow_all <- left_join(snow_raw, station_data, by = "site")

#Creating a column to hold the original dates for reference
snow_all$og_date <- snow_all$date

#New dates based on investigation of the pivoted dataframe. 
snow_all$date <- gsub("12/28/2004", "01/05/2005", snow_all$date)
snow_all$date <- gsub("01/25/2005", "01/30/2005", snow_all$date) 
snow_all$date <- gsub("03/15/2005", "03/16/2005", snow_all$date) 


###The following section calculates standard error, mean for each canopy density
###for each date in order to graph by mean snow swe for each canopy density.

#Ensuring that the date column is date prior to analysis
snow_all$date2 <- as.Date(snow_all$date, format = "%m/%d/%Y")

#Filter out NA snow swe or depth at this will cause problems when calculating mean and 
#standard error
snow_all <- snow_all %>% filter(!is.na(depth_cm))

snow_working <- snow_all

#For each canopy density type and date calculating mean and standard error
se_mean <- snow_all %>%
  group_by(canopy_density, date2) %>%
  reframe(mean_depth = mean(depth_cm),
         se = plotrix::std.error(depth_cm))

#ggplot to create in format of the hypothetical a plot showing mean snow swe or depth and standard error
#over the dates provided for each canopy type
legend_order <- c("Low", "Medium", "High")

a_plot <- ggplot(se_mean) +
  aes(x = date2, y = mean_depth, group = canopy_density) + #variables to be plotted
  geom_errorbar(aes(ymin = mean_depth - se, ymax = mean_depth + se, color = canopy_density), 
                width = 5, position = position_dodge(0.05)) + #add error bars based on se
  geom_smooth(aes(color = canopy_density), method = "auto", linewidth = 1, se = FALSE) + #smooth lines
  #se = FALSE allows for the removal of the gray legend items and se is used with error bars so
  #does not make a difference 
  geom_point(aes(fill = canopy_density), shape = 21, size = 5, color = "black", stroke = 1) + #add points
  labs(x = "Date (winter 2005)", y = "Snowpack depth (cm)",
       color = "Canopy Density", fill = "Canopy Density") + #add titles #title = "Snowpack depth over the snow season" 
  theme_bw() + #choose theme
  scale_x_date(date_breaks = "10 days", date_labels = "%m-%d") + #format date labels orig was date_labels = "%Y-%m-%d"
  scale_color_manual(values = c('#ff9900', '#4e79a7', '#6ba84f'), breaks = legend_order) + #set colours for lines
  scale_fill_manual(values = c('#FFB74D', '#4FC3F7', '#8BC34A'), breaks = legend_order) + #set colours for points
  theme( #setting text size/face preferences for graph
    plot.title = element_text(size = 16, face = "bold"), 
    axis.title.x = element_text(size = 20), 
    axis.title.y = element_text(size = 20),
    axis.text.x = element_text(size = 16, vjust = 0.5),
    axis.text.y = element_text(size = 16),
    #axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)
    legend.title = element_text(size = 20),
    legend.text = element_text(size = 16),
    legend.position = "right",
    legend.key = element_rect(fill = "white", color = "white"),
    legend.background = element_rect(fill="white", color = "white"),
    legend.box.background = element_rect(fill = "white", color = "white")
  )

#Print the a plot. 
print(a_plot)

#Create interactive plot to visually inspect the data
ggplotly(a_plot)

#Save the plot to your working directory
ggsave("Visuals/fig4b_final_25.png", a_plot, width = 10, height = 7)