

MD.DIAGNOSES = c('2008'=1999,
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


MD.PREVALENCE = c('2008'=25094,
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


calibration.data.frame = data.frame(
    value = c(MD.DIAGNOSES, MD.PREVALENCE),
    year = as.numeric(c(names(MD.DIAGNOSES), names(MD.PREVALENCE))),
    type = c(rep('diagnoses', length(MD.DIAGNOSES)), rep('prevalence', length(MD.PREVALENCE)))
)

# library(ggplot2)
# 
# print(ggplot(calibration.data.frame, aes(x=year, y=value)) +
#           geom_point() +
#        facet_wrap(~type, scales = 'free') + ylim(0,NA))
