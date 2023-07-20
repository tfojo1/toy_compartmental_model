

#Need to create a starting point for the optimization: (pulling from start.state.2011)
years_new = c(2008:2030)

#List parameters to optimize (using just testing rate)

parameters.to.optimize = list(
  testing.rate = 0.25, 
  force.of.infection = 0.04  
)

#List parameters to stay the same 

parameters.not.to.optimize = list(
  suppressed.slope = suppression.model$coefficients[2], #We made suppression a time varying parameter#
  suppressed.intercept = suppression.model$coefficients[1],
  
  birth.rate = 10.8/1000, 
  
  uninfected.mortality = 2/1000,
  hiv.excess.mortality = 1/1000
)

#Objective function = a function to be minimized/maximized- how good/bad did it do with each iteration
objective.function = function(parameters.to.optimize,
                              parameters.not.to.optimize,
                              start.state,
                              years_new, #this has years from 2008-2030#
                              outcome.to.optimize) #establish this below#
{
  parameters.all = c(parameters.to.optimize, parameters.not.to.optimize)
  results = run.model(start.state,
                      parameters.all,
                      years_new)
  
  #Need to include a measurement of success/quality (sum of squared error, etc.)
  #You're optimizing a parameter but need to examine the 'optimized' outcome to determine success
  #Outcomes = new cases, diagnoses
  
  # if (outcome.to.optimize == 'new_cases') {
  #   sim.data = sim
  #   calibration.data = calibration.data.frame[calibration.data.frame$type == 'new_cases' & calibration.data.frame$year %in% years_new,]
  #   merged.data = merge(sim.data, calibration.data, by.x = "Time", by.y = "year")
  #   sum.squared.error = sum((merged.data$value - merged.data$X4)^2)
  # } else if (outcome.to.optimize == 'diagnosed') {
  #   sim.data = sim
  #   calibration.data = calibration.data.frame[calibration.data.frame$type == 'prevalence' & calibration.data.frame$year %in% years_new,]
  #   merged.data = merge(sim.data, calibration.data, by.x = "Time", by.y = "year")
  #   sum.squared.error = sum((merged.data$value - merged.data$X3)^2)
  # }
  
  #Try another method
  if (outcome.to.optimize == 'new_cases') {
    sim.data = sim
    calibration.data = calibration.data.frame[calibration.data.frame$type == 'new_cases' & calibration.data.frame$year %in% years_new,]
    merged.data = merge(sim.data, calibration.data, by.x = "Time", by.y = "year")
    test.eval = mean(merged.data$value - merged.data$X4)

  } else if (outcome.to.optimize == 'diagnosed') {
    sim.data = sim
    calibration.data = calibration.data.frame[calibration.data.frame$type == 'prevalence' & calibration.data.frame$year %in% years_new,]
    merged.data = merge(sim.data, calibration.data, by.x = "Time", by.y = "year")
    test.eval = mean(merged.data$value - merged.data$X3)
  }
  
  #Write what you want returned here:
  test.eval
}

#Run the actual optim function using everything you've created from above
optim.results = optim(par = parameters.to.optimize,
                      fn = objective.function,
                      parameters.not.to.optimize = parameters.not.to.optimize,
                      start.state = start.state.2011,
                      years = 2010:2030,
                      outcome.to.optimize = 'new_cases')

#Examine results
print(optim.results)