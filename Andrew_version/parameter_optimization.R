
# Source files
source('data.R')
source('diffeq.R')
source('model_structure.R')
source('sim.R')

start.state.2011 = get.empty.state()
start.state.2011[DIAGNOSED] = 27616 # diagnosed by end of 2010
start.state.2011[UNDIAGNOSED] = 32700-27616
start.state.2011[UNINFECTED] = 5773552-32700
start.state.2011[CUMULATIVE.DIAGNOSES] = 0

suppression.data = calibration.data.frame[calibration.data.frame$type == 'suppression',]
suppression.data$year = suppression.data$year - 2011
suppression.model = glm(value ~ year, family=binomial(link="logit"), data=suppression.data)

parameters.to.optimize = list(
    testing.rate = 0.25,
    # force.of.infection = 0.025
    force.of.infection.slope = 0,
    force.of.infection.intercept = 0.025
    # suppression.slope = 0.1560836,
    # suppression.intercept = -0.6813797
)

parameters.not.to.optimize = list(
    suppression.slope = suppression.model$coefficients[2],
    suppression.intercept = suppression.model$coefficients[1],
    
    
    birth.rate = 10.8/1000,
    
    uninfected.mortality = 2/1000,
    hiv.excess.mortality = 1/1000
)

objective.function = function(parameters.to.optimize,
                       parameters.not.to.optimize,
                       start.state,
                       years,
                       outcome.to.optimize)
{
    parameters.all = c(parameters.to.optimize, parameters.not.to.optimize)
    results = run.model(start.state,
                        parameters.all,
                        years)
    
    # sum of squared errors from calibration prevalence or diagnoses
    if (outcome.to.optimize == 'prevalence') {
        sim.data = extract.prevalence(results, years)
        calibration.data = calibration.data.frame[calibration.data.frame$type == 'prevalence' & calibration.data.frame$year %in% years,]
        merged.data = merge(sim.data, calibration.data, by = "year")
        sum.squared.error = sum((merged.data$value - merged.data$sim.diagnosed)^2)
    } else if (outcome.to.optimize == 'new') {
        sim.data = extract.new.diagnoses(results, years)
        calibration.data = calibration.data.frame[calibration.data.frame$type == 'diagnoses' & calibration.data.frame$year %in% years,]
        merged.data = merge(sim.data, calibration.data, by = "year")
        sum.squared.error = sum((merged.data$value - merged.data$sim.new.diagnoses)^2)
    }
    
    # sum of the squared percentage (relative) error
    sum.squared.error
    
}

optim.results = optim(par = parameters.to.optimize,
                      fn = objective.function,
                      parameters.not.to.optimize = parameters.not.to.optimize,
                      start.state = start.state.2011,
                      years = 2010:2030,
                      outcome.to.optimize = 'prevalence')

print(optim.results$par)