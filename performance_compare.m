clear;clc;
global uav_num user_num bs_num D resource_bs resource_uav resource_user power_user power_uav
epoch = 400; % 迭代次数
bs_num = 2;uav_num = 6;user_num = 8;
resource_bs = 65536; % 基站的总资源量
resource_uav = 8096 * ones(1,uav_num);% randi(8192,uav_num,1); % 每架无人机的计算资源量
resource_user = 32 * ones(1,user_num);
power_user = 8 * ones(1,user_num);
power_uav = [5,5,5,5,5,5];%randi(10,1,uav_num); % 发射功率p_i p_j
bs = [[250,500];[750,500]]; % 基站的坐标
uav = [[250,250];[250,750];[500,250];[500,750];[750,250];[750,750]]; % randi(1000,uav_num,2); % 无人机坐标

% D = [923;378];           % 2users
% user =[797,22;571,569];  % 2users
% D = [673;978;768;843];                      % 4users
% user =[497,522;527,169;576,650;360,632];    % 4users
% D = [673;978;768;843;408;616;543;424];                                   % 8users-before
D = [843;616;543;463;408;616;543;424];                                   % 8users
% D = [971,609,720,303,460,49,386,362];                                    % 8users   D2  convergence iteration>300
% D = [288,817,451,807,791,283,169,255];                                   % 8users   D3 convergence iteration>300
% D = [638,425,906,418,255,540,938,661];                                   % 8users   D4
% D = [543;463;408;616;543;424;798;364];                                   % 8users   D5
% user =[497,522;527,169;576,650;360,632;598,486;279,801;547,142;576,650]; % 8users-before
% user =[633,958;98,486;859,801;547,142;576,650;60,732;235,648;354,451]; % 8users
% user =[563,521;751,226;10,568;477,999;251,132;308,955;967,124;209,187]; % 8users   location2
% user =[647,707;129,948;82,383;660,693;28,603;986,776;540,592;374,377];  % 8users   location3
% user =[851,499;226,950;797,954;997,733;282,385;711,41;665,583;415,565]; % 8users   location4
user =[873,384;286,31;657,858;232,604;622,848;76,505;967,8;610,920]; % 8users   location5

% D = [408;673;843;616;543;463;408;616;543;424;798;364];                                                 % 12users
% user =[815,958;906,965;127,158;914,971;633,958;98,486;279,801;547,142;576,650;60,732;235,648;354,451]; % 12users
% 
% D = [408;673;843;616;543;463;408;616;543;424;798;364;712;818;420;908];                                                               % 16users
% user =[815,958;906,965;127,158;914,971;633,958;98,486;279,801;547,142;576,650;60,732;235,648;354,451;815,958;132,16;943,43;906,965]; % 16users

%all-local method
profit_local = all_local();
% methods compare
[random_bs,random_uav,random_user] = base_methods(bs,uav,user);
sum_random = sum(random_bs,2) + sum(random_uav,2) - sum(random_user,2);
%% Stackelberg methods
[Stackelberg_bs,Stackelberg_uav,Stackelberg_user] = stackelberg_game(bs,uav,user,epoch);
sum_stackelberg = sum(Stackelberg_bs,2) + sum(Stackelberg_uav,2) - sum(Stackelberg_user,2);
%% figure out
% figure of base station
figure
plot(1:epoch,sum_stackelberg,'color','[1.00,0.41,0.16]','Marker','o','linestyle','--');hold on
plot(1:epoch,sum_random*ones(1,epoch),'color','[0.07,0.62,1.00]','Marker','diamond','linestyle','--');hold on
plot(1:epoch,profit_local*ones(1,epoch),'color','[0.15,0.15,0.15]','Marker','diamond','linestyle','--');
title('Iterative Convergence Process of Total Profit')
xlabel('iterations')
ylabel('Profit')
legend('SGA','RANDOM','LOCAL')
%% save enivorment
load stackelberg_RL.mat
%% data recorder
%         user_num1  user_num2   user_num3   user_num4   user_num5
% SGA     7218.27    10112.5     19880       23330       33719
% RANDOM  2744       6284        11365       17547       18744
% LOCAL   1340       6880        9399        14130       20159


%           D1         D2          D3          D4          D5x`
% SGA       19880      14355       11237       16534       15753
% RANDOM    11365      5971        10405       9377        12247
% LOCAL     9399       8142        8144        10084       8772

%           locatoin1   location2   location3   location4   location5
% SGA       19880       14309       17809       15930       14871
% RANDOM    11365       8327        7438        13525       9571
% LOCAL     9399        9399        9399        9399        9399



