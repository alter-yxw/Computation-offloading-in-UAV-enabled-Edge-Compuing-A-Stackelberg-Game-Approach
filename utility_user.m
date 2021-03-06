function [local,to_bs,toUAV,relay] = utility_user(M_i,m_i,F_i,f_i,Rate_i_g,Rate_i_j,Rate_j_g_i,user_now)
global selected_bs selected_uav resource_user power_user bs_num uav_num D ...
       selected_uav_relay
fai = 15 .* D; cpi_cost = 8;
[alpha_loc_trans,alpha_loc_e] = deal(0.5,0.5);
[alpha_g_trans,alpha_g_e,alpha_g_exe] = deal(0.3,0.3,0.4);
[alpha_j_trans,alpha_j_e,alpha_j_exe] = deal(0.3,0.3,0.4);
[alpha_u_trans,alpha_u_e,alpha_u_exe] = deal(0.3,0.3,0.4);
% update the selected bs && uav of user i
[min_bs,min_uav,min_relay] = deal(inf,inf,inf);
for b = 1:bs_num
    Cost_bs = alpha_g_trans * (D(user_now) / Rate_i_g(user_now,b) + ...
        fai(user_now)/(F_i(b) + 1)) + alpha_g_e * power_user(user_now) * D(user_now) /...
        Rate_i_g(user_now,b) + alpha_g_exe * M_i(b) * F_i(b);
    if Cost_bs < min_bs && F_i(b)
        min_bs = Cost_bs;
        selected_bs(user_now) = b;
    end
end
for j = 1:uav_num
    Cost_uav = alpha_j_trans * (D(user_now) / Rate_i_j(user_now,j) + fai(user_now)/(f_i(j)+1))+...
               alpha_j_e * D(user_now) / Rate_i_j(user_now,j) * power_user(user_now) + alpha_j_exe *...
               m_i(j) * f_i(j);
    Cost_relay = alpha_u_trans * (D(user_now) / Rate_i_j(user_now,j) +...
                 D(user_now) /Rate_j_g_i(j,selected_bs(user_now))) + ...
                 alpha_u_e * power_user(user_now) * D(user_now) /Rate_i_j(user_now,j);
    if Cost_uav < min_uav
        min_uav = Cost_uav;
        selected_uav(user_now) = j;
    end
    if Cost_relay < min_relay
        min_relay = Cost_relay;
        selected_uav_relay(user_now) = j;
    end
 end
local = alpha_loc_trans * fai(user_now) / resource_user(user_now) + ...
        alpha_loc_e * cpi_cost * fai(user_now) / resource_user(user_now);
to_bs = alpha_g_trans * (D(user_now) / Rate_i_g(user_now,selected_bs(user_now)) + fai(user_now)/(F_i(selected_bs(user_now))+1))+...
        alpha_g_e * power_user(user_now) * D(user_now) / Rate_i_g(user_now,selected_bs(user_now)) + ...
        alpha_g_exe * M_i(selected_bs(user_now)) * F_i(selected_bs(user_now));
toUAV = alpha_j_trans * (D(user_now) / Rate_i_j(user_now,selected_uav(user_now)) + fai(user_now)/(f_i(selected_uav(user_now))+1))+...
        alpha_j_e * D(user_now) / Rate_i_j(user_now,selected_uav(user_now)) * power_user(user_now) + ...
        alpha_j_exe * m_i(selected_uav(user_now)) * f_i(selected_uav(user_now));
relay = alpha_u_trans * (D(user_now) / Rate_i_j(user_now,selected_uav_relay(user_now)) + fai(user_now)/(F_i(selected_bs(user_now))+1)+...
        D(user_now) / Rate_j_g_i(selected_uav_relay(user_now),selected_bs(user_now))) + ...
        alpha_u_e * power_user(user_now) * D(user_now) / Rate_i_j(user_now,selected_uav_relay(user_now)) + ...
        alpha_u_exe * M_i(selected_bs(user_now)) * F_i(selected_bs(user_now));
end