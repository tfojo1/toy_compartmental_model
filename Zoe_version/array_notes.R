
### --- Array, Put, and Pull Tutorial for Zoe --- ###

## -- Maybe you already know some of this, but I didn't when I started! -- ##

# - In some places there are problems with answers hidden - #
# - You might have to collapse them first to hide them - #

if (TRUE) {
    # did you remember to hide this before you saw it?
}

# - You can step through the lines of code one by one with " ctrl + Enter " - #
# - but this will also run the hidden code so be aware - #

# - Enjoy! - #
# - -Andrew - #


### --- Section 1: Arrays --- ###

# arrays are just vectors or lists that have extra "attributes"
# that give them a shape

# a matrix is a kind of array that has two dimensions

# let's make one out of a vector

v = c(1:12) # a vector, which has no shape, currently
v

# we can see that a vector has no attributes set currently
attributes(v) # NULL

# this means it is a vector, but not an array or matrix
is.vector(v) # TRUE
is.array(v) # FALSE
is.matrix(v) # FALSE

# now let's make this vector be a 3 by 4 matrix by setting the dim() attribute.
dim(v) = c(3,4) # set the dimensions to be 3 by 4.

v # will print differently on the screen now!

# let's check that v now has the dim attribute set
attributes(v) # you'll see the dim attribute is set

# this means it is an array, and if the there are exactly 2 dimensions, a matrix
is.vector(v) # FALSE
is.array(v) # TRUE
is.matrix(v) # TRUE

# the underlying data is still just the numbers 1 through 12 in order.
# we are free to change the shape - we just reset the dim attribute!
dim(v) = c(4,3)
v

# we can even make it three dimensional if we want.
dim(v) = c(2,3,2)
v
is.matrix(v) # FALSE because we don't have 2 dimensions anymore

# and we can return it to a vector by stripping away the dim dimension
dim(v) = NULL
# or we could just use v = as.vector(v)
v
is.vector(v) #  TRUE
is.array(v) # FALSE
is.matrix(v) # FALSE

# you may have noticed that when we gave our data dimensions, the dimensions
# did not have any names.
# we can name the dimensions by passing a "named vector" to the dim attribute
dim(v) = c(color=3, size=2, sweetness=2)
v # however, those names won't show up until we do a little more work
attributes(v) # you can see it here, though

# For any given dimension, we may want the values in those dimensions
# to have names too. What is the first color? The second color? The two options
# for size or sweetness?

# we can make our array fancier by adding one more attribute -- this one
# totally optional -- called dimnames.
# dimnames has us name all the dimensions and what each option for the dimension
# is called.
# it wants a list of vectors, with dimension names the same as you used for
# the dim attribute, if you named them there.
dimnames(v) = list(
    color=c('orange', 'violet', 'cyan'),
    size=c('normal', 'extralarge'),
    sweetness=c('normal', 'extrasweet'))

# now check out how cool and informative our array is!
v

# you can see that we have two attributes now
attributes(v)

# before we named our dimensions and their dimension values, we had to access
# the data by knowing the indices by number
# for example, the data value for normally sized, extra sweet violet smoothies
# was accessed using v[2,1,2] -- you'd have to remember the order of the values!
v[2,1,2] # this should be 8

# but now we can do the prettier
v['violet', 'normal', 'extrasweet']

# of course, you still have to remember that color comes first and sweetness
# comes last

# technically, since the underlying data is in the same order as it was before
# we added dim and dimnames attributes to it, we could access the same value
# by knowing that it is the eighth element in the data
v[[8]]

# double brackets are for accessing a particular value of the array, like we
# just did.
# maybe we want to just slice the array to get a new one that has only orange
# smoothies because orange is our favorite color.
# we'll use single brackets, which always gives you back a slice of something
v['orange',,] # by leaving the other dimensions blank, we get all their values

# we could also ask for the data for extra large smoothies of either sweetness
# for only violet and cyan smoothies.
# can you figure out how to get this slice?
# can you predict what the dimensions of the resulting array will be?
if (TRUE) {
    slice = v[c('cyan', 'violet'), 'extralarge',]
    dim(slice)
}

# earlier we saw that you can slice arrays using just the number indices for the
# dimensions instead of words like 'orange' if you really wanted to.
# technically, you can also pass a logical vector that says TRUE or FALSE based
# on whether you want to get a certain dimension value
# can you predict what the following slice will get you?
slice = v[c(TRUE, TRUE, FALSE), 1, c('extrasweet')]
if (TRUE) {
    slice
    dim(slice) # are you surprised?
    is.vector(slice)
    is.array(slice) # R assumed we didn't care about the dimensions anymore
    # since only our color dimension has more than one value left
    # this is called 'coercion'. Check out the documentation for the slice
    # operator by typing ?'[' in your console to find an optional argument you
    # could specify during the slice if you really wanted to make sure your
    # output was still an array
}

# you probably won't need to use those other two methods when you can just ask
# for things by name -- but you can if you want to!

# and now that you're an expert on using arrays, let's put that knowledge to use
# with the data manager's pull function!


### --- Section 2: Putting and Pulling --- ###

library(jheem2)

# let's make a data manager and put some home brewed smoothie data to it.
smoothie.manager = create.data.manager('smoothie manager',
                                       'A data manager to store smoothie data')

# let's create some fun data in the form of an array. How about we make data for
# smoothie sales of smoothies for 2 years, 4 colors, and 3 flavors.
# how about we use values like 25000, 27000, 29000, 31000, etc. Obviously way
# off reality, but who cares?
# can you figure out what the original vector of data would be before we add
# the attributes that make it an array?
# Remember that to have every combination of the dimensions, we will need a
# vector that is 2x4x3=24 elements long.
# Making the pattern start at 25000 and go up by 2000 for each next combination
# is potentially a pointless math exercise that  only I enjoy

if (TRUE) {
    data = 25000 + 2000*(1:24)
}

# now let's make it an array by setting our dim attribute
if (TRUE) {
    dim(data) = c(year=2, color=4, flavor=3)
}

# now let's set the dimnames attribute. You can come up with whatever years,
# colors and flavors you want. The just click the example line and run it to
# overwrite your choices with my choices to continue
if (TRUE) {
    dimnames(data) = list(
        year=c('2021', '2022'),
        color=c('green', 'magenta', 'navy', 'brown'),
        flavor=c('fruit', 'milk', 'kale')
    )
}
data

# if your version of RStudio is up to date, the colors will be highlighted with
# their actual colors, which is why this is about smoothies, so that we can
# display lots of beautiful colors on the screen
# other things besides smoothies have colors I guess...
# smoothie aren't even sold by color... just bear with me

# we have some data, but let's do the other standard things we have to do to
# prepare the data manager

smoothie.manager$register.outcome(
    'sales',
    metadata = create.outcome.metadata(
        scale = 'non.negative.number',
        display.name = 'Annual Smoothie Sales',
        description = 'Annual smoothie sales',
        axis.name = 'Annual Sales (n)',
        units = 'smoothies'
    ))

smoothie.manager$register.source(
    'asa',
    full.name = 'American Smoothie Association',
    short.name = 'ASA'
)

# we'll have to register an ontology to describe the data that we'll be putting
smoothie.manager$register.ontology(
    name = 'asa',
    ont = ontology(
        year = NULL,
        color = c('green', 'magenta', 'navy', 'brown'),
        flavor=c('fruit', 'milk', 'kale')
    )
)

# note that color and flavor are 'complete' dimensions, meaning that every
# smoothie has to have one of those colors and one of those flavors.
# year, in contrast, is an 'incomplete' dimension, meaning we can put data for
# all sorts of years. There are no particular years data *MUST* be for.
# setting a dimension to NULL when you register an ontology is another way of
# telling the ontology that the dimension should be incomplete.

# now we're ready to put the data!

# let's go ahead and put all of it in.
# Want to try it yourself? Use 'www.smoothies4all.org' for the url argument and
# 'ASA reporting' for the details argument.
# Don't worry about the dimension.values argument for the moment. You do have to
# include it, but just give it a blank list with " list() ".
if (TRUE) {
    put.data(
        smoothie.manager,
        data,
        outcome = 'sales',
        source = 'asa',
        ontology.name = 'asa',
        dimension.values = list(),
        url = 'www.smoothies4all.org',
        details = 'ASA reporting'
    )
}

# If it didn't work, you should get an error message telling you what was wrong.
# If the message wasn't helpful, let me know so that I can write a better error
# message!

# Now our data manager should have data in it. Let's try asking for that data
# back.

# We'll have to learn a few things about how the pull function likes to be asked
# for data.
# First of all, it always wants to know what outcome you are asking about.
# We can try asking it for the sales data like this:

z = pull.data(
    smoothie.manager,
    outcome = 'sales')

# Let's see what we got
z

# Oops! We got NULL back. Why is that?
# This is because our request was valid but wasn't what we thought it was.

# If we want the data that is returned to us to be broken out by year, color,
# and flavor like our input data was, we'll have to ask for that by using the
# 'keep.dimensions' argument of the pull function.

z = pull.data(
    smoothie.manager,
    outcome = 'sales',
    keep.dimensions = c('year', 'color', 'flavor')
)
z

# There we go! Now we're seeing what we expected!
# The output has 'kept' the year, color, and flavor dimensions.

# The output is an array, which you can verify by examining its attributes.
attributes(z)
is.array(z) #TRUE

# Did you notice that there is a fourth dimension called 'source'?
# If there was data from multiple sources that would get us what we wanted,
# the pull function would have given all of it to us, labeled by dimension.

# Now say we just want the the smoothie sales of milk-flavored smoothies.
# We could slice that output array like we learned to above.
# Remember that source is now a fourth dimension!
# Try it!
if (TRUE) {
    slice = z[,,'milk',]
    slice
}

# This is totally fine to do, but the pull function itself has a built in way to
# slice the data for you!

# If we just wanted milk flavor data, we can use the 'dimension.values'
# argument to say that we'll be slicing the flavor dimension.
z = pull.data(
    smoothie.manager,
    outcome = 'sales',
    keep.dimensions = c('year', 'color', 'flavor'),
    dimension.values = list(flavor='milk')
)
z

# This is how jheem2 aficionados do it!

# Notice that since we only have one flavor in the output, we don't really need
# it to tell us that the flavor is milk.
# It would be the same for us to leave flavor out of keep.dimensions.
y = pull.data(
    smoothie.manager,
    outcome = 'sales',
    keep.dimensions = c('year', 'color'),
    dimension.values = list(flavor='milk')
)
y

# Almost the same, that is.
# Can you see what's technically different between the two results? Check their
# attributes.
if (TRUE) {
    attributes(z)
    attributes(y)
}

# Now let's do something else cool. What if we want to know what combined sales
# of green and magenta smoothies were in 2021?
# First try to get the slice without worrying about combining anything.
if (TRUE) {
    z = pull.data(
        smoothie.manager,
        outcome = 'sales',
        keep.dimensions = c('year', 'color', 'flavor'),
        dimension.values = list(year='2021', color=c('magenta', 'green'))
    )
    z
}

# Now for the puzzle.
# Can you guess how we can use 'keep.dimensions' to aggregate the green and
# magenta smoothie sales numbers?
if (TRUE) {
    z = pull.data(
        smoothie.manager,
        outcome = 'sales',
        keep.dimensions = c('year', 'flavor'),
        dimension.values = list(year='2021', color=c('magenta', 'green'))
    )
    z
}

# Voila! By slicing over color with 'dimension.values' but omitting color from
# 'keep.dimensions', the pull function figured out that we want to aggregate
# over color.

# Experiment with aggregating other values and dimensions if you want!

# Before we get too excited about aggregation, let's consider some pitfalls
# that could happen if we keep using the pull function to aggregate for us this
# way.

# With real life public health data, I mean.

# As an epidemiologist, you'll be well aware of how data suppression can mean
# that adding up all the stratified data sometimes won't come out the same as
# a published total value.
# So if the CDC has a published value for the total prevalence for Baltimore in
# 2014, you'd rather use that value for the total instead of whatever you get
# when you add up the prevalence for each race/sex/risk combination.

# In light of this, when you ask for a total or sum value across all of some
# dimension, the pull function can look for a verified total value for you if
# you want it to.

# To use the silly smoothie example where data suppression doesn't make much
# sense, imagine we want to know the total smoothie sales in 2022 for all colors
# and flavors.
# Using our strategy above, we could use 'dimension.values' to slice the color
# and flavor dimensions where the slice is actually every option, and then
# exclude color and flavor from 'keep.dimensions'.

z = pull.data(
    smoothie.manager,
    outcome = 'sales',
    keep.dimensions = c('year'),
    dimension.values = list(
        year='2022',
        color=c('magenta', 'brown', 'green', 'navy'),
        flavor=c('milk', 'fruit', 'kale'))
)
z

# This is the equivalent of what we DON'T want to do with data that may be
# partially suppressed.
# We'd prefer if the American Smoothie Association published its 2022 sales
# total.
# Maybe it did! Let's say the ASA announced that the total sales in 2022 was
# 640000 smoothies. Let's put this to the data manager with the same url and
# details as before.

# Note that we'll have to tell it that this data is only for the year 2022.
# Can you guess which argument we'll use to specify that?
if (TRUE) {
    put.data(
        smoothie.manager,
        640000,
        outcome = 'sales',
        source = 'asa',
        ontology.name = 'asa',
        dimension.values = list(year='2022'),
        url = 'www.smoothies4all.org',
        details = 'ASA reporting'
    )
}

# Now we should be able to ask the data manager for the 2022 total by omitting
# any mention of the dimensions except year, in 'dimension.values'.
z = pull.data(
    smoothie.manager,
    outcome = 'sales',
    dimensions.values = list(year='2022')
)
z

# This will come out the same whether you put year in 'keep.dimensions' or not,
# because incomplete dimensions will always be kept.

# Say we want to find the total smoothie sales for year 2021. If we make the
# same request but with year equals 2021 in 'dimension.values', will the data
# manager aggregate its data to get us an answer since we never put a total
# value for 2021?
# What's your guess?
if (TRUE) {
    z = pull.data(
        smoothie.manager,
        outcome = 'sales',
        dimension.values = list(year='2021')
    )
    z
    # No! The data manager will never aggregate data unless you explictly ask it
    # to with the slicing without keeping method we did earlier.
    # So you never have to worry about it aggregating partially suppressed data!
    # It will simply give you nothing if it can't find genuine totals.
}


### --- Conclusion --- ###

# Now you're an expert in using the put and pull functions! There is still more
# you can do with it, and I encourage you to explore. What does it look like
# when you put data from multiple sources that all match a pull request?
# What will happen when your query matches data with differeing ontologies?
# How do you ask for data from only one source or ontology? How do you put only
# some of the data you've got? How do you know when you are overwriting existing
# data and when you aren't?

# There are several arguments in the pull function that are only relevant for
# the internal use of the pull function, that is, to get data and convert it to
# the ontology the model always uses.

# That goes back to the big picture of what the data is for. The JHEEM model
# will simulate prevalence, new diagnoses, and potentially other outcomes by
# running real world data through a differential equation model of disease.

# As you'll learn with the toy compartmental model, the model projections are in
# part determined by a set of parameters like force of infection, testing rate,
# and proportion suppressed. Those parameters need to be calibrated so that the
# model mirrors reality as closely as possible. For calibration, we compare the
# simulated outcome for each year with the real-life outcome. That may mean we
# are comparing the simulated prevalence for individual compartments like
# Hispanic, MSM IDUs in Baltimore in 2008 with their real-life reported
# prevalence. This means the simulation will need to pull the relevant data from
# the data manager to check whether it is doing a good job. It will use the pull
# function the same way you did today, aside from the fact that it will want the
# result to be mapped to its favorite ontology. And it will be using the pull
# function over 5 million times per metropolitan statistical area!

# So the more curated and reliable data you put into the data manager, the more
# likely it will be that the simulation engine can find what it needs to produce
# realistic and helpful projections!

# I hope this was helpful for you, and please let me know if you have any
# questions about anything at all. This might have been more than you need to
# know since you won't technically need the pull function at all for your work.
# You also might not need to know about arrays since your data is usually in
# data frame format when you import it from a csv, and the put.long.form()
# function lets you bypass converting it to an array before you put it.

# The pull function is my first contribution to JHEEM as a member of this team,
# so it's the only thing I can claim to be an expert in right now. I look
# forward to learning lots from you as you get settled in!

# Best, Andrew
