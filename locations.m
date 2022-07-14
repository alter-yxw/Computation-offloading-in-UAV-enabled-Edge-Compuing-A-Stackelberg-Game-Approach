figure
scatter(bs(:,1)',bs(:,2)','MarkerFaceColor','[0.93,0.69,0.13]','MarkerEdgeColor','none','Marker','diamond');hold on
scatter(uav(:,1)',uav(:,2)','MarkerFaceColor','[0.07,0.62,1.00]','MarkerEdgeColor','[0.07 0.62 1.00]','Marker','*');hold on
scatter(user(:,1)',user(:,2)','MarkerFaceColor','[0.39,0.83,0.07','MarkerEdgeColor','[0.39 0.83 0.07]','Marker','pentagram')
scatter([0,0,1000,1000],[0,1000,0,1000],'w.')
legend('基站','无人机','用户')


result = zeros(4,2);
result(1,1) = sum_random;
result(2,1) = sum_stackelberg(248);
%% figure out
% record different scenario
% 8719.019841	14211.41864	7129.945034	9569.104652
% 17923.11397	20933.28837	13034.04 	19709.81959
bar(result)