
# Source files
source('Andrew_version/data.R')
source('Andrew_version/diffeq.R')
source('Andrew_version/model_structure.R')
source('Andrew_version/simplot.R')

# going in 2011 means Jan. 1st 2011, coming out it means Dec. 31st 2011
# what would July 1st be?

# Create a start state
# start.state.2011 = get.empty.state()

# brittle!
start.state.2011.data = c(MD.POPULATION.2010.BLACK - 19501*PREVALENCE.RATIO, 19501*(PREVALENCE.RATIO - 1), 19501,
                          MD.POPULATION.2010.HISPANIC - 1646*PREVALENCE.RATIO, 1646*(PREVALENCE.RATIO - 1), 1646,
                          MD.POPULATION.2010.OTHER - 6469*PREVALENCE.RATIO, 6469*(PREVALENCE.RATIO - 1), 6469)
start.state.2011 = set.state(start.state.2011.data)

# Set up parameters

# regression
suppression.data = calibration.data.frame[calibration.data.frame$type == 'suppression',]
suppression.data$year = suppression.data$year - 2011
suppression.model = glm(value ~ year, family=binomial(link="logit"), data=suppression.data)
suppression.model.linear = lm(value ~ year, suppression.data)

# plot fitted values to data points and check prediction to 2030

# eventually will have a function 'make.parameters()'
parameters = list(
    suppression.slope = suppression.model$coefficients[2],
    suppression.intercept = suppression.model$coefficients[1],
    testing.rate = 0.18782960,
    force.of.infection = 0.03655538,
    
    birth.rate = 10.8/1000,
    
    uninfected.mortality = 2/1000,
    hiv.excess.mortality = 1/1000
)

# Run the model

sim = run.model(start.state = start.state.2011,
                parameters = parameters,
                years = 2010:2030) # need to do 2010 to see 2011



# Compare to calibration data

print(simplot(sim, years=2011:2030, race='BLACK', 'prevalence'))
print(simplot(sim, years=2011:2030, race='BLACK', 'new'))
