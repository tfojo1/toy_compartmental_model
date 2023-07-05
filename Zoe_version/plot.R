#Plot
library(ggplot2)

#Create dataframe with CDC Atlas Data#
CDC_data = data.frame(MD.PREVALENCE.CDC, MD.NEWCASES.CDC)
CDC_data$year = row.names(CDC_data)


#Need to make sim into an array, plot the vectors
years= sim_array_list[[1]] #create vector of years from the sim list
cdc_prevalence = CDC_data[["MD.PREVALENCE.CDC"]]
cdc_new_cases = CDC_data[["MD.NEWCASES.CDC"]]

plot_data <- data.frame(years, diagnosed) #initially had called this diagnosed but it's really a prevalence value
plot_data <- data.frame(years, diagnosed) 


#First plot- Prevalence#
prevalenceplot <- ggplot() + 
  geom_point(data=plot_data, aes(x=years, y=diagnosed), color='blue') + 
  geom_point(data=CDC_data, aes(x=year, y=cdc_prevalence), color='red')

print(prevalenceplot + labs(
  title= "HIV Prevalence: Model Prediction vs. CDC Data",
  y= "HIV Prevalence" , x= "Year"
))

#Second plot-New Cases#
 newcaseplot <- ggplot() +
   geom_point(data=plot_data, aes(x=years, y=newcases), color='blue') +
   geom_point(data=CDC_data, aes(x=year, y=cdc_new_cases), color='red')

 print(newcaseplot + labs(
   title= "New HIV Cases: Model Prediction vs. CDC Data",
   y= "Count of New HIV Cases" , x= "Year"
 ))