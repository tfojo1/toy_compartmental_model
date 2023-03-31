                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
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
    # Process the results
    results # for right now, just return
}

compute.differential = function(state, t, parameters)
{
    dx = numeric(length(state))
    
    # Infection
    infection.rate = parameters$force.of.infection *
        (state[DIAGNOSED] + state[UNDIAGNOSED]) / (state[UNINFECTED] + state[DIAGNOSED] + state[UNDIAGNOSED])
    infections = infection.rate * state[UNINFECTED]

    dx[UNINFECTED] = dx[UNINFECTED] - infections
    dx[UNDIAGNOSED] = dx[UNDIAGNOSED] + infections
    
    # Diagnoses
    # @Andrew
    new.diagnoses = parameters$testing.rate * state[UNDIAGNOSED]
    
    dx[UNDIAGNOSED] = dx[UNDIAGNOSED] - new.diagnoses
    dx[DIAGNOSED] = dx[DIAGNOSED] + new.diagnoses
    
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