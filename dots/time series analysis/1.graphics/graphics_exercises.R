
library(GGally)
library(fpp2)

# ----------------------------------------------------------------------------------
# question 1 
# explore what the series gold, woolyrng and gas represent
# use autoplot to plot each of these in separate plots 
# what is the frequency of each series? ( use frequency function)
# use which.max() to spot the outlier in the gold series. Which observation was it? 
# ----------------------------------------------------------------------------------
help(gold)
tsdisplay(gold)
autoplot(gold,size = 0.8) + theme_minimal()

help(woolyrnq)
tsdisplay(woolyrnq)
autoplot(woolyrnq,size = 0.8)+theme_minimal()

help(gas)
tsdisplay(gas)
autoplot(gas,size = 0.8)+theme_minimal()

# getting frequency of time series 
frequency(gold) # yearly data 
frequency(woolyrnq) # quarterly 
frequency(gas) # monthly 

# outlier which.max() function 
which.max(gold)  # gives the index 
gold[770]   # the highest values in the gold series 

#-----------------------------------------------------------------------------------
# question 2 
# download tute1.csv, loading the data, changing to time series, plotting
# ----------------------------------------------------------------------------------
tute1 <- read.csv('tute1.csv', header = TRUE)
View(tute1)
mytimeseries = ts(tute1[,-1], start = 1981, frequency = 4)
autoplot(mytimeseries,facets = TRUE,size=0.8)


#---------------------------------------------
# question 3 
# download retail.xlsx data, load, 
#--------------------------------------------
retail_data = readxl::read_excel('retail.xlsx',skip = 1)
myts = ts(retail_data[,'A3349873A'],frequency = 12,start= c(1982,4))
autoplot(myts,size = 0.8)
ggseasonplot(myts)
ggsubseriesplot(myts)
gglagplot(myts)
ggAcf(myts)
# significant autocorrelation at lag 12
# has both trend and seasonality 

# interpreting ggseasonplot 
ggseasonplot(AirPassengers,year.labels=TRUE, continuous=TRUE)





