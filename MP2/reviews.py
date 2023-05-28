engine='python'
import nltk
import sys
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
#for text pre-processing
import re, string
import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.stem import SnowballStemmer
from nltk.corpus import wordnet
#from nltk.stem import WordNetLemmatizernltk
nltk.download('punkt')
nltk.download('averaged_perceptron_tagger')
nltk.download('wordnet')
nltk.download('stopwords')
from nltk.stem import WordNetLemmatizer


#For feature extraction
from sklearn.feature_extraction.text import TfidfVectorizer

#For Model
from sklearn.model_selection import train_test_split
from sklearn.svm import LinearSVC
from sklearn import model_selection, naive_bayes, svm
from sklearn.metrics import accuracy_score

nltk.download('omw-1.4')
nltk.download('words')

import argparse
import os

def preprocess(text):
    # text = text.lower() #Lower case 
    text=text.strip()  #Remove whitespaces
    text=re.compile('<.*?>').sub('', text) 
    text = re.compile('[%s]' % re.escape(string.punctuation)).sub(' ', text)  #Remove punctuation
    text = re.sub('\s+', ' ', text)  #any character
    text = re.sub(r'\[[0-9]*\]',' ',text) 
    text=re.sub(r'[^\w\s]', '', str(text).strip())
    text = re.sub(r'\d',' ',text) 
    text = re.sub(r'\s+',' ',text) # Eliminate duplicate whitespaces using wildcards
    return text

not_remove=['not','no',"Don't","don't","aren't","couldn't",'aren','couldn','didn',
 "didn't",
 'doesn',
 "doesn't",
 'hadn',
 "hadn't",
 'hasn',
 "hasn't",
 'haven',
 "haven't",
 'isn',
 "isn't",'mightn',
 "mightn't",
 'mustn',
 "mustn't",
 'needn',
 "needn't",
 'shan',
 "shan't",
 'shouldn',
 "shouldn't",
 'wasn',
 "wasn't",
 'weren',
 "weren't",
 'won',
 "won't",
 'wouldn',
 "wouldn't", 'but','out','off','up','down','same','few','most','just',
 'than','for','too','so','under','this','that','all','never','ever','many']
stopw =[i for i in nltk.corpus.stopwords.words('english') if i not in not_remove]

def stopword(string):
    a= [i for i in string.split() if i not in stopw]
    return ' '.join(a)

# Initialize the lemmatizer
wl = WordNetLemmatizer()
 
# This is a helper function to map NTLK position tags
def get_wordnet_pos(tag):
    if tag.startswith('J'):
        return wordnet.ADJ
    elif tag.startswith('V'):
        return wordnet.VERB
    elif tag.startswith('N'):
        return wordnet.NOUN
    elif tag.startswith('R'):
        return wordnet.ADV
    else:
        return wordnet.NOUN# Tokenize the sentence

def lemmatizer(string):
    word_pos_tags = nltk.pos_tag(word_tokenize(string)) # Get Parts of Speech tags
    a=[wl.lemmatize(tag[0], get_wordnet_pos(tag[1])) for idx, tag in enumerate(word_pos_tags)] 
    # Map the position tag and lemmatize the word/token
    return " ".join(a)

def finalpreprocess(string):
    return lemmatizer(stopword(preprocess(string)))

def load_data (file):
    #rawData = open(file).read()
    data = pd.read_csv(file, sep='=\t', names=['label', 'body_text'], header=None)
    data["label"] = data["label"] + '='
    data['clean_text'] = data['body_text'].apply(lambda x: finalpreprocess(x))
    return data

def predict(train,test):
    X_train = np.array(train['clean_text'])
    Y_train = np.array(train['label'])
    
    X_test = np.array(test['clean_text'])
    Y_test = np.array(test['label'])
    

    tfidf_vect = TfidfVectorizer( tokenizer=None, ngram_range=(1,2), min_df=1)
    X_train_tfidf = tfidf_vect.fit_transform(X_train)
    X_test_tfidf = tfidf_vect.transform(X_test)

    SVM = svm.SVC(C=1, kernel='linear', degree=3, gamma='auto')
    SVM.fit(X_train_tfidf,Y_train)# predict the labels on validation dataset
    predictions_SVM = SVM.predict(X_test_tfidf)
    for pred in predictions_SVM:
    	print(pred)
    

ap = argparse.ArgumentParser()
ap.add_argument("-test", "--test", required=True)
ap.add_argument("-train", "--train", required=True)
args = vars(ap.parse_args())

train = load_data(args["train"])
test = load_data(args["test"])
y_pred = predict(train,test)
    
    
    
