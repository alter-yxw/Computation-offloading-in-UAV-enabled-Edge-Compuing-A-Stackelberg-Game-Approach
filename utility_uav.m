function utility = utility_uav(m_i,f_i,rate_j_g_i,M_j,uav_now)
global power_uav user_num selected_uav selected_bs D offload_uav ...
       offload_relay relay_ok
fai  = 15 * D;cpi_cost = 8;
[p_c_j,p_t_j,c_c_j,c_t_j] = deal(0,0,0,0);
for i = 1:user_num
    temp1 = m_i(i) * f_i(i);
    temp2 = M_j(selected_bs(i)) * offload_relay(i) * D(i);
    temp3 = offload_uav(i) * fai(i) * cpi_cost / (f_i(i) + 1);
    temp4 = power_uav(uav_now) * offload_relay(i) * D(i) / rate_j_g_i(selected_bs(i));
    p_c_j = p_c_j + temp1 * (uav_now == selected_uav(i));
    p_t_j = p_t_j + temp2 * relay_ok(selected_bs(i),uav_now);
    c_c_j = c_c_j + temp3 * (uav_now == selected_uav(i));
    c_t_j = c_t_j + temp4 * relay_ok(selected_bs(i),uav_now);
end
utility = p_c_j + p_t_j - c_c_j - c_t_j;
end