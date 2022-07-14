function [bs_income,uav_income,user_outcome] = base_methods(bs,uav,user)
global user_num uav_num bs_num D ...
       relay_ok selected_uav_relay ...%need_bs need_uav
       offload_bs offload_uav offload_relay selected_uav selected_bs
% global M_i M_j F_i m_i f_i
M_i = ones(bs_num,user_num);    % price to the user i @bs
M_j = ones(bs_num,uav_num);     % price to hire the uav j @bs
F_i = zeros(bs_num,user_num);   % the resource allocate to the user i @bs
m_i = ones(uav_num,user_num);   % price to the user i @uav
f_i = zeros(uav_num,user_num);  % reource allocate to the user i @uav
[bs_income,uav_income,user_outcome] = deal(zeros(1,bs_num),zeros(1,uav_num),zeros(1,user_num));
[local,offload_bs,offload_uav,offload_relay]=deal(0.25*ones(user_num,1),0.25*ones(user_num,1),0.25*ones(user_num,1),0.25*ones(user_num,1)); % –∂‘ÿ±»¿˝≥ı ºªØ
[at_local,to_bs,to_uav,by_relay] = deal(zeros(user_num,1),zeros(user_num,1),zeros(user_num,1),zeros(user_num,1));
relay_ok = zeros(bs_num,uav_num); % whether the uav choose to be relay for base station g 
[selected_uav,selected_bs,selected_uav_relay] = deal(zeros(user_num,1),zeros(user_num,1),zeros(user_num,1));
[dis_user_uav,dis_uav_bs,dis_user_bs] = get_distance(uav,user,bs);
[Rate_i_g,Rate_i_j,Rate_j_g_i] = deal(ones(user_num,bs_num),ones(user_num,uav_num),ones(uav_num,bs_num));
converge = false(user_num,1);
%% The Data trans speed subject to the distance between the objects
for b = 1:bs_num
   for i = 1:user_num
       Rate_i_g(i,b) = 1000 / dis_user_bs(i,b);
   end
   for j = 1:uav_num
       Rate_j_g_i(j,b) = 1000 / dis_uav_bs(j,b);
   end
end
for i = 1:user_num
    for j = 1:uav_num
        Rate_i_j(i,j) = 1000 / dis_user_uav(i,j);
    end
end
%% The User associate to the bs & uav nearby
for u = 1:user_num
    [~,selected_bs(u)] = min(dis_user_bs(u,:));
    [~,selected_uav(u)] = min(dis_user_uav(u,:));
    selected_uav_relay(u) = selected_uav(u);
%     need_bs(selected_bs(u)) = 1;need_uav(selected_uav(u)) = 1;
end
%% set the offload rate randomly
for i = 1:user_num
    rand_rate = rand(1,4);
    sum_rand = sum(rand_rate);
    rand_rate = rand_rate / sum_rand;
    [local(i),offload_bs(i),offload_uav(i),offload_relay(i)]=deal(rand_rate(1),rand_rate(2),rand_rate(3),rand_rate(4));
    if offload_relay(i) ~= 0
        relay_ok(selected_bs(i),selected_uav_relay(i)) = 1;
    else
        relay_ok(selected_bs(i),selected_uav_relay(i)) = 0;
    end
end
%% Game of Leader layer: Base station
for b = 1:bs_num
    % alter the price for user i: M_i && the suitable resource: F_i
    for i = 1:user_num
        F_i(b,i)=(offload_bs(i)+offload_relay(i)) * D(i);
        M_i(b,i) = Rate_i_g(i,b);%rand()*50 / 
    end
    % alter the price for uav j : M_j
    for j = 1:uav_num
        M_j(b,j) =  Rate_j_g_i(j,b);%10*rand() /
    end
    % compute the profit of the base station b
    bs_income(b) = utility_base_station(M_i(b,:),M_j(b,:),F_i(b,:),b);
end
%% Game of Vice-leader Layer : UAVs
for u = 1:uav_num
    % alter the price for user i: m_i
    for i = 1:user_num
        f_i(u,i) = offload_uav(i) * D(i);
        m_i(u,i) = Rate_i_j(i,u);%rand()*50 / 
    end
    % compute the profit of the uav j
    uav_income(u) = utility_uav(m_i(u,:),f_i(u,:),Rate_j_g_i(u,:),M_j(:,u),u);
end
%% Game of follower layer: Users
for i = 1:user_num
    [at_local(i),to_bs(i),to_uav(i),by_relay(i)] = ...
        utility_user(M_i(:,i),m_i(:,i),F_i(:,i),f_i(:,i),Rate_i_g,Rate_i_j,Rate_j_g_i,i);
    user_outcome(i) = ...
        local(i) * at_local(i) + offload_bs(i) * to_bs(i) + offload_uav(i) * to_uav(i) + offload_relay(i) * by_relay(i);
end
save base_methods
end