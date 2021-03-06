function [cost, grad] = computeRMSECostGradRegression(y, tX, beta, lambda)
    cost = computeCostRMSE(y, tX, beta) + lambda * sum(beta(2,:).^2);
    beta_n = [0; beta(2:end)];
    grad = computeGradient(y, tX, beta) + 2*lambda * beta_n;
end

