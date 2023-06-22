
# model_structure

# fill this in!
STATE.DIM.NAMES = list(
  continuum= c('UNINFECTED', 'UNDIAGNOSED', 'DIAGNOSED')
)

# puzzle: how can we get the dims from the dimnames using "sapply"?

# a function to let us initialize the state
set.state = function(data) {
  array(data, dim=c(3), dimnames= STATE.DIM.NAMES)
     # replace this line
    # return an array of our data with the right dims and dimnames#
}