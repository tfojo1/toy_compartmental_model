

# Get simulated data from a simulation

extract.prevalence <- function(sim, years)
{
  
    prevalence = sim$undiagnosed + sim$diagnosed
    prevalence = data.frame(prevalence)
    prevalence$year = as.numeric(rownames(prevalence))
    prevalence[prevalence$year %in% years,]
}

extract.new.diagnoses <- function(sim,  years)
{
    
    new = diff(sim$cumulative.diagnoses) # n vs. n-1
    new = data.frame(new)
    new$year = as.numeric(rownames(new))
    rownames(new)[1] = 'new'
    new[new$year %in% years,]
}
