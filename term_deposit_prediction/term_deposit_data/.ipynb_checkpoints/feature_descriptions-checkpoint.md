About the dataset 
=================================================================
The data set contains information on direct marketing campaigns of a Portuguese banking institution. The marketing campaigns were based on phone calls. In order to assess whether or not the product (bank term deposit) would be subscribed, often more than one contact to the same client was required.
There are four datasets in total: bank-additional-full.csv (41188 examples with 20 inputs), bank-additional.csv (10% of the examples with 20 inputs), bank-full.csv (all examples with 17 inputs), and bank.csv (10% of the examples with 17 inputs). The classification goal is to predict if a client will subscribe (yes/no) to a term deposit, based on the input variables available.
Attribute Information: Input variables include age, job type, marital status, education, credit in default?, housing loan?, personal loan?, last contact communication type, last contact month of year, last contact day of week, last contact duration in seconds, number of contacts performed during this campaign and for this client, number of days that passed by after the client was last contacted from a previous campaign, number of contacts performed before this campaign and for this client , outcome of the previous marketing campaign , employment variation rate - quarterly indicator , consumer price index - monthly indicator , consumer confidence index - monthly indicator , euribor 3 month rate - daily indicator , and number of employees - quarterly indicator

How to use this dataset 
==========================================================
This dataset is perfect for those who want to predict the success of bank telemarketing campaigns. The data includes information on the age, job, marital status, education, default status, balance, housing status, loan status, contact information, day of week contacted, month contacted, duration of last contact, number of contacts during campaign, number of days since last previous contact outcome and success outcome (yes/no) of each client. With all of this data available to you , you can create a model that accurately predicts whether or not a potential client will subscribe to a term deposit

research ideas 
==========================================================
This dataset could be used to predict the success of a marketing campaign, to identify which customers are most likely to respond positively to a marketing campaign, or to determine which marketing strategies are most effective

feature descriptions 
==========================================================
index: The index of the row.
age: The age of the person.
job: The job of the person.
marital: The marital status of the person.
education: The education level of the person.
default: Whether or not the person has credit in default.
balance: The balance of the person.
housing: Whether or not the person has a housing loan.
loan: Whether or not the person has a personal loan.
contact: The contact communication type of the person.
day: The day of the week of the last contact.
month: The month of the year of the last contact.
duration: The duration of the last contact, in seconds.
campaign: The number of contacts performed during this campaign and for this client.
pdays: The number of days that passed by after the client was last contacted from a previous campaign.
previous: The number of contacts performed before this campaign and for this client.
poutcome: The outcome of the previous marketing campaign.
y: Whether or not the client has subscribed a term deposit