                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
library(odeintr)

run.model = function(start.state,
                     parameters,
                     years)
{
    # Pad the start state with extra boxes to track cumulative
    # this is 9 from state, 3 for cumulative diagnoses and 3 for cumulative incidence = 15
    start.state.for.ode = numeric(length(start.state) + 2 * prod(sapply(CUMULATIVE.DIM.NAMES, length)))
    
    start.state.for.ode[1:length(start.state)] = as.numeric(start.state) #check doc for as.numeric
    
    # Run the model
    results = odeintr::integrate_sys(sys = function(x,t){compute.differential(ode.state=x, t=t, parameters=parameters)},
                                     init = start.state.for.ode,
                                     start = years[1],
                                     duration = years[length(years)] - years[1],
                                     step_size = 1)
    
    population.end.index = 1 + length(start.state)
    diagnoses.end.index = population.end.index + prod(sapply(CUMULATIVE.DIM.NAMES, length))
    incidence.end.index = diagnoses.end.index + prod(sapply(CUMULATIVE.DIM.NAMES, length))

    population = array(unlist(t(results[2:population.end.index])),
                       dim=c(sapply(STATE.DIM.NAMES, length), nrow(results)),
                       dimnames=c(STATE.DIM.NAMES, year=list(results[, 1])))
    diagnoses = array(unlist(t(results[(1 + population.end.index):diagnoses.end.index])),
                      dim=c(sapply(CUMULATIVE.DIM.NAMES, length), nrow(results)),
                      dimnames=c(CUMULATIVE.DIM.NAMES, year=list(results[, 1])))
    incidence = array(unlist(t(results[(1 + diagnoses.end.index):incidence.end.index])),
                      dim=c(sapply(CUMULATIVE.DIM.NAMES, length), nrow(results)),
                      dimnames=c(CUMULATIVE.DIM.NAMES, year=list(results[, 1])))
    
    # Process cumulative measures
    # WARNING: ASSUMES ONLY RACE & YEAR DIMENSIONS
    # For more dimensions, I'd need to have embedded apply() loops
    diagnoses = t(apply(diagnoses, 1, diff))
    incidence = t(apply(incidence, 1, diff))
    
    list('population'=population, 'diagnoses'=diagnoses, 'incidence'=incidence)
    
    # browser()
}

compute.differential = function(ode.state, t, parameters)
{
    
    dx.state = array(0, dim = sapply(STATE.DIM.NAMES, length), dimnames = STATE.DIM.NAMES) #N dimensional
    dx.diagnoses = array(0, dim = sapply(STATE.DIM.NAMES[-1], length), dimnames = STATE.DIM.NAMES[-1]) #N-1 dimensional
    dx.incidence = array(0, dim = sapply(STATE.DIM.NAMES[-1], length), dimnames = STATE.DIM.NAMES[-1]) #N-1 dimensional
    
    state = array(ode.state[1:length(dx.state)], dim = sapply(STATE.DIM.NAMES, length), dimnames = STATE.DIM.NAMES)
    
    
    # Infection
    suppressed.proportion.transformed = parameters$suppression.intercept + (t-2010)*parameters$suppression.slope
    suppressed.proportion = 1/(1 + exp(-1*suppressed.proportion.transformed))
    
    # force.of.infection = parameters$force.of.infection.intercept + (t-2010)*parameters$force.of.infection.slope
    infection.rate = parameters$force.of.infection *
        (state['DIAGNOSED', ]*(1 - suppressed.proportion) + state['UNDIAGNOSED', ]) / (state['UNINFECTED', ] + state['DIAGNOSED', ] + state['UNDIAGNOSED', ])
    infections = infection.rate * state['UNINFECTED', ]

    dx.state['UNINFECTED', ] = dx.state['UNINFECTED', ] - infections
    dx.state['UNDIAGNOSED', ] = dx.state['UNDIAGNOSED', ] + infections
    
    dx.incidence = dx.incidence + infections
    
    # Diagnoses
    
    new.diagnoses = parameters$testing.rate * state['UNDIAGNOSED', ] # we presume 2 dimensions in the number of commas
    
    dx.state['UNDIAGNOSED', ] = dx.state['UNDIAGNOSED', ] - new.diagnoses # creating new object in memory
    dx.state['DIAGNOSED', ] = dx.state['DIAGNOSED', ] + new.diagnoses
    
    dx.diagnoses = dx.diagnoses + new.diagnoses
    dx.incidence = dx.incidence + new.diagnoses
    
    # Births
    births = parameters$birth.rate * (state['UNINFECTED', ] + state['DIAGNOSED', ] + state['DIAGNOSED', ])
    
    dx.state['UNINFECTED', ] = dx.state['UNINFECTED', ] + births
    
    # Deaths
    deaths.uninfected = parameters$uninfected.mortality * state['UNINFECTED', ]
    deaths.undiagnosed = parameters$hiv.excess.mortality * state['UNDIAGNOSED', ]
    deaths.diagnosed = parameters$hiv.excess.mortality * state['DIAGNOSED', ]
    
    dx.state['UNINFECTED', ] = dx.state['UNINFECTED', ] - deaths.uninfected
    dx.state['UNDIAGNOSED', ] = dx.state['UNDIAGNOSED', ] - deaths.undiagnosed
    dx.state['DIAGNOSED', ] = dx.state['DIAGNOSED', ] - deaths.diagnosed

    # Return the derivative as a vector of length what the ODE thinks state is
    c(as.numeric(dx.state), as.numeric(dx.diagnoses), as.numeric(dx.incidence))
}