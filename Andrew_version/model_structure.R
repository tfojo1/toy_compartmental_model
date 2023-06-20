
#CAPS FOR CONSTANTS globally accessible
STATE.DIM.NAMES = list(
    continuum = c('UNINFECTED', 'UNDIAGNOSED', 'DIAGNOSED'),
    race=c('BLACK','HISPANIC','OTHER')
)

CUMULATIVE.DIM.NAMES = STATE.DIM.NAMES[-1] #take all but first

# seemingly unnecessary function if we have to make a new array when we fill it
# with initial values
get.empty.state = function()
{
    array(0, dim=sapply(STATE.DIM.NAMES, length), dimnames = STATE.DIM.NAMES)
}

set.state = function(data)
{
    array(data, dim=sapply(STATE.DIM.NAMES, length), dimnames = STATE.DIM.NAMES)
}