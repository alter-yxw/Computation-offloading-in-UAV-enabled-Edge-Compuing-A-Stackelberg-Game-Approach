function [bs_income,uav_income,user_outcome] = stackelberg_game_copy(bs,uav,user,epoch)
global user_num uav_num bs_num D 
global relay_ok selected_uav_relay%need_bs need_uav
global offload_bs offload_uav offload_relay selected_uav selected_bs
% global M_i M_j F_i m_i f_i
M_i = ones(bs_num,user_num);    % price to the user i @bs
M_j = ones(bs_num,uav_num);     % price to hire the uav j @bs
F_i = zeros(bs_num,user_num);   % the resource allocate to the user i @bs
m_i = ones(uav_num,user_num);   % price to the user i @uav
f_i = zeros(uav_num,user_num);  % reource allocate to the user i @uav
[M_i_low,M_i_high] = deal(ones(bs_num,user_num),1.5*ones(bs_num,user_num));
[M_j_low,M_j_high] = deal(ones(bs_num,uav_num),1.5*ones(bs_num,uav_num));
[m_i_low,m_i_high] = deal(ones(uav_num,user_num),1.5*ones(uav_num,user_num));
[bs_income,uav_income,user_outcome] = deal(zeros(epoch,bs_num),zeros(epoch,uav_num),zeros(epoch,user_num));
[local,offload_bs,offload_uav,offload_relay]=deal(0.25*ones(user_num,1),0.25*ones(user_num,1),0.25*ones(user_num,1),0.25*ones(user_num,1)); % 卸载比例初始化
[at_local,to_bs,to_uav,by_relay] = deal(zeros(user_num,1),zeros(user_num,1),zeros(user_num,1),zeros(user_num,1));
relay_ok = zeros(bs_num,uav_num); % whether the uav choose to be relay for base station g 
[selected_uav,selected_bs] = deal(zeros(user_num,1),zeros(user_num,1));
% [need_bs,need_uav] = deal(zeros(bs_num,user_num),zeros(uav_num,user_num));
[dis_user_uav,dis_uav_bs,dis_user_bs] = get_distance(uav,user,bs);
[Rate_i_g,Rate_i_j,Rate_j_g_i] = deal(ones(user_num,bs_num),ones(user_num,uav_num),ones(uav_num,bs_num));
[record_1,record_2,record_3,record_4] = deal(zeros(user_num,epoch),zeros(user_num,epoch),zeros(user_num,epoch),zeros(user_num,epoch));
[Record,Record_2] = deal(zeros(user_num,bs_num,epoch),zeros(user_num,uav_num,epoch));
%% The Data trans speed subject to the distance between the objects
for b = 1:bs_num
   for i = 1:user_num
       Rate_i_g(i,b) = 1000/dis_user_bs(i,b);
   end
   for j = 1:uav_num
       Rate_j_g_i(j,b) = 1000/dis_uav_bs(j,b);
   end
end
for i = 1:user_num
    for j = 1:uav_num
        Rate_i_j(i,j) = 1000/dis_user_uav(i,j);
    end
end
%% The User associate to the bs & uav nearby
for u = 1:user_num
    [~,selected_bs(u)] = min(dis_user_bs(u,:));
    [~,selected_uav(u)] = min(dis_user_uav(u,:));
%     need_bs(selected_bs(u)) = 1;need_uav(selected_uav(u)) = 1;
end
%% Game Iteration
for episode = 1:epoch
    now = episode;
    %% Game of Leader layer: Base station
    for b = 1:bs_num
        % alter the price for user i: M_i && the suitable resource: F_i
        for i = 1:user_num
            F_i(b,i)=(offload_bs(i)+offload_relay(i)) * D(i);
            if  b == selected_bs(i)  && (offload_bs(i) + offload_relay(i) > 0)
                M_i_low(b,i) = M_i(b,i);
                if M_i_low(b,i) > M_i_high(b,i)
                    M_i_low(b,i) = M_i_high(b,i);
                end
                M_i(b,i) = 4 * M_i(b,i);
                if M_i(b,i) >= 100%(D(i) / Rate_i_g(i,b))
                    M_i(b,i) = 100;%D(i) / Rate_i_g(i,b);
                end
            else
                M_i_high(b,i) = M_i(b,i);
                M_i(b,i) = (M_i_high(b,i)+M_i_low(b,i)) / 2;
            end
            Record(i,b,now) = M_i(b,i);
        end
        % alter the price for uav j : M_j
        for j = 1:uav_num
            if relay_ok(b,j) == 1
                if M_j(b,j) < M_j_high(b,j)
                    M_j_high(b,j) = M_j(b,j);
                end
                M_j(b,j) = (M_j_high(b,j)+M_j_low(b,j)) / 2;
            else 
                M_j_low(b,j) = M_j(b,j);
                M_j(b,j) = M_j(b,j) * 4;
                if M_j_low(b,j) > M_j_high(b,j)
                    temp = M_j_low(b,j);
                    M_j_low(b,j) = M_j_high(b,j);
                    M_j_high(b,j) = temp;
                end
            end
            if M_j(b,j) >= 50 %/ Rate_j_g_i(j,b)
                M_j(b,j) = 50; %/ Rate_j_g_i(j,b);
            end
        end
        % compute the profit of the base station b
        bs_income(episode,b) = utility_base_station(M_i(b,:),M_j(b,:),F_i(b,:),b);
    end
    %% Game of Vice-leader Layer : UAVs   
    for u = 1:uav_num
        % alter the price for user i: m_i
        for i = 1:user_num
            f_i(u,i) = offload_uav(i) * D(i);
            if u == selected_uav(i) && offload_uav(i) > 0%need_uav(u,i) == 1
                m_i_low(u,i) = m_i(u,i);
                if m_i_low(u,i) > m_i_high(u,i)
                    m_i_low(u,i) = m_i_high(u,i);
                end
                m_i(u,i) = 4 * m_i(u,i);
            else
                m_i_high(u,i) = m_i(u,i);
                m_i(u,i) = (m_i_high(u,i) + m_i_low(u,i)) / 2;
            end
            if m_i(u,i) >= 100%(D(i) / Rate_i_j(i,u))
                m_i(u,i) = 100;%D(i) / Rate_i_j(i,u);
            end
            Record_2(i,u,now) = m_i(u,i);
        end
        % compute the profit of the uav j     
        uav_income(episode,u) = utility_uav(m_i(u,:),f_i(u,:),Rate_j_g_i(u,:),M_j(:,u),u);
    end
    %% Game of follower layer: Users
    for i = 1:user_num        
        [at_local(i),to_bs(i),to_uav(i),by_relay(i)] = utility_user(M_i(:,i),m_i(:,i),F_i(:,i),f_i(:,i),Rate_i_g,Rate_i_j,Rate_j_g_i,i);
        % allocate the compute task
        [local(i),offload_bs(i),offload_uav(i),offload_relay(i)] ...
        = offload_allocate(at_local(i),to_bs(i),to_uav(i),by_relay(i),D,i);
        [record_1(i,now),record_2(i,now),record_3(i,now),record_4(i,now)]=deal(local(i),offload_bs(i),offload_uav(i),offload_relay(i));
        if offload_relay(i) ~= 0
            relay_ok(selected_bs(i),selected_uav_relay(i)) = 1;
        else
            relay_ok(selected_bs(i),selected_uav_relay(i)) = 0;
        end
        user_outcome(episode,i)=local(i) * at_local(i) + offload_bs(i) * to_bs(i) + ...
                                offload_uav(i) * to_uav(i) + offload_relay(i) * by_relay(i);
    end
save stackelberg_RL
end
end