
# main

# Source the files we use (data, diff equation, model structure)
source('Zoe_version/data.R')
#source('Zoe_version/diffeq.R')
source('Zoe_version/model_structure.R')

# create a starting state
start.state.2011 = set.state(c(MD.UNINFECTED.2011, MD.UNDIAGNOSED.2011, MD.DIAGNOSES.2011)) #this order matters#

# set up parameters

# run the model

# examine the results#