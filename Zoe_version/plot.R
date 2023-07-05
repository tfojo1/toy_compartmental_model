#Plot
library(ggplot2)

#Create dataframe with CDC Atlas Count Data#
CDC_data = data.frame(MD.PREVALENCE.CDC)
CDC_data$year = row.names(CDC_data)



#Initially had made sim_array into a dataframe to plot but this structure
#doesn't make sense for the data (once it gains complexity)
# sim_data <- as.data.frame(sim_array)
# sim_data$year <- row.names(sim_data)

#Re-doing section from above
years= sim_array_list[[1]] #create vector of years from the sim list
cdc_prevalence = CDC_data[["MD.PREVALENCE.CDC"]]

plot_data <- data.frame(years, diagnosed) #initially had called this diagnosed but it's really a prevalence value
plot_data <- data.frame(years, diagnosed) 


#First plot#

prevalenceplot <- ggplot() + 
  geom_point(data=plot_data, aes(x=years, y=diagnosed), color='blue') + 
  geom_point(data=CDC_data, aes(x=year, y=MD.PREVALENCE.CDC), color='red')

print(prevalenceplot + labs(
  title= "HIV Prevalence: Model Prediction vs. CDC Data",
  y= "HIV Prevalence" , x= "Year"
))

#Second plot#

# newcaseplot <- ggplot() + 
#   geom_point(data=plot_data, aes(x=CHANGE, y=CHANGE), color='blue') + 
#   geom_point(data=CDC_data, aes(x=CHANGE, y=CHANGE), color='red')

# print(newcaseplot + labs(
#   title= "New HIV Cases: Model Prediction vs. CDC Data",
#   y= "Count of New HIV Cases" , x= "Year"
# ))