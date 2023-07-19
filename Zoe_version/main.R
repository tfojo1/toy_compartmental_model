
# main

# Source the files we use (data, diff equation, model structure)
source('Zoe_version/data.R')
source('Zoe_version/diffeq.R')
source('Zoe_version/model_structure.R')

# create a starting state
start.state.2011 = set.state(c(MD.UNINFECTED.2011, MD.UNDIAGNOSED.2011, MD.PREVALENCE.2011)) #this order matters#

#Create calibration data frame
suppression.data = calibration.data.frame[calibration.data.frame$type == 'suppression',]
suppression.data$year = suppression.data$year - 2011
#log transformation
suppression.data$transformed_value = -1*log((1-suppression.data$value)/suppression.data$value) #this is the log odds formula#
# y = -1 * log ((1-x)/x)
# y= log(x/(1-x))
# e^y = x/(1-x)
# (1-x)*exp(y) = x
# x= exp(y)-x*(exp(y))
# x+(x*exp(y))= exp(y)
# x*(1+exp(y))= exp(y)
# x= exp(y) / (1+exp(y)) #this is the solved equation to untransform y values#

#Regression things
suppression.model = glm(value ~ year, family=binomial(link="logit"), data=suppression.data) #this glm does the transformation for you so don't do it twice# #linear regression with log transformation first#
#suppression.model.linear = lm(value ~ year, suppression.data) #linear


# set up parameters
parameters = list(
  # suppressed.proportion = 0.4, #commenting out bc no longer static-replace with time varying parameter for suppression#
  suppressed.slope = suppression.model$coefficients[2], #could call this by name instead of saying 2nd coefficient- pull linear or logistic value#
  suppressed.intercept = suppression.model$coefficients[1],
  testing.rate = 0.25, #was 0.25#
  force.of.infection = 0.04, #was 0.04
  
  birth.rate = 10.8/1000,
  
  uninfected.mortality = 2/1000,
  hiv.excess.mortality = 1/1000
)

# run the model
#@Zoe note you'll want to change the output of this function to suit your needs
sim = run.model(start.state = start.state.2011,
                parameters = parameters,
                years = 2010:2030)

# #change the format of this to make graphing process easier#
#can this be more efficient? Should I make the diffeq run.model return this rather than doing this here?#
uninfected <- c(sim$X1)
undiagnosed <- c(sim$X2)
diagnosed <- c(sim$X3)
newcases <- c(sim$X4)

sim_array_prevalence <- array(c(uninfected, undiagnosed, diagnosed), dim=c(21,3),
                   dimnames = list(
                     year=as.character(2010:2030),
                     continuum=c('UNINFECTED', 'UNDIAGNOSED', 'DIAGNOSED')))


sim_array_newcases <- array(c(newcases), dim=c(21,1),
                   dimnames = list(
                     year=as.character(2010:2030),
                     continuum=c('NEW_CASES')))

my_list <- list(prevalence =sim_array_prevalence , newcases=sim_array_newcases)

# examine the results
#@Zoe make some nice plots that compare projections to calibration data
source('Zoe_version/plot.R')
