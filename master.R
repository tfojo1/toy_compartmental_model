
# Source files
source('data.R')
source('diffeq.R')
source('model_structure.R')
source('simplot.R')

# going in 2011 means Jan. 1st 2011, coming out it means Dec. 31st 2011
# what would July 1st be?

# Create a start state
start.state.2011 = get.empty.state()
start.state.2011[DIAGNOSED] = 27616 # diagnosed by end of 2010
start.state.2011[UNDIAGNOSED] = 32700-27616
start.state.2011[UNINFECTED] = 5773552-32700
start.state.2011[CUMULATIVE.DIAGNOSES] = 0

# Set up parameters

# regression
suppression.data = calibration.data.frame[calibration.data.frame$type == 'suppression',]
suppression.data$year = suppression.data$year - 2011
suppression.model = glm(value ~ year, family=binomial(link="logit"), data=suppression.data)
suppression.model.linear = lm(value ~ year, suppression.data)

# plot fitted values to data points and check prediction to 2030

parameters = list(
    suppression.slope = suppression.model$coefficients[2],
    suppression.intercept = suppression.model$coefficients[1],
    testing.rate = 0.25,
    force.of.infection = .025,
    
    birth.rate = 10.8/1000,
    
    uninfected.mortality = 2/1000,
    hiv.excess.mortality = 1/1000
)

# Run the model
sim = run.model(start.state = start.state.2011,
                parameters = parameters,
                years = 2010:2030) # need to do 2010 to see 2011


# Compare to calibration data

print(simplot(sim, 'prevalence', years=2011:2030))
print(simplot(sim, 'new', years=2011:2030))
