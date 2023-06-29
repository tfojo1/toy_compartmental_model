#Plot
library(ggplot2)

#Create dataframe with CDC Atlas Count Data#
year <- as.character(c("2008": "2020"))
CDC_data = data.frame(MD.PREVALENCE.CDC)

#Structured sim into an array bc it makes more sense as model gains complexity in the future
#But doesn't ggplot only work with data frames?
sim_data <- as.data.frame(sim_array)
sim_data$year <- row.names(sim_data)

#sim data
ggplot(data=sim_data, 
       aes(x=year, y=DIAGNOSED)) +
      geom_point()

#CDC data
ggplot(data=CDC_data, 
       aes(x=year, y=MD.PREVALENCE.CDC)) +
  geom_point()

  
#Combined plot
ggplot() + 
  geom_point(data=sim_data, aes(x=year, y=DIAGNOSED), color='blue') + 
  geom_point(data=CDC_data, aes(x=year, y=MD.PREVALENCE.CDC), color='red')