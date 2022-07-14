function profit = all_local()
global D user_num resource_user
fai = 15 .* D; cpi_cost = 8;
user_overhead = zeros(user_num,1);
[alpha_loc_trans,alpha_loc_e] = deal(0.5,0.5);
for i = 1:user_num
    user_overhead(i) = alpha_loc_trans * fai(i) / resource_user(i) + ...
        alpha_loc_e * cpi_cost * fai(i) / resource_user(i);
end
profit = sum(user_overhead);
end

