
clear all
data = load('Rome_regression.mat');
D = size(data.X_train,2);

indices = (data.y_train < 4500);
y_train_all = data.y_train(indices);
X_train_all = data.X_train(indices,:);

percentage = 0.75;
N = round(percentage * size(X_train_all,1));
X_train = X_train_all(1:N,1:(D -6));
y_train = y_train_all(1:N,1);



hist(y_train)

%% Compute mean and std of the training set
X_mean = mean(X_train);
X_std = std(X_train);


%% Normalize the data to have 0 mean and 1 std
X_mean_rep = repmat(X_mean,[N, 1]);
X_std_rep = repmat(X_std,[N,1]);
X_train_normalised = X_train - X_mean_rep;
X_train_normalised = X_train_normalised ./ X_std_rep;

tX = [ones(size(y_train)) X_train_normalised];
betaLS = leastSquares(y_train, tX);
rmseTr = computeCostMSE(y_train, tX, betaLS);
rmseTr = sqrt(rmseTr)

beta0 = mean(y_train);
err = computeCostMSE(y_train, ones(size(y_train))*beta0, 1);
err = sqrt(err)

N = size(X_train,1) + 1;
X_valid = X_train_all(N+1:end,1:(D -6));
y_valid = y_train_all(N+1:end,1);

N = size(X_valid,1);
X_mean_rep = repmat(X_mean,[N, 1]);
X_std_rep = repmat(X_std,[N,1]);
X_valid_normalised = X_valid - X_mean_rep;
X_valid_normalised = X_valid_normalised ./ X_std_rep;

tX = [ones(size(y_valid)) X_valid_normalised];
rmseTrVa = computeCostMSE(y_valid, tX, betaLS);
rmseTrVa = sqrt(rmseTrVa)

err = computeCostMSE(y_valid, ones(size(y_valid))*beta0, 1);
err = sqrt(err)




