clear;clc;
global uav_num user_num bs_num D resource_bs resource_uav resource_user power_user power_uav
epoch = 300; % 迭代次数
bs_num = 2;uav_num = 6;user_num = 8;%16;
resource_bs = 65536; % 基站的总资源量
resource_uav = [8096;8096;8096;8096;8096;8096];% randi(8192,uav_num,1); % 每架无人机的计算资源量
power_uav = [5,5,5,5,5,5];%randi(10,1,uav_num); % 发射功率p_i p_j
resource_user = [32;32;32;32;32;32;32;32];%;128;128;128;128;128;128;128;128];% randi(256,user_num,1); % 每个用户本地具有的计算资源量
power_user = [8,8,8,8,8,8,8,8];%,8,5,6,8,12,11,12,10];
% D = [673;978;768;843;663;808;966;843];%;424;798;364;999;712;818;684;908]; % 随机生成的每个用户任务量   situation01
% D = [408;673;843;616;543;463;408;616;543;424;798;364;712;818;420;908]; % 随机生成的每个用户任务量   situation02 bingo
D = [843;616;543;463;408;616;543;424]; % 随机生成每个用户任务量   situation03
% user =[197,522;527,169;576,650;360,632;655,368;304,387;772,601;532,416];%;943,44;906,965;127,158;914,971;633,958;98,486;279,801;547,142];    % 用户坐标 situation-01
% user =[815,958;906,965;127,158;914,971;633,958;98,486;279,801;547,142;576,650;60,732;235,648;354,451;815,958;132,16;943,43;906,965]; % 用户坐标 situation-02
user =[633,958;98,486;859,801;547,142;576,650;60,732;235,648;354,451];  % 用户坐标 situation-03
uav = [[250,250];[250,750];[500,250];[500,750];[750,250];[750,750]]; % randi(1000,uav_num,2); % 无人机坐标
bs = [[250,500];[750,500]]; % 基站的坐标
% methods compare
[random_bs,random_uav,random_user] = base_methods(bs,uav,user);
sum_random = sum(random_bs,2) + sum(random_uav,2) - sum(random_user,2);
%% Stackelberg methods
[Stackelberg_bs,Stackelberg_uav,Stackelberg_user] = stackelberg_game(bs,uav,user,epoch);
sum_stackelberg = sum(Stackelberg_bs,2) + sum(Stackelberg_uav,2) - sum(Stackelberg_user,2);
%% figure out
% figure of base station
figure
subplot(2,2,1);
plot(1:epoch,Stackelberg_bs(:,1),'color','[1.00,0.41,0.16]','Marker','hexagram','linestyle','--');hold on
plot(1:epoch,Stackelberg_bs(:,2),'color','[0.07,0.62,1.00]','Marker','o','linestyle','--');%hold on
% plot(1:epoch,max_bs(1)*ones(epoch,1),'^-b');hold on
% plot(1:epoch,max_bs(2)*ones(epoch,1),'*-b');
title('Iterative Convergence Process of Base Station')
xlabel('iterations')
ylabel('The Profit of Base Station')
legend('BS1','BS2');%,'基站1-max','基站2-max'
% figure of each uav
subplot(2,2,2);
plot(1:epoch,Stackelberg_uav(:,1),'color','[0.64,0.08,0.18]','Marker','<','linestyle','--');hold on
plot(1:epoch,Stackelberg_uav(:,2),'color','[0.47,0.67,0.19]','Marker','>','linestyle','--');hold on
plot(1:epoch,Stackelberg_uav(:,3),'color','[0.50,0.50,0.50]','Marker','o','linestyle','--');hold on
plot(1:epoch,Stackelberg_uav(:,4),'color','[0.15,0.15,0.15]','Marker','x','linestyle','--');hold on
plot(1:epoch,Stackelberg_uav(:,5),'color','[0.30,0.75,0.93]','Marker','*','linestyle','--');hold on
plot(1:epoch,Stackelberg_uav(:,6),'color','[0.93,0.69,0.13]','Marker','diamond','linestyle','--');
title('Iterative Convergence Process of UAV')
xlabel('iteartions')
ylabel('The Profit of UAV')
legend('UAV1','UAV2','UAV3','UAV4','UAV5','UAV6');
% figure of each user
subplot(2,2,3);
plot(1:epoch,Stackelberg_user(:,1),'color','[0.00,0.45,0.74]','Marker','>','linestyle','--');hold on
plot(1:epoch,Stackelberg_user(:,2),'color','[0.47,0.67,0.19]','Marker','diamond','linestyle','--');hold on
plot(1:epoch,Stackelberg_user(:,3),'color','[0,0,0]','Marker','<','linestyle','--');hold on
plot(1:epoch,Stackelberg_user(:,4),'color','[1.00,0.41,0.16]','Marker','pentagram','linestyle','--');hold on
plot(1:epoch,Stackelberg_user(:,5),'color','[0,1,1]','Marker','v','linestyle','--');hold on
plot(1:epoch,Stackelberg_user(:,6),'color','[1.00,0.07,0.65]','Marker','^','linestyle','--');hold on
plot(1:epoch,Stackelberg_user(:,7),'color','[0.72,0.27,1.00]','Marker','square','linestyle','--');hold on
plot(1:epoch,Stackelberg_user(:,8),'color','[0.93,0.69,0.13]','Marker','*','linestyle','--');
title('Iterative Convergence Process of User')
xlabel('iteartions')
ylabel('The Cost of User')
legend('user1','user2','user3','user4',...
       'user5','user6','user7','user8')
% figure of sum profit
subplot(2,2,4);
plot(1:epoch,sum_random*ones(1,epoch),'color','[0.07,0.62,1.00]','Marker','|','linestyle','--');hold on
plot(1:epoch,sum_stackelberg,'color','[1.00,0.41,0.16]','Marker','o','linestyle','--');
title('Iterative Convergence Process of Total Profit')
xlabel('iteration')
ylabel('Profit Totally')
legend('RANDOM','SGA')
%% save enivorment
load stackelberg_RL.mat