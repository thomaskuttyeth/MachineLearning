

library(fpp2)
library(GGally)

series1 <- ts(c(123,423,153,523), start = 2018)

data = c(123,143,523,134,524,635,353,244,23,12,42,52,963,535,245)
series2 = ts(data,start = 2021, frequency = 12)


# autoplot 1 
autoplot(melsyd[,"Economy.Class"],color='darkblue',size=0.8)+theme_minimal()+
    ggtitle("Economy Class passengers: Melbourne-Sydney")+
    ylab('Thousands')

# autoplot 2 
autoplot(a10, size = 0.8, color = 'darkblue') +
    ggtitle("Antidiabetic drug sales") +theme_minimal()+
    ylab("$ million") +
    xlab("Year")

# season plot 
ggseasonplot(a10,year.labels = TRUE,year.labels.left = TRUE)+
    ylab('$ million')+theme_minimal()+
    ggtitle('Seasonal plot : antidiabetic drug sales')

# season plot 
ggseasonplot(a10,polar = TRUE)+
    ylab('$ million')+theme_minimal()+
    ggtitle('Seasonal plot : antidiabetic drug sales')

# subseries plot 
ggsubseriesplot(a10,size = 0.8)+ theme_minimal()+
    ylab('$ million')+
    ggtitle('Seasonal subseries plot: antidiabetic drug sales')

# autoplot 
autoplot(elecdemand[,c('Demand','Temperature')],facets = TRUE)+theme_minimal()+
    xlab('Year: 2014')+ylab("")+
    ggtitle('Half-hourly electricity demandf: Victoria,Australia')

# qplot 
qplot(Temperature,Demand,data = as.data.frame(elecdemand))+theme_minimal()+
    ylab('Demand(GW)')+xlab('Temperature(Celsius)')

# autoplot 
autoplot(visnights[,1:5],facets = TRUE,size = 0.9)+
    ylab('Number of visitor nights each quarter (millions)')

# pairplot 
ggpairs(as.data.frame(visnights[,1:5]))

# lag plot 
beer2 <- window(ausbeer, start = 1992)
gglagplot(beer2)


# autocorrelation: 
ggAcf(beer2)

# when data have a trend, auto correlations for small lags tend to be large and positive,
# when data is seasonal, auto correlations will be larger for the seasonal lags. 

data_elec = window(elec,start = 1980)
autoplot(data_elec) + xlab('year')+ylab('GWh')

ggAcf(data_elec,lag = 48)



## white noise 
# time series that show no autocorrelation are called white noise
set.seed(30)
data_y = ts(rnorm(50))
autoplot(data_y,size = 0.8)+ggtitle('White noise')

ggAcf(data_y)

# for white noise, we expect 95% of the spikes in the ACF to 
# lie within +=2/root(T) where T is the length of the time series. 









