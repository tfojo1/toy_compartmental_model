
# Source files
source('data.R')
source('diffeq.R')
source('model_structure.R')
source('simplot.R')

# Create a start state
start.state.2011 = get.empty.state()
start.state.2011[DIAGNOSED] = 27616 # diagnosed by end of 2010
start.state.2011[UNDIAGNOSED] = 32700-27616
start.state.2011[UNINFECTED] = 5773552-32700
start.state.2011[CUMULATIVE.DIAGNOSES] = 0

# Set up parameters

parameters = list(
    testing.rate = 0.25,
    force.of.infection = .1,
    
    birth.rate = 10.8/1000,
    
    uninfected.mortality = 2/1000,
    hiv.excess.mortality = 1/1000
)

# Run the model
sim = run.model(start.state = start.state.2011,
                parameters = parameters,
                years = 2011:2030)


# Compare to calibration data

print(simplot(sim, 'prevalence', years=2011:2030))
print(simplot(sim, 'new', years=2011:2030))
