# we have output that is 'prevalence' and 'new' for each of 3 races.

# we also know the real population of Maryland and can use a ratio to determine
# race subpopulations

# we want to compute a likelihood for the 'prevalence' and 'new' data given the
# parameters we have and our simulated prevalence and new diagnoses.

# the likelihood_black_new should equal

model.prev = sim$population['DIAGNOSED', 'BLACK', 1:11]
model.new = sim$diagnoses['BLACK', 1:11]
model.pop = apply(sim$population[, 'BLACK', 1:11], c('year'), sum)
obs.prev = MD.PREVALENCE.BLACK[3:13]
obs.new = MD.DIAGNOSES.BLACK[3:13]
obs.pop = MD.POPULATION.BLACK

likelihood.black.new = dnorm(
    x = obs.new,
    mean = obs.pop * model.new / model.pop, # n*p
    sd = sqrt(obs.pop * model.new / model.pop * (1 - model.new/model.pop))) # sqrt(np*(1-p))

sum.log.likelihood.black.new = sum(log(likelihood.black.new)) #-201.361

likelihood.black.prev = dnorm(
    x = obs.prev,
    mean = obs.pop * model.prev / model.pop,
    sd = sqrt(obs.pop * model.prev / model.pop * (1 - model.prev/model.pop))
)

sum.log.likelihood.black.prev = sum(log(likelihood.black.prev))

sum.log.likelihood.black = sum.log.likelihood.black.new + sum.log.likelihood.black.prev

# We would do this for all races/demographic categories.
# Then we alter the parameters in a certain way (which ones? how much?) --> MCMC
# How do we account for dependence between random variables here?
# We have 11 years * 3 races * 2 outcomes = 66 random variables.
# It is likely that the observations for each year per race/outcome are correlated.