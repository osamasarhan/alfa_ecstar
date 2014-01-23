%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Script assessing the ANFIS' performances for  
%   Papers2012/GECCO_2012_GF_ABP paper (informal comparison with the 
%   genetic programming results)
%
%   Use:
%          First run the python script merge_data_packages-data1.0.py, 
%          which will output several txt files that this Matlab script
%          needs.
%          Configure gpconfig.m
%          
%   Input:
%          None
%   Output:
%          ANFIS' performances 
%
%   Author: Franck Dernoncourt for MIT EVO-DesignOpt research group
%    Email: franck.dernoncourt@gmail.com
%     Date: 2013-01-24 (creation)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Set up user data
% ----------------

% load cleaned files
data = csvread('patient_a41770.csv');
% data = csvread(horzcat('patient_all', '.csv'), 0, 0);
data = bsxfun(@rdivide,data,std(data));
% data = csvread('MW22-Jul-201223h30m.csv');


x = data(:, 1:end-1);
y = data(:, end);

% gp.userdata.xtrain=x(1001:2000,:); %training set (inputs)safety
% gp.userdata.ytrain=y(1002:2001,1); %training set (output)
% gp.userdata.xtest=x(1:100,:); %testing set (inputs)
% gp.userdata.ytest=y(2:101,1); %testing set (output)



xtrain=x(1:15000,:); %training set (inputs)
ytrain=y(1:15000,1); %training set (output)
xtest=x(15000:end,:); %testing set (inputs)
ytest=y(15000:end,1); %testing set (output)
training_set=data(1:15000, :);
testing_set=data(15000:end, :);
%  
% xtrain=x(1:700000,:); %training set (inputs)
% ytrain=y(1:700000,1); %training set (output)
% xtest=x(700000:850000,:); %testing set (inputs)
% ytest=y(700000:850000,1); %testing set (output)


% data = [rand(10,1) 10*rand(10,1)-5 rand(10,1)];

% numMFs is a vector whose coordinates specify the number of membership functions associated with each input. If you want the same number of membership functions to be associated with each input, then specify numMFs as a single number.
numMFs = [3 3 3 3 3];

% inmftype is a string array in which each row specifies the membership function type associated with each input. This can be a one-dimensional single string if the type of membership functions associated with each input is the same.
mfType = char('gaussmf','gaussmf','gaussmf','gaussmf','gaussmf');

% outmftype is a string that specifies the membership function type associated with the output. There can only be one output, because this is a Sugeno-type system. The output membership function type must be either linear or constant. The number of membership functions associated with the output is the same as the number of rules generated by genfis1.
outmftype = 'linear';

% genfis1 generates a Sugeno-type FIS structure used as initial conditions (initialization of the membership function parameters) for anfis training.
fismat = genfis1(data,numMFs,mfType, outmftype);

[x,mf] = plotmf(fismat,'input',1);
subplot(2,1,1), plot(x,mf);
xlabel('input 1 (pimf)');
[x,mf] = plotmf(fismat,'input',2);
subplot(2,1,2), plot(x,mf);
xlabel('input 2 (trimf)');

% Train the fuzzy inference system
epoch_n = 5;
in_fis = fismat ;
out_fis = anfis(training_set,in_fis,epoch_n);

% Plot the fuzzy inference system's predictions
figure
xtest = testing_set(:, 1:end-1);
ytest = testing_set(:, end);

evalfis(training_set(:, 1:end-1), out_fis)

plot( 1:length(xtest), evalfis(xtest, out_fis));

plot(1:length(xtest), ytest, 1:length(xtest), evalfis(xtest, out_fis));
legend('Training Data','ANFIS Output');



% 
% x = (0:0.1:10)';
% y = sin(2*x)./exp(x/5);
% trnData = [x y];
% numMFs = 5;
% mfType = 'gbellmf';
% epoch_n = 20;
% in_fis = genfis1(trnData,numMFs,mfType);
% out_fis = anfis(trnData,in_fis,20);
% plot(x,y,x,evalfis(x,out_fis));
% legend('Training Data','ANFIS Output');
% 