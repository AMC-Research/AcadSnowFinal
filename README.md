# Acadia Snow
A brief exploration and visualization of snow swe, snow depth, and canopy density. 
See Nelson 2007 (UMaine dissertation) for details of sample collection. https://digitalcommons.library.umaine.edu/etd/1177/

## csv files

> ACAD_snow_raw.csv -- csv containing the snow data including site, date, density, and snow swe and depth
> 
> ACAD_station_data.csv -- csv containing the associated station data including site and canopy density
>
> dates_all.csv -- date organization csv in order to make sampling dates line up 

## Scripts

> acad_snow_working_2025.R -- data tidying and some analysis to rectify sampling date time gaps, calculate mean and se for each canopy density on each date, and create a visualization of the data. Based on conceptual figure in paper. Created by Miriam Ritchie in 2023 and revised by Sarah Nelson in 2025 to address paper revisions.


### A brief explanation of the date re-organization

Dates can be grouped (as in supplement figure with SWE) into collections to simplify presentation. Some snow collections were across multiple days due to adverse field conditions. 

C6A & CT5E only have 5 measurements each instead of 6

01/05/2005 (12/28/2004)
01/15/2005 -- missing C6A & CT5E
01/30/2005 (01/25/2005) -- equal, chose 30 for visualization
02/12/2005 -- all
03/05/2005 -- all
03/16/2005 (03/15/2005)
