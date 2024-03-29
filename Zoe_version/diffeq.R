
library(odeintr)

# We make a function that calls the 'odeintr' package's solver and then processes its output.
# The solver function wants to know the system of differential equations so we define that below in another function
run.model = function(
    start.state,
    parameters,
    years) {
  
  start.state.for.ode = numeric(length(start.state)+1)
  start.state.for.ode[1:length(start.state)] = as.numeric(start.state)
  results = odeintr::integrate_sys(
    sys = function(x,t) {compute.differential(ode.state=x, t=t, parameters=parameters)},
    init = start.state.for.ode,
    duration = years[length(years)] - years[1],
    step_size = 1,
    start = years[1]
  )
  transformed.data = results
  transformed.data
  #array() this was what was getting returned- an empty array
  
  # Process results, a data.frame with years as rows
  #@Zoe fill this in if you want practice working with arrays
}

# The system of differential equations where we say how the compartments (state) should change each year
compute.differential = function(ode.state, t, parameters) {
  
  # This is an array with an element for each compartment. It will measure what the change in the compartment will be for the solver to find the next year's values* (*not exactly how differential equations work but close).
  # Every time a new aspect of the model affects how a compartment changes, we'll add to or subtract from its value in this array.
  # the whole sapply(dimnames, length) thing is a handy way to figure out the length of each dimension based on how you defined the dimnames earlier
  dx.state = array(0, dim = sapply(STATE.DIM.NAMES, length), dimnames = STATE.DIM.NAMES)
  dx.diagnoses= array(0, dim= 1)
  
  # Since some of the rates of change depend on the current state (e.g., infections depend on how many people are infectious), we need to import the state.
  state = array(ode.state, dim = sapply(STATE.DIM.NAMES, length), dimnames = STATE.DIM.NAMES)
  
  
  # -- Infections --
  # Infection rate is determined by the proportion of the population that is infectious, whether they are diagnosed and unsuppressed or just undiagnosed.
  # The fact that you see the *state* used in determining how the state itself will change is why this is a differential equation
  transformed.suppressed.proportion = (parameters$suppressed.slope*t) + parameters$suppressed.intercept #linear-this is the transformed proportion#after line 44 undo the transformation#
  #Here you essentially untransform the suppressed values-solve line 16#
  suppressed.proportion = exp(transformed.suppressed.proportion) / (1+exp(transformed.suppressed.proportion)) 
  infection.rate = parameters$force.of.infection *
    sum(state['DIAGNOSED']*(1 - suppressed.proportion) + state['UNDIAGNOSED']) / sum(state['UNINFECTED'] + state['DIAGNOSED'] + state['UNDIAGNOSED']) #here is where you apply the suppressed proportion#
  infections = infection.rate * state['UNINFECTED']
  
  # We subtract the number of infected people from the 'UNINFECTED' compartment and add as many to the 'UNDIAGNOSED' compartment.
  dx.state['UNINFECTED'] = dx.state['UNINFECTED'] - infections
  dx.state['UNDIAGNOSED'] = dx.state['UNDIAGNOSED'] + infections
  
  # -- Diagnoses --
  
  new.diagnoses = parameters$testing.rate * state['UNDIAGNOSED']
  
  dx.state['UNDIAGNOSED'] = dx.state['UNDIAGNOSED'] - new.diagnoses
  dx.state['DIAGNOSED'] = dx.state['DIAGNOSED'] + new.diagnoses
  
  # Births
  births = parameters$birth.rate * (state['UNINFECTED'] + state['DIAGNOSED'] + state['DIAGNOSED'])
  
  dx.state['UNINFECTED'] = dx.state['UNINFECTED'] + births
  
  # Deaths
  deaths.uninfected = parameters$uninfected.mortality * state['UNINFECTED']
  deaths.undiagnosed = parameters$hiv.excess.mortality * state['UNDIAGNOSED']
  deaths.diagnosed = parameters$hiv.excess.mortality * state['DIAGNOSED']
  
  dx.state['UNINFECTED'] = dx.state['UNINFECTED'] - deaths.uninfected
  dx.state['UNDIAGNOSED'] = dx.state['UNDIAGNOSED'] - deaths.undiagnosed
  dx.state['DIAGNOSED'] = dx.state['DIAGNOSED'] - deaths.diagnosed
  dx.state['UNINFECTED']= births - infections - deaths.uninfected #uninfected cat should change by this amount#
  
  # Return the derivative as a vector of the same length as the ODE's state
  c(as.numeric(dx.state), as.numeric(new.diagnoses))
}


