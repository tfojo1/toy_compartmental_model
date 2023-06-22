
# main

# Source the files we use (data, diff equation, model structure)
source('Zoe_version/data.R')
source('Zoe_version/diffeq.R')
source('Zoe_version/model_structure.R')

# create a starting state
start.state.2011 = set.state(c(MD.UNINFECTED.2011, MD.UNDIAGNOSED.2011, MD.DIAGNOSES.2011)) #this order matters#

# set up parameters
parameters = list(
  suppressed.proportion = 0.3, # maybe? I'm sure you have a better estimate
  testing.rate = 0.25,
  force.of.infection = 0.04,
  
  birth.rate = 10.8/1000,
  
  uninfected.mortality = 2/1000,
  hiv.excess.mortality = 1/1000
)

# run the model
#@Zoe note you'll want to change the output of this function to suit your needs
sim = run.model(start.state = start.state.2011,
                parameters = parameters,
                years = 2010:2030)

# examine the results
#@Zoe make some nice plots that compare projections to calibration data
