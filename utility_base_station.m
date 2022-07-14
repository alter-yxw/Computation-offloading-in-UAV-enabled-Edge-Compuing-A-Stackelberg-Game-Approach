function utility_bs = utility_base_station(M_i,M_j,F_i,bs_now)
global user_num D offload_relay selected_uav_relay relay_ok selected_bs
P_g = 0;C_g = 0;%correlated_user = zeros(1,uav_num);
for i = 1:user_num
    temp1 = M_i(i) * F_i(i);
    temp2 = M_j(selected_uav_relay(i)) * offload_relay(i) * D(i);
    P_g = P_g + temp1 * (bs_now == selected_bs(i));
    C_g = C_g + temp2 * relay_ok(bs_now,selected_uav_relay(i));
end
utility_bs = P_g - C_g;
end