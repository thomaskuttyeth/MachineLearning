
library(fpp2)
library(GGally)

data = read.csv("1.graphics/tute1.csv",header = TRUE)
myts = ts(data[,-1],frequency = 4)
y = myts[,'Sales']
forecasted_quarters1 = meanf(y,4) # average method : mean of all observation 
forecasted_quarters2 = naive(y,4) # naive method : last observation
forecasted_quarters3 = snaive(y,4) # seasonal naive method 

# a variation on the naive method is to allow the forecasts to increase or decrease
# over time, where the amount of change over time(drift) is set to be the average change
# seen in the historical data. 
# y_(t+h|T) = y_t + h((y_t-y_1)/(T-1))
forecasted_quarters4 = rwf(y,4,drift = TRUE) # drift method 

# applying the forecasted methods in the beer production data 
beer2 = window(ausbeer, start = 1992,end = c(2007,4))
autoplot(beer2,size = 0.8)+
    autolayer(meanf(beer2,h = 11),size = 0.8,series = "Meanf",PI =FALSE)+
    autolayer(naive(beer2,h = 11),size = 0.8, series = "Naive", PI = FALSE)+
    autolayer(snaive(beer2,h = 11),size = 0.8, series = "SNaive",PI = FALSE)+
    ggtitle('Forecasts for quarterly beer production')+
    xlab('Year')+ylab('Megalitres')+guides(color = guide_legend(title = 'Forecast'))
    
# forecasting methods on goog200 data 
autoplot(goog200)+
    autolayer(meanf(goog200,h = 40),series = 'Mean',PI = FALSE)+
    autolayer(rwf(goog200,drift = TRUE,h = 40),series = 'Drift',PI = FALSE)+
    autolayer(rwf(goog200,h = 40),series = 'Drift',PI = FALSE)+
    ggtitle('Google stock (daily ending 6 Dec 2013)')+
    xlab('Day')+ylab('Closing Price(US$)')+
    guides(color = guide_legend(title = 'Forecasts'))

# calender adjustments - milk production graph
dframe <- cbind(Monthly = milk,DailyAverage=milk/monthdays(milk))
autoplot(dframe,facet=TRUE,size = 0.8,color = 'blue')+
    xlab('Years')+ylab('Pounds')+
    ggtitle('Milk production')+theme_minimal()

# Note: by looking at the average daily production instead of the average monthly production, 
# we effectively remove the variation due to the different month lengths.
# simple patterns are usually easier to model and lead to more accurate forecasts.


# population adjustments 
# any data that are affected by population changes can be adjusted to give per capita data.
# It is possible for the total number of beds to increase, but the number of beds per thousands people to decrease.
# this occurs when the population is increasing faster than the number of hospital beds 
# for most data that are affected by population changes, it is best to use per capita data rather than the totals 


# inflation adjustments 
# a $200,000 house this year is not the smae as a $200,000 house twenty yeras ago.
# we use price index for making the adjustments.
# for consumer goods, a common price index is the Consumer Price Index ( or CPI )

# Mathematical transformations 
# logarithmic transformation 
# power transformations 
# box-cox transformation 
# having chosen a transformation, we need to forecast the transformed data. 
# then we reverse the transformation ( back-transform) to obtain original forecasts


autoplot(elec)

lambda = BoxCox.lambda(elec)
autoplot(BoxCox(elec,lambda))


# bias adjustments 
fc <- rwf(eggs, drift=TRUE, lambda=0, h=50, level=80)
fc2 <- rwf(eggs, drift=TRUE, lambda=0, h=50, level=80,
           biasadj=TRUE)
autoplot(eggs,size = 0.8) +
    autolayer(fc,size = 0.8, series="Simple back transformation") +
    autolayer(fc2,size = 0.8, series="Bias adjusted", PI=FALSE) +
    guides(colour=guide_legend(title="Forecast"))







