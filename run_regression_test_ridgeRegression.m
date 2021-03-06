%% Loading data - Fit parameters
% First fitting
close all
clear all
clc

K = 5;
alpha = 0.1;
lambda = 1e-7;
[X_train, y_train, X_test_1, ind_test_1] = load_regression_data(0);
tX = [ones(size(y_train)) X_train];

betaLS_1 = ridgeRegression(y_train, tX, lambda);
rmseTr_1 = computeCostRMSE(y_train, tX, betaLS_1);
fprintf(1,'RMSE using LeastSquares ridge regression for the first fitting: %3.3f\n', rmseTr_1);

[meanTrainError_1, meanValidationError_1]= KfoldCV(K, tX, y_train, 'ridgeRegression', alpha, lambda);
fprintf(1, '\nTrain error: %3.3f\nValidation error: %3.3f\n\n', meanTrainError_1, meanValidationError_1);

% Second fitting
clearvars X_train y_train

K = 5;
[X_train, y_train, X_test_2, ind_test_2] = load_regression_data(1);
tX = [ones(size(y_train)) X_train];

betaLS_2 = ridgeRegression(y_train, tX, lambda);
rmseTr_2 = computeCostRMSE(y_train, tX, betaLS_2);
fprintf(1,'RMSE using LeastSquares ridge regression for the second fitting: %3.3f\n', rmseTr_2);

[meanTrainError_2, meanValidationError_2]= KfoldCV(K, tX, y_train, 'ridgeRegression', alpha, lambda);
fprintf(1, '\nTrain error: %3.3f\nValidation error: %3.3f\n\n', meanTrainError_2, meanValidationError_2);

%% Prediction of the test data
M = size(X_test_1,1) + size(X_test_2,1);
y_test = zeros(M,1);
tX_test_1 = [ones(size(X_test_1,1),1) X_test_1];
tX_test_2 = [ones(size(X_test_2,1),1) X_test_2];
for i = 1 : length(ind_test_1)
    y_test(ind_test_1(i)) = tX_test_1(i,:) * betaLS_1;
end
for i = 1 : length(ind_test_2)
    y_test(ind_test_2(i)) = tX_test_2(i,:) * betaLS_2;
end

X_test(ind_test_1, :) = X_test_1;
X_test(ind_test_2, :) = X_test_2;
% for i = 1 : size(X_test,2)
%     figure;
%     scatterhist(X_test(:,i), y_test);
%     pause;
%     close;
% end

csvwrite('predictions_classification.csv', y_test);

test_error = size(X_test_1,1)/size(X_test,1) * meanValidationError_1 + size(X_test_2,1)/size(X_test,1) * meanValidationError_2;
fprintf(1,'\nPredicted RMSE for the test data: %3.3f\n', test_error);
