

# Get simulated data from a simulation

extract.prevalence <- function(sim, years)
{
  
    prevalence = data.frame(sim$diagnosed)
    prevalence$year = as.numeric(rownames(prevalence))
    prevalence[prevalence$year %in% years,]
}

extract.new.diagnoses <- function(sim,  years)
{
    
    new = data.frame(sim$new.diagnoses)
    new$year = as.numeric(rownames(new))
    rownames(new)[1] = 'new'
    #new[new$year == 2011, 'sim.new.diagnoses'] = NA
    new[new$year %in% years,]
}
