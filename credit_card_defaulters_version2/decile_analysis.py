import pandas as pd
import matplotlib.pyplot as plt  
from sklearn.metrics import recall_score


def decile_df(y_test,probs):
    '''
    y_test consists of binary classes, probs are the predicted probabilities of class 1 
    input: y_test, probabilities of default class 
    output: dataframe[decile,no_responders,no_individuals,response_rate,% of responders]
    '''
    result_df = pd.DataFrame()
    result_df['y_actual'] = y_test
    result_df['probabilities'] = probs
    result_df = result_df.sort_values(by = ['probabilities'], ascending = False)
    result_df['deciles'] = pd.qcut(result_df['probabilities'],10,labels = False)
    
    # creating the final df 
    deciles = result_df.deciles.unique()
    final_frame = pd.DataFrame()
    final_frame['decile'] = deciles 
    
    responders = []
    decile_counts = []
    for i in deciles:
        no_responders = result_df.groupby('deciles').get_group(i)['y_actual'].sum() 
        no_individuals = result_df.groupby('deciles').get_group(i).count()[0]
        responders.append(no_responders)
        decile_counts.append(no_individuals)
    final_frame['no_responders'] = responders 
    final_frame['no_individuals'] = decile_counts
    final_frame['response_rate'] = (final_frame['no_responders']/final_frame['no_individuals'])*100
    final_frame['% of responders'] = (final_frame['no_responders']/y_test.sum())*100
    
    return final_frame

def get_cum_gain_df(decile_df):
    '''
    input: output of decile_df function 
    output : dataframe[cum_individuals,cum_repsonse,gain, lift value]
    '''
    df = pd.DataFrame()
    cum_individuals = []
    sum_ = 0
    for i in decile_df.no_individuals:
        sum_+=i
        cum_individuals.append(sum_)
    cum_responses = []
    sum__ = 0
    for i in decile_df.no_responders:
        sum__+=i
        cum_responses.append(sum__)
    df['cum_individuals'] = cum_individuals
    df['cum_reponses'] = cum_responses
    df['gain'] = (df['cum_reponses']/520)*100
    df['lift_value'] = df['gain']/[i for i in range(10,110,10)]
    return df


def plot_lift_gain(df,y_test,probs):
    fig, (ax1, ax2) = plt.subplots(1, 2,figsize=(10,4))
    # fig.suptitle('Cumulative Gain and Lift Charts')
    
    result = decile_df(y_test,probs)
    y = get_cum_gain_df(result)['gain']
    x = [i for i in range(10,110,10)]
    ax1.plot(x,y)
    ax1.plot(x,x)
    
    cum_gain_df = get_cum_gain_df(result)
    lift_values = cum_gain_df.lift_value
    random_lift = [1 for i in range(len(lift_values))]
    ratio_of_customers = [i for i in range(10,110,10)]
    ax2.plot(ratio_of_customers,lift_values)
    ax2.plot(ratio_of_customers,random_lift)
    ax1.set_xticks(x, minor=False)
    ax2.set_xticks(x, minor=False)
    ax1.set_title('Cumulative Gain')
    ax2.set_title('Lift Chart')

    ax1.set(xlabel='% of customers contacted', ylabel='gain')
    ax2.set(xlabel='% of customers contacted', ylabel = 'lift value')

def Model_training(models):
    training_scores = {}
    testing_scores = {}
    testing_recall_scores = {}
    training_recall_scores = {}
    for model in models:
        m = model()
        m.fit(X_train,y_train)
        y_pred_test = m.predict(X_test)
        y_pred_train = m.predict(X_train)
        
        # average scores 
        training_score = m.score(X_train,y_train)
        testing_score = m.score(X_test,y_test)
        training_scores[model.__name__] = training_score
        testing_scores[model.__name__] = testing_score
        
        # recall measures 
        training_recall = recall_score(y_train,y_pred_train)
        testing_recall = recall_score(y_test,y_pred_test)
        
    
        training_recall_scores[model.__name__] = training_recall
        testing_recall_scores[model.__name__] = testing_recall
    
    measurements = pd.DataFrame()
    measurements.index = training_scores.keys()
    measurements['training_scores'] = training_scores.values()
    measurements['testing_scores'] = testing_scores.values()
    measurements['training_recalls'] = training_recall_scores.values()
    measurements['testing_recalls'] = testing_recall_scores.values()
    
    return measurements