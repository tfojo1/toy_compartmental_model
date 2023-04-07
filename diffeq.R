                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
library(odeintr)

run.model = function(start.state,
                     parameters,
                     years)
{
    # Pad the start state with extra boxes to track cumulative
    start.state.for.ode = start.state
    
    # Run the model
    results = odeintr::integrate_sys(sys = function(x,t){compute.differential(state=x, t=t, parameters=parameters)},
                                     init = start.state.for.ode,
                                     start = years[1],
                                     duration = years[length(years)] - years[1],
                                     step_size = 1)
    #Process the results
    uninfected = setNames(results[[2]], results[[1]])
    undiagnosed = setNames(results[[3]], results[[1]])
    diagnosed = setNames(results[[4]], results[[1]])
    cumulative.diagnoses = setNames(results[[5]], results[[1]])

    list("uninfected"=uninfected, "undiagnosed"=undiagnosed, "diagnosed"=diagnosed, "cumulative.diagnoses"=cumulative.diagnoses)
    
}

compute.differential = function(state, t, parameters)
{
    dx = numeric(length(state))
    
    # Infection
    #unsuppressed.proportion = 1 - (parameters$suppression.intercept + (t-2011)*parameters$suppression.slope)
    suppressed.proportion.transformed = parameters$suppression.intercept + (t-2011)*parameters$suppression.slope
    suppressed.proportion = exp(suppressed.proportion.transformed)/(1 + exp(suppressed.proportion.transformed))
    infection.rate = parameters$force.of.infection *
        (state[DIAGNOSED]*(1 - suppressed.proportion) + state[UNDIAGNOSED]) / (state[UNINFECTED] + state[DIAGNOSED] + state[UNDIAGNOSED])
    infections = infection.rate * state[UNINFECTED]

    dx[UNINFECTED] = dx[UNINFECTED] - infections
    dx[UNDIAGNOSED] = dx[UNDIAGNOSED] + infections
    
    # Diagnoses
    # @Andrew
    new.diagnoses = parameters$testing.rate * state[UNDIAGNOSED]
    
    dx[UNDIAGNOSED] = dx[UNDIAGNOSED] - new.diagnoses
    dx[DIAGNOSED] = dx[DIAGNOSED] + new.diagnoses
    dx[CUMULATIVE.DIAGNOSES] = dx[CUMULATIVE.DIAGNOSES] + new.diagnoses
    
    # Births
    # @Andrew
    births = parameters$birth.rate * (state[UNINFECTED] + state[DIAGNOSED] + state[UNDIAGNOSED])
    
    dx[UNINFECTED] = dx[UNINFECTED] + births
    
    # Deaths
    # @Andrew
    deaths.uninfected = parameters$uninfected.mortality * state[UNINFECTED]
    deaths.undiagnosed = parameters$hiv.excess.mortality * state[UNDIAGNOSED]
    deaths.diagnosed = parameters$hiv.excess.mortality * state[DIAGNOSED]
    
    dx[UNINFECTED] = dx[UNINFECTED] - deaths.uninfected
    dx[UNDIAGNOSED] = dx[UNDIAGNOSED] - deaths.undiagnosed
    dx[DIAGNOSED] = dx[DIAGNOSED] - deaths.diagnosed
    
    

    # Return the derivative
    dx
}