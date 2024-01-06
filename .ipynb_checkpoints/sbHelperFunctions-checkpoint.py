###Library of useful functions for SpringBoard work

import pandas as pd
import numpy as np

# Print the values of df
def dfVals(df):
    return(df.values)

# Print the column index of df
def dfCols(df):
    return (df.columns)

# Print the row index of df
def dfIndex(df):
    return df.index
    
def dfSort(df,colName,ascendingToF):
    return df.sort_values(colName, ascending=ascendingToF)

def filterDf(df,filterData,colName):
    return df[df[colName].isin(filterData)]
                             
def dropDups(df,subsetCols):
    return df.drop_duplicates(subset=subsetCols)

def colCount(df,cols):
    return df[cols].value_counts()

def getColproportion(df,colName,normToF,sortToF):
    
    #Normalize gets proportion
    return df[colName].value_counts(sort=sortToF,normalize=normToF)