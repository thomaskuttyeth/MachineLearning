from matplotlib import pyplot as plt
import numpy as np 
import pandas as pd
from sklearn.metrics import accuracy_score, confusion_matrix, f1_score,precision_score, recall_score
from sqlalchemy import asc
def threshold_analysis(model,x,y,no_thresh):
    pred_probs = model.predict_proba(x)
    thresholds = np.linspace(0.10,0.9,num = no_thresh)
    thresholds = [np.round(i,2) for i in thresholds]
    output = pd.DataFrame(columns=['threshold','accuracy','precision','f1score','recall','tp','tn','fp','fn'])
    
    for j in range(len(thresholds)):
        final_predictions = []
        for i in pred_probs:
            if i[1]>thresholds[j]:
                final_predictions.append(1)
            else:
                final_predictions.append(0)
        cm = confusion_matrix(y,final_predictions)
        tn,fp,fn,tp = cm.ravel() 
        scores = [
            thresholds[j],
            accuracy_score(y,final_predictions),
            f1_score(y,final_predictions),
            precision_score(y,final_predictions),
            recall_score(y,final_predictions),
            tp,tn,fp,fn
        ]
        output.loc[j] = scores 
    return output 

def decile_df(X,y,classifier,minimum_probabilities = None):
    dec_df = pd.DataFrame(index=X.index)
    dec_df['proba'] = classifier.predict_proba(X)[:,1]
    dec_df['churn'] = y 
    if minimum_probabilities is not None:
        minimum_probabilities = list(minimum_probabilities)
        minimum_probabilities.insert(0,1)
        minimum_probabilities.append(0)
        prob_pairs = []
        for i in range(len(minimum_probabilities)):
            if i<len(minimum_probabilities)-1:
                prob_pairs.append(tuple([minimum_probabilities[i],minimum_probabilities[i+1]]))
        no_of_actual_responses = []
        no_of_customers = []
        hh = dec_df 
        for i in range(len(prob_pairs)):
            b = (hh[(hh['proba']>prob_pairs[i][1])].merge(hh[(hh['proba']<prob_pairs[i][0])])['churn'].sum())
            s = hh[(hh['proba']>prob_pairs[i][1])].merge(hh[(hh['proba']<prob_pairs[i][0])])['churn'].shape 
            no_of_customers.append(s[0])
            no_of_actual_responses.append(b)
        out = pd.DataFrame()
        out['min_proba'] = [i[1] for i in prob_pairs]
        out['max_proba'] = [i[0] for i in prob_pairs]
        out['no_of_customers'] = no_of_customers
        out['no_of_responses'] = no_of_actual_responses
        cumulative_responses = []
        cum_ = 0 
        for i in out['no_of_responses']:
            cum_+=i
            cumulative_responses.append(cum_) 
        out['cumulative_responses'] = cumulative_responses
        out['% of events'] = (out.no_of_responses/out.no_of_responses.sum())*100
        out['gain'] = out['% of events'].cumsum() 
        out = out.loc[:9,:]
        out['deciles'] = [i for i in range(1,11)]
        out['lift'] = np.round((out.gain/(out.deciles*10)),2)
        out = out.drop('deciles',axis =1 )
        return out 
    if not minimum_probabilities:
        dec_df = dec_df.sort_values(by = 'proba',ascending=False)
        dec_df['decile'] = pd.qcut(dec_df['proba'],10,labels = [i for i in range(10,0,-1)])
        res = pd.DataFrame()
        decile = [i for i in dec_df['decile'].unique()]
        no_of_classes = []
        no_of_responses = []
        max_proba = []
        min_proba = []

        for i in dec_df['decile'].unique():
            no_of_classes.append(len(dec_df.groupby('decile').get_group(i)))
            no_of_responses.append(int(dec_df.groupby('decile').get_group(i).sum()['churn']))
            max_proba.append(dec_df.groupby('decile').get_group(i)['proba'].max())
            min_proba.append(dec_df.groupby('decile').get_group(i)['proba'].min())

        res['decile'] = decile 
        res['no_of_classes'] = no_of_classes 
        res['no_of_responses'] = no_of_responses 
        res['max_proba'] = max_proba 
        res['min_proba'] = min_proba 
        cumulative_responses =[]
        cum_=0
        for i in res['no_of_responses']:
            cum_+=i 
            cumulative_responses.append(cum_)
        res['cumulative_responses'] = cumulative_responses 
        res['% of events'] = (res.no_of_responses/res.no_of_responses.sum())*100
        res['gain'] = res['% of events'].cumsum() 
        res['lift'] = np.round((res.gain/(res.decile*10)),2)
        return res 


def plt_bar_gain_lift(vdm):
    plt.figure(figsize = (15,4))
    plt.subplot(1,2,1)
    plt.bar(x = [str(i) for i in range(1,11)], height = vdm.gain,color = 'maroon')
    plt.gca().axes.yaxis.set_visible(False)
    plt.title('Cumulative Gain vs Deciles',pad = 20)
    plt.box(False)
    for index,data in enumerate(vdm.gain):
        plt.text(x = index-0.4,y = data+0.7, s = str(np.round(data,1))+'%' , fontdict = dict(fontsize = 10))
    plt.title('Lift vs Deciles',pad = 20)
    plt.show() 
def plt_gain_lift(vdm,thresh = 94,label_position = 5):
    plt.figure(figsize = (10,3))
    plt.subplot(1,2,1)
    plt.plot([str(i) for i in range(1,11)],vdm.gain, color = 'maroon')
    for index,data in enumerate(vdm.gain):
        if data<thresh:
            plt.text(x = index,y = data+label_position, s = str(np.round(data,1))+'%', fontdict = dict(fontsize = 10))
    plt.ylabel('Gain')
    plt.box(False)
    plt.subplot(1,2,2) 
    plt.plot([str(i) for i in range(1,11)], vdm.lift,color = 'maroon')
    for index,data in enumerate(vdm.lift):            
        plt.text(x = index,y = data+label_position, s = str(np.round(data,1))+'%', fontdict = dict(fontsize = 10))
    plt.ylabel('Lift')
    plt.box(False)
    plt.tight_layout()
    plt.show() 


    