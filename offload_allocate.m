function [loc,bs,uav,relay] = offload_allocate(at_local,to_bs,to_uav,by_relay,D_i,user_now)
global resource_user D
[~,index] = min([at_local,to_bs,to_uav,by_relay]);
if index == 1
    if resource_user(user_now) < D_i(user_now)
        loc = resource_user(user_now)/D(user_now);
        D_i(user_now) = D_i(user_now)-resource_user(user_now);
        [~,bs,uav,relay] = offload_allocate(inf,to_bs,to_uav,by_relay,D_i,user_now);
    else % 本地资源充足
        [loc,bs,uav,relay] = deal(D_i(user_now)/D(user_now),0,0,0);
    end
end
if index == 2
    [loc,bs,uav,relay] = deal(0,D_i(user_now)/D(user_now),0,0);
end
if index == 3
    [loc,bs,uav,relay] = deal(0,0,D_i(user_now)/D(user_now),0);
end
if index == 4
    [loc,bs,uav,relay] = deal(0,0,0,D_i(user_now)/D(user_now));
end
end