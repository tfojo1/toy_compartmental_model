#Data for Model
#Clarify: in this scenario, 'diagnoses'=prevalence?  
#Clarify: numbers represent the end of the year, so use 2010 data to represent the BEGINNING of 2011
#Are we trying to represent the beginning of the year for the model's sake?

PREVALENCE.RATIO = 32700/27616 # 1.1841 is estimated ratio of all cases to diagnosed ones#

MD.PREVALENCE.2011 = 28599  #This is the MD.PREVALENCE value for 2010 from Andrew's data file#
MD.INFECTED.2011 = PREVALENCE.RATIO * MD.PREVALENCE.2011 
MD.UNDIAGNOSED.2011 =  MD.INFECTED.2011 - MD.PREVALENCE.2011
MD.UNINFECTED.2011 =  5773552 - MD.INFECTED.2011  #2010 MD POPULATION#
#change these to prevalence#


#Underlying data- CDC Atlas (source of truth)
#Pulling 'prevalence' values bc they align with what we are calling diagnoses above

# prevalence in 2020 is # people diagnosed in year 2020 or prior
MD.PREVALENCE.CDC = c('2008'=25094,
                  '2009'=26062,
                  '2010'=27616,
                  '2011'=28599,
                  '2012'=29171,
                  '2013'=29625,
                  '2014'=30836,
                  '2015'=32486,
                  '2016'=32094,
                  '2017'=32612,
                  '2018'=33124,
                  '2019'=33311,
                  '2020'=33425)

MD.POPULATION.CDC = c(
                '2010' = 5773552,
                '2011' = 5840241,
                '2012' = 5888375,
                '2013' = 5925197,
                '2014' = 5960064,
                '2015' = 5988528,
                '2016' = 6007014,
                '2017' = 6028186,
                '2018' = 6042153,
                '2019' = 6054954,
                '2020' = 6055802)

MD.NEWCASES = c('2008'=1999,
                 '2009'=1669,
                 '2010'=1722,
                 '2011'=1409,
                 '2012'=1307,
                 '2013'=1291,
                 '2014'=1231,
                 '2015'=1171,
                 '2016'=1093,
                 '2017'=1020,
                 '2018'=990,
                 '2019'=915,
                 '2020'=706)

#Right now these are all going to be the same as the values above so figure out how to fix that#

MD.PREVALENCE.2011.CDC = 28599  #actually 2010#
MD.INFECTED.2011.CDC = PREVALENCE.RATIO * MD.PREVALENCE.2011.CDC 
MD.UNDIAGNOSED.2011.CDC =  MD.INFECTED.2011 - MD.PREVALENCE.2011.CDC
MD.UNINFECTED.2011.CDC =  5773552 - MD.INFECTED.2011.CDC #actually 2010#