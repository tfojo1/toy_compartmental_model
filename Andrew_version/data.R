

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

MD.DIAGNOSES.BLACK = c('2008'=1399,
                       '2009'=1188,
                       '2010'=1187,
                       '2011'=946,
                       '2012'=886,
                       '2013'=897,
                       '2014'=878,
                       '2015'=827,
                       '2016'=778,
                       '2017'=687,
                       '2018'=742,
                       '2019'=666,
                       '2020'=501)

MD.DIAGNOSES.HISPANIC = c('2008'=159,
                          '2009'=122,
                          '2010'=136,
                          '2011'=135,
                          '2012'=115,
                          '2013'=96,
                          '2014'=112,
                          '2015'=101,
                          '2016'=99,
                          '2017'=104,
                          '2018'=77,
                          '2019'=103,
                          '2020'=86)

MD.DIAGNOSES.OTHER = c('2008'=441,
                       '2009'=359,
                       '2010'=399,
                       '2011'=328,
                       '2012'=306,
                       '2013'=298,
                       '2014'=241,
                       '2015'=243,
                       '2016'=216,
                       '2017'=229,
                       '2018'=171,
                       '2019'=146,
                       '2020'=119)

# prevalence in 2020 is # people diagnosed in year 2020 or prior
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

MD.PREVALENCE.BLACK = c('2008'=17905,
                        '2009'=18551,
                        '2010'=19501,
                        '2011'=20107,
                        '2012'=20492,
                        '2013'=20853,
                        '2014'=21664,
                        '2015'=22653,
                        '2016'=22640,
                        '2017'=23036,
                        '2018'=23461,
                        '2019'=23706,
                        '2020'=23823)

MD.PREVALENCE.HISPANIC = c('2008'=1354,
                           '2009'=1456,
                           '2010'=1646,
                           '2011'=1748,
                           '2012'=1817,
                           '2013'=1878,
                           '2014'=2003,
                           '2015'=2240,
                           '2016'=2217,
                           '2017'=2313,
                           '2018'=2394,
                           '2019'=2440,
                           '2020'=2490)

MD.PREVALENCE.OTHER = c('2008'=5865,
                        '2009'=6055,
                        '2010'=6469,
                        '2011'=6744,
                        '2012'=6862,
                        '2013'=6894,
                        '2014'=7169,
                        '2015'=7593,
                        '2016'=7237,
                        '2017'=7263,
                        '2018'=7269,
                        '2019'=7165,
                        '2020'=7112)

MD.SUPPRESSION = c('2011'=0.3,
                   '2012'=0.386,
                   '2013'=0.418,
                   '2014'=0.445,
                   '2015'=0.479,
                   '2016'=0.545,
                   '2017'=0.578,
                   '2018'=0.628,
                   '2019'=0.649,
                   '2020'=0.622)

MD.POPULATION.2010 = 5773552
MD.POPULATION.2010.BLACK = MD.POPULATION.2010 * 0.294
MD.POPULATION.2010.HISPANIC = MD.POPULATION.2010 * 0.082
MD.POPULATION.2010.OTHER = MD.POPULATION.2010 - MD.POPULATION.2010.BLACK - MD.POPULATION.2010.HISPANIC

MD.POPULATION = c(
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
    '2020' = 6055802
)
MD.POPULATION.BLACK = MD.POPULATION * 0.294
MD.POPULATION.HISPANIC = MD.POPULATION * 0.082
MD.POPULATION.OTHER = MD.POPULATION - MD.POPULATION.BLACK - MD.POPULATION.HISPANIC

PREVALENCE.RATIO = 32700/27616 # 1.1841 is estimated ratio of all cases to diagnosed ones

calibration.data.frame = data.frame(
    value = c(MD.DIAGNOSES.BLACK, MD.DIAGNOSES.HISPANIC, MD.DIAGNOSES.OTHER,
              MD.PREVALENCE.BLACK, MD.PREVALENCE.HISPANIC, MD.PREVALENCE.OTHER,
              MD.SUPPRESSION),
    year = as.numeric(c(names(MD.DIAGNOSES.BLACK), names(MD.DIAGNOSES.HISPANIC), names(MD.DIAGNOSES.OTHER),
                        names(MD.PREVALENCE.BLACK), names(MD.PREVALENCE.HISPANIC), names(MD.PREVALENCE.OTHER),
                        names(MD.SUPPRESSION))),
    race = c(rep('BLACK', length(MD.DIAGNOSES.BLACK)),
             rep('HISPANIC', length(MD.DIAGNOSES.HISPANIC)),
             rep('OTHER', length(MD.DIAGNOSES.OTHER)),
             rep('BLACK', length(MD.PREVALENCE.BLACK)),
             rep('HISPANIC', length(MD.PREVALENCE.HISPANIC)),
             rep('OTHER', length(MD.PREVALENCE.OTHER)),
             rep(NA, length(MD.SUPPRESSION))),
    type = c(rep('diagnoses', length(MD.DIAGNOSES.BLACK) + length(MD.DIAGNOSES.HISPANIC) + length(MD.DIAGNOSES.OTHER)),
             rep('prevalence', length(MD.PREVALENCE.BLACK) + length(MD.PREVALENCE.HISPANIC) + length(MD.PREVALENCE.OTHER)),
             rep('suppression', length(MD.SUPPRESSION)))
)

# library(ggplot2)
# 
# print(ggplot(calibration.data.frame, aes(x=year, y=value)) +
#           geom_point() +
#        facet_wrap(~type, scales = 'free') + ylim(0,NA))
