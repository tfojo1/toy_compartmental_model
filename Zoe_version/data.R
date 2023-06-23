#number of diagnoses in 2011##

PREVALENCE.RATIO = 32700/27616 # 1.1841 is estimated ratio of all cases to diagnosed ones


MD.DIAGNOSES.2011 = 27616  #prevalence
MD.INFECTED.2011 = PREVALENCE.RATIO*MD.DIAGNOSES.2011 
MD.UNDIAGNOSED.2011 =  MD.INFECTED.2011 - MD.DIAGNOSES.2011
MD.UNINFECTED.2011 =  5773552 - MD.INFECTED.2011



#Numbers are at the end of the year so use 2010 data to represent the beginning of 2011#


