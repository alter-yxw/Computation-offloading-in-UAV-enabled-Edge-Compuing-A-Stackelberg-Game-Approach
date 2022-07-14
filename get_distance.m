function [user_uav,uav_bs,user_bs] = get_distance(uav,user,bs)
%   获取用户-无人机-基站的距离信息
global user_num uav_num bs_num
user_uav = zeros(user_num,uav_num);
uav_bs = zeros(uav_num,bs_num);
user_bs = zeros(user_num,bs_num);
distance = @(x,y)sqrt((x(1)-y(1))^2 + (x(2)-y(2))^2); % 求距离的函数式
for i = 1:user_num
    for j = 1:uav_num
       user_uav(i,j) = distance(user(i,:),uav(j,:)); 
    end
    for k = 1:bs_num
       user_bs(i,k) = distance(user(i,:),bs(k,:));
    end
end
for s = 1:uav_num
    for r = 1:bs_num
        uav_bs(s,r) = distance(uav(s,:),bs(r,:));
    end
end
end