

# Get simulated data from a simulation

extract.prevalence <- function(sim, years, race)
{
  
    prevalence = data.frame(sim$population['DIAGNOSED', race, ])
    colnames(prevalence) = 'prevalence'
    prevalence$year = as.numeric(rownames(prevalence))
    prevalence[prevalence$year %in% years,]
}

extract.new.diagnoses <- function(sim, years, race)
{
    
    new = data.frame(sim$diagnoses[race, ])
    colnames(new) = 'new'
    new$year = as.numeric(rownames(new))
    new[new$year %in% years,]
}
