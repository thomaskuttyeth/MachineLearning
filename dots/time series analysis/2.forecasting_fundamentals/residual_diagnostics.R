
library(fpp2)
library(GGally)

# Residuals are useful in checking whether a model has adequately captured the information in the data.
# A good forecasting method will yield residuals with the following properties; 
# * The residuals are uncorrelated. If there are correlations between residuals, 
# then there is information left in the residuals which should be used in computing forecasts. 
# * The residuals have zero mean. If the residuals have a mean other than zero, then the forecasts are biased.

# If the residuals have mean m, then simply add m to all forecasts and the bias problem is solved.
# Fixing the correlation problem is harder

# * The residuals have constant variance. 
# * The residuals are normally distributed.

# The best forecasting method for stock market prices and indexes is the naive method. 
# Hence the residuals are simply equal to the difference between consecutive observations;

autoplot(goog200,color= 'blue')+
    xlab('Day')+ylab('Closing Price(US$)')+
    ggtitle('Google Stock(daily ending 6 December 2013)')

# getting the residuals 
res <-  residuals(naive(goog200))
autoplot(res,color = 'blue') + xlab('Day')+ylab("")+
    ggtitle('Residuals from naive method')

# histogram of residuals 
gghistogram(res)+ggtitle('Histogram of residuals')

ggAcf(res) + ggtitle("ACF of residuals")

# NOTE: Portmanteau tests for autocorrelation 
# when we look at the acf plot to see whether each spike is within the required limits, 
# we are implicitly carrying out multiple hypothesis tests, each one with a small probability 
# of giving a false positive. In order to overcome this problem, we test whether the first h 
# auto correlations are significantly different from what would be expected from a white noise process.


# Box-Pierce test and Ljung-Box test
# null hypothesis = the auto correlations come from the white noise 
# large statistic indicates ( smaller p value ) that the auto correlations do not come from a white noise series.


Box.test(res,lag = 10,fitdf = 0) # fitdf = 0 since, naive method has no parameters
Box.test(res,lag = 10,fitdf = 0, type = 'L')

checkresiduals(naive(goog200))

# explanations plots 
#=========================================
# These graphs show that the naive method produces forecasts that appear to account
# for all available information. The mean of the residuals is close to zero and there 
# is no significant correlation in the residuals series. The time plot of the residuals 
# shows that the variation of the residuals stays much the same across the historical data, 
# apart from the one outlier, and therefore the residual variance can be treated as constant. 
# This can also be seen on the histogram or the residuals. The histogram suggests that the 
# residuals may not be normal the right tail seems a little too long even when we ignore the outlier. 
# Consequently, forecasts from this method will probably be quite good, but prediction intervals 
# that are computed assuming a normal distribution may be inaccurate.



# functions to subset a time series 
window(ausbeer,start = 1995,end = c(2000,4))

subset(ausbeer,start = length(ausbeer)-4*4)
tail(ausbeer, 3*2)
# forecast errors
# residuals : calculated from the training set 
# forecast errors : calculated from the test data 

# scale dependent errors
  # mean absolute error 
  # root mean squared error 

# percentage errors are unit free : used to compare forecasts performance between datasets 
  # mean absolute percentage error

# scaled errors 
beer2 <- window(ausbeer,start=1992,end=c(2007,4))
beerfit1 <- meanf(beer2,h=10)
beerfit2 <- rwf(beer2,h=10)
beerfit3 <- snaive(beer2,h=10)
autoplot(window(ausbeer, start=1992)) +
    autolayer(beerfit1, series="Mean", PI=FALSE) +
    autolayer(beerfit2, series="Naïve", PI=FALSE) +
    autolayer(beerfit3, series="Seasonal naïve", PI=FALSE) +
    xlab("Year") + ylab("Megalitres") +
    ggtitle("Forecasts for quarterly beer production") +
    guides(colour=guide_legend(title="Forecast"))

beer3 <- window(ausbeer, start=2008)
accuracy(beerfit1, beer3)
accuracy(beerfit2, beer3)
accuracy(beerfit3, beer3)
# time series cross validations 
# pipe operator 
# using toCSV()
# prediction intervals 
# one step prediction intervals 
# multi-step prediction intervals 
# prediction intervals from bootsraped residuals 
# prediction intervals with transformations 
# the forecast package fucntionalities 





