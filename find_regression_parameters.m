%% Find parameters alpha for gradient search

close all
clear all
clc
[X_train, y_train, ~] = load_regression_data(1);
close all
N = size(X_train,1);
tX = [ones(N,1) X_train];

alpha = 0.001:0.005:0.2;
meanTrainError = zeros(length(alpha),1);
meanValidationError = zeros(length(alpha),1);
K = 5;
for i=1:length(alpha)
 [meanTrainError(i), meanValidationError(i)]= KfoldCV(K, tX, y_train, 'leastSquaresGD', alpha(i));
 fprintf(1, 'Train and Validation error %3.3f, %3.3f\n', meanTrainError(i), meanValidationError(i));
end

subplot(2,1,1);
plot(alpha, meanTrainError, 'b', 'LineWidth', 2);
hx = xlabel('alpha');
hy = ylabel('Train RMSE');
set(gca,'fontsize',14,'fontname','Helvetica','box','off','tickdir','out','ticklength',[.02 .02],'xcolor',0.5*[1 1 1],'ycolor',0.5*[1 1 1]);
set([hx; hy],'fontsize',14,'fontname','avantgarde','color',[.3 .3 .3]);
xlim([0.001 0.2]);
ylim([0 250]);
grid on;
subplot(2,1,2);
plot(alpha, meanValidationError, 'r', 'LineWidth', 2);
hx = xlabel('alpha');
hy = ylabel('Test RMSE');
set(gca,'fontsize',14,'fontname','Helvetica','box','off','tickdir','out','ticklength',[.02 .02],'xcolor',0.5*[1 1 1],'ycolor',0.5*[1 1 1]);
set([hx; hy],'fontsize',14,'fontname','avantgarde','color',[.3 .3 .3]);
xlim([0.001 0.2]);
ylim([100 250]);
grid on;

fprintf(1, '\nMean Train and Validation error %3.3f, %3.3f\n\n', mean(meanTrainError), mean(meanValidationError));
[min_tr, min_tr_ind] = min(meanTrainError);
[min_val, min_val_ind] = min(meanValidationError);
fprintf(1, 'Minimum Train error %3.3f for alpha = %f\n', min_tr, alpha(min_tr_ind) );
fprintf(1, 'Minimum Validation error %3.3f for alpha = %f\n\n', min_val, alpha(min_val_ind) );

%% Find lambda for penalized ridge regression

clear all
close all;

[X_train, y_train, X_test] = load_regression_data(0);

N = size(X_train,1);
tX = [ones(N,1) X_train];

alpha = 0.1;
lambda = logspace(-7,-1,1000);
meanTrainError = zeros(length(lambda),1);
meanValidationError = zeros(length(lambda),1);
K = 2;
for i=1:length(lambda)
 [meanTrainError(i), meanValidationError(i)]= KfoldCV(K, tX, y_train, 'ridgeRegression', alpha, lambda(i));
 fprintf(1, 'Train and Validation error %3.3f, %3.3f\n', meanTrainError(i), meanValidationError(i));
end

subplot(2,1,1);
semilogx(lambda, meanTrainError, 'b', 'LineWidth', 2);
hx = xlabel('lambda');
hy = ylabel('Train RMSE');
set(gca,'fontsize',14,'fontname','Helvetica','box','off','tickdir','out','ticklength',[.02 .02],'xcolor',0.5*[1 1 1],'ycolor',0.5*[1 1 1]);
set([hx; hy],'fontsize',14,'fontname','avantgarde','color',[.3 .3 .3]);
xlim([10^-7 0.1]);
ylim([50 450]);
grid on;
subplot(2,1,2);
semilogx(lambda, meanValidationError, 'r', 'LineWidth', 2);
hx = xlabel('lambda');
hy = ylabel('Test RMSE');
set(gca,'fontsize',14,'fontname','Helvetica','box','off','tickdir','out','ticklength',[.02 .02],'xcolor',0.5*[1 1 1],'ycolor',0.5*[1 1 1]);
set([hx; hy],'fontsize',14,'fontname','avantgarde','color',[.3 .3 .3]);
xlim([10^-7 0.1]);
ylim([50 450]);
grid on;

fprintf(1, '\nMean Train and Validation error %3.3f, %3.3f\n\n', mean(meanTrainError), mean(meanValidationError));
[min_tr, min_tr_ind] = min(meanTrainError);
[min_val, min_val_ind] = min(meanValidationError);
fprintf(1, 'Minimum Train error %3.3f for lamdda = %f\n', min_tr, lambda(min_tr_ind) );
fprintf(1, 'Minimum Validation error %3.3f for lambda = %f\n\n', min_val, lambda(min_val_ind) );

%%
DP = 10;
meanTrainError = zeros(DP,1);
meanValidationError = zeros(DP,1);
 
K = 7;

% best d is 5
 for d =1:DP
       lambda =1e-4;
       Xp = myPoly(X_train(:,1:43), d);
       tX = [ones(N,1) X_train(:,44:end) Xp];% X_train(:,44:end)];
       %tX = [ones(N,1) myPoly(X_train,d)];
      [meanTrainError(d), meanValidationError(d)]= KfoldCV(K, tX, y_train, 'ridgeRegression', alpha, lambda);
 
 end  
 close all
  figure
 plot(sqrt(meanTrainError), '*');
hold on;
plot(sqrt(meanValidationError),'o');
    meanTrainError
    meanValidationError
 fprintf(1, 'Train and Validation error %3.3f, %3.3f\n', mean(meanTrainError), mean(meanValidationError));
