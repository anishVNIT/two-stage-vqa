from sklearn import model_selection
import warnings
import pandas
import scipy.stats
import scipy.io
from sklearn.svm import SVR
from sklearn.metrics import mean_squared_error
import numpy as np
from sklearn.preprocessing import MinMaxScaler

# ignore all warnings
warnings.filterwarnings("ignore")


Feat=pandas.ExcelFile('Feature_Steerabel_LIVEVQC.xlsx')
targ=pandas.ExcelFile('Feature_Steerabel_LIVEVQC.xlsx')
Feat.sheet_names
Features=Feat.parse('Sheet1')
targ.sheet_names
Score=targ.parse('Sheet2')
Features1=Features.values
Scores1=Score.values

#=====================================
X=Features1
y=np.ravel(Scores1)

indices=np.linspace(1, len(Score), num= len(Score))

'''======================== Main Body ===========================''' 

model_params_all_repeats_C = []
model_params_all_repeats_gamma = []

PLCC_all_repeats_test = []
SRCC_all_repeats_test = []
KRCC_all_repeats_test = []
RMSE_all_repeats_test = []

SRCC_all_repeats_test_poly = []
KRCC_all_repeats_test_poly = []
PLCC_all_repeats_test_poly = []
RMSE_all_repeats_test_poly = []

PLCC_all_repeats_train = []
SRCC_all_repeats_train = []
KRCC_all_repeats_train = []
RMSE_all_repeats_train = []

y_test_all_repeats=[]
y_test_pred_all_repeats=[]
y_test_pred_poly_all_repeats=[]
y_test_indices_all_repeats=[]
# #############################################################################
C_range = np.logspace(1, 10, 10, base=2)
gamma_range = np.logspace(-8, 1, 10, base=2)
params_grid = dict(gamma=gamma_range, C=C_range)

# 100 random splits
for i in range(1,101):
    print(i)
    # parameters for each split
    model_params_all = []
    PLCC_all_train = []
    SRCC_all_train = []
    KRCC_all_train = []
    RMSE_all_train = []
    PLCC_all_test = []
    SRCC_all_test = []
    KRCC_all_test = []
    RMSE_all_test = []

    # Split data to test and validation sets randomly   
    test_size = 0.2
    X_train, X_test, y_train, y_test, train_indices, test_indices = \
        model_selection.train_test_split(X, y, indices,test_size=test_size, random_state=i) #math.ceil(2.8*i)
        
    # SVR grid search in the training set only
    validation_size = 0.2
    X_param_train, X_param_valid, y_param_train, y_param_valid = \
        model_selection.train_test_split(X_train, y_train, test_size=validation_size, random_state=i)#math.ceil(3.6*i)
    # grid search
    for C in C_range:
        for gamma in gamma_range:
            model_params_all.append((C, gamma))
            
            
            model = SVR(kernel='rbf', gamma=gamma, C=C)
            # Standard min-max normalization of features
            scaler = MinMaxScaler().fit(X_param_train)
            X_param_train = scaler.transform(X_param_train)

            # Fit training set to the regression model
            model.fit(X_param_train, y_param_train)

            # Apply scaling 
            X_param_valid = scaler.transform(X_param_valid)

            # Predict MOS for the validation set
            y_param_valid_pred = model.predict(X_param_valid)
            y_param_train_pred = model.predict(X_param_train)


            plcc_valid_tmp = scipy.stats.pearsonr(y_param_valid, y_param_valid_pred)[0]
            rmse_valid_tmp = np.sqrt(mean_squared_error(y_param_valid, y_param_valid_pred))
            srcc_valid_tmp = scipy.stats.spearmanr(y_param_valid, y_param_valid_pred)[0]
            krcc_valid_tmp = scipy.stats.kendalltau(y_param_valid, y_param_valid_pred)[0]
            plcc_train_tmp = scipy.stats.pearsonr(y_param_train, y_param_train_pred)[0]
            rmse_train_tmp = np.sqrt(mean_squared_error(y_param_train, y_param_train_pred))
            srcc_train_tmp = scipy.stats.spearmanr(y_param_train, y_param_train_pred)[0]
            try:
                krcc_train_tmp = scipy.stats.kendalltau(y_param_train, y_param_train_pred)[0]
            except:
                krcc_train_tmp = scipy.stats.kendalltau(y_param_train, y_param_train_pred, method='asymptotic')[0]
            # save results
            PLCC_all_test.append(plcc_valid_tmp)
            RMSE_all_test.append(rmse_valid_tmp)
            SRCC_all_test.append(srcc_valid_tmp)
            KRCC_all_test.append(krcc_valid_tmp)
            PLCC_all_train.append(plcc_train_tmp)
            RMSE_all_train.append(rmse_train_tmp)
            SRCC_all_train.append(srcc_train_tmp)
            KRCC_all_train.append(krcc_train_tmp)

    # using the best chosen parameters to test on testing set
    param_idx = np.argmin(np.asarray(RMSE_all_test, dtype=np.float))
    C_opt, gamma_opt = model_params_all[param_idx]
    
   
    model = SVR(kernel='rbf', gamma=gamma_opt, C=C_opt)
    # Standard min-max normalization of features
    scaler = MinMaxScaler().fit(X_train)
    X_train = scaler.transform(X_train)  

    # Fit training set to the regression model
    model.fit(X_train, y_train)

    # Apply scaling 
    X_test = scaler.transform(X_test)

    # Predict MOS for the test set
    y_test_pred = model.predict(X_test)
    y_train_pred = model.predict(X_train)
    y_test = np.array(list(y_test), dtype=np.float)
    y_train = np.array(list(y_train), dtype=np.float)
    
    #Polynomial fitting
    P = np.polyfit(y_train_pred, y_train, 16)
    y_test_pred_poly = np.polyval(P,y_test_pred)

    plcc_test_opt = scipy.stats.pearsonr(y_test, y_test_pred)[0]
    rmse_test_opt = np.sqrt(mean_squared_error(y_test, y_test_pred))
    srcc_test_opt = scipy.stats.spearmanr(y_test, y_test_pred)[0]
    krcc_test_opt = scipy.stats.kendalltau(y_test, y_test_pred)[0]
    
    plcc_test_poly_opt = scipy.stats.pearsonr(y_test, y_test_pred_poly)[0]
    rmse_test_poly_opt = np.sqrt(mean_squared_error(y_test, y_test_pred_poly))
    srcc_test_poly_opt = scipy.stats.spearmanr(y_test, y_test_pred_poly)[0]
    krcc_test_poly_opt = scipy.stats.kendalltau(y_test, y_test_pred_poly)[0]

    plcc_train_opt = scipy.stats.pearsonr(y_train, y_train_pred)[0]
    rmse_train_opt = np.sqrt(mean_squared_error(y_train, y_train_pred))
    srcc_train_opt = scipy.stats.spearmanr(y_train, y_train_pred)[0]
    krcc_train_opt = scipy.stats.kendalltau(y_train, y_train_pred)[0]

    model_params_all_repeats_C.append(C_opt)
    model_params_all_repeats_gamma.append(gamma_opt)
    SRCC_all_repeats_test.append(srcc_test_opt)
    KRCC_all_repeats_test.append(krcc_test_opt)
    PLCC_all_repeats_test.append(plcc_test_opt)
    RMSE_all_repeats_test.append(rmse_test_opt)
    
    SRCC_all_repeats_test_poly.append(srcc_test_poly_opt)
    KRCC_all_repeats_test_poly.append(krcc_test_poly_opt)
    PLCC_all_repeats_test_poly.append(plcc_test_poly_opt)
    RMSE_all_repeats_test_poly.append(rmse_test_poly_opt)
    
    SRCC_all_repeats_train.append(srcc_train_opt)
    KRCC_all_repeats_train.append(krcc_train_opt)
    PLCC_all_repeats_train.append(plcc_train_opt)
    RMSE_all_repeats_train.append(rmse_train_opt)
    
    y_test_all_repeats.append(y_test)#all test MOS in 100 iterations
    y_test_pred_all_repeats.append(y_test_pred)#all predicted test MOS in 100 iterations
    y_test_pred_poly_all_repeats.append(y_test_pred_poly)
    y_test_indices_all_repeats.append(test_indices)
    # print results for each iteration
    print('======================================================')
    print('Best results in CV grid search in one split')
    print('SRCC_train: ', srcc_train_opt)
    print('KRCC_train: ', krcc_train_opt)
    print('PLCC_train: ', plcc_train_opt)
    print('RMSE_train: ', rmse_train_opt)
    print('======================================================')
    print('SRCC_test: ', srcc_test_opt)
    print('KRCC_test: ', krcc_test_opt)
    print('PLCC_test: ', plcc_test_opt)
    print('RMSE_test: ', rmse_test_opt)
    print('======================================================')
    print('SRCC_test_poly: ', srcc_test_poly_opt)
    print('KRCC_test_poly: ', krcc_test_poly_opt)
    print('PLCC_test_poly: ', plcc_test_poly_opt)
    print('RMSE_test_poly: ', rmse_test_poly_opt)
    print('MODEL: ', (C_opt, gamma_opt))
    print('======================================================')
    


y_Test_all_iterations=np.array(y_test_all_repeats)
y_Test_all_iterations=np.transpose(y_Test_all_iterations)

y_Test_predict_all_iterations=np.array(y_test_pred_all_repeats)
y_Test_Predict_all_iterations=np.transpose(y_Test_predict_all_iterations)

y_Test_predict_poly_all_iterations=np.array(y_test_pred_poly_all_repeats)
y_Test_Predict_poly_all_iterations=np.transpose(y_Test_predict_poly_all_iterations)

y_test_indices_all_iterations=np.array(y_test_indices_all_repeats)
y_Test_indices_all_iterations=np.transpose(y_test_indices_all_iterations)
print('\n\n')
print('======================================================')
print('Median training results among all repeated 80-20 holdouts:')
print('SRCC: ',np.median(SRCC_all_repeats_train),'( std:',np.std(SRCC_all_repeats_train),')')
print('KRCC: ',np.median(KRCC_all_repeats_train),'( std:',np.std(KRCC_all_repeats_train),')')
print('PLCC: ',np.median(PLCC_all_repeats_train),'( std:',np.std(PLCC_all_repeats_train),')')
print('RMSE: ',np.median(RMSE_all_repeats_train),'( std:',np.std(RMSE_all_repeats_train),')')
print('======================================================')
print('Median testing results among all repeated 80-20 holdouts:')
print('SRCC: ',np.median(SRCC_all_repeats_test),'( std:',np.std(SRCC_all_repeats_test),')')
print('KRCC: ',np.median(KRCC_all_repeats_test),'( std:',np.std(KRCC_all_repeats_test),')')
print('PLCC: ',np.median(PLCC_all_repeats_test),'( std:',np.std(PLCC_all_repeats_test),')')
print('RMSE: ',np.median(RMSE_all_repeats_test),'( std:',np.std(RMSE_all_repeats_test),')')
print('======================================================')
print('Median poly testing results among all repeated 80-20 holdouts:')
print('SRCC: ',np.median(SRCC_all_repeats_test_poly),'( std:',np.std(SRCC_all_repeats_test_poly),')')
print('KRCC: ',np.median(KRCC_all_repeats_test_poly),'( std:',np.std(KRCC_all_repeats_test_poly),')')
print('PLCC: ',np.median(PLCC_all_repeats_test_poly),'( std:',np.std(PLCC_all_repeats_test_poly),')')
print('RMSE: ',np.median(RMSE_all_repeats_test_poly),'( std:',np.std(RMSE_all_repeats_test_poly),')')
print('======================================================')
print('\n\n')


#Features for 2nd stage regression
#preprocessing, concatenation of MOS values
[m,n]=y_Test_Predict_poly_all_iterations.shape
True_MOS_Appended = np.reshape(y_Test_all_iterations,(m*n,1))
Pred_SVR_MOS_Appended=np.reshape(y_Test_predict_all_iterations,(m*n,1))
Pred_Poly_MOS_Appended = np.reshape(y_Test_Predict_poly_all_iterations,(m*n,1))
Indices_Appended = np.reshape(y_Test_indices_all_iterations,(m*n,1))
indices_unique = np.unique(Indices_Appended)

True_MOS = []
Pred_SVR_MOS = []
Pred_Poly_MOS = []

for i in range(len(indices_unique)):    
    ind = indices_unique[i]
    k=1
    True_MOS_temp = []
    Pred_SVR_MOS_temp = []
    Pred_Poly_MOS_temp = []
    
    for j in range(len(True_MOS_Appended)):
         
        if  Indices_Appended[j] == ind:
            
            True_MOS_temp.append(True_MOS_Appended[j])
            Pred_SVR_MOS_temp.append(Pred_SVR_MOS_Appended[j])
            Pred_Poly_MOS_temp.append(Pred_Poly_MOS_Appended[j])
            k += 1
        
    True_MOS.append(np.median(True_MOS_temp))
    Pred_SVR_MOS.append(np.median(Pred_SVR_MOS_temp))
    Pred_Poly_MOS.append(np.median(Pred_Poly_MOS_temp))




