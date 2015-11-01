D = csvread('iris.csv');

X_train = D(:, 1:2);
y_train = D(:, end); 
k=[1,2,3,5,10,15];
for p=1:6
pred=[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
m=1;
% setup meshgrid
[x1, x2] = meshgrid(2:0.01:5, 0:0.01:3);
grid_size = size(x1);
X12 = [x1(:) x2(:)];

% compute 1NN decision 
n_X12 = size(X12, 1);
decision = zeros(n_X12, 1);
for i=1:n_X12    
    point = X12(i, :);
    
    % compute euclidan distance from the point to all training data
    dist = pdist2(X_train, point);
    
    % sort the distance, get the index
    [~, idx_sorted] = sort(dist);
    
    % find the class of the nearest neighbour
    while m<=k(p)
        pred(m) = y_train(idx_sorted(m));
        m=m+1;
    end
    m=1;
    decision(i) = mode(pred(m:k(p)));
end
figure;
% plot decisions in the grid
decisionmap = reshape(decision, grid_size);
imagesc(2:0.01:5, 0:0.01:3, decisionmap);
set(gca,'ydir','normal');

% colormap for the classes
% class 1 = light red, 2 = light green, 3 = light blue
cmap = [1 0.8 0.8; 0.8 1 0.8; 0.8 0.8 1];
colormap(cmap);

% satter plot data
hold on;
scatter(X_train(y_train == 1, 1), X_train(y_train == 1, 2), 10, 'r');
scatter(X_train(y_train == 2, 1), X_train(y_train == 2, 2), 10, 'g');
scatter(X_train(y_train == 3, 1), X_train(y_train == 3, 2), 10, 'b');
hold off;
end