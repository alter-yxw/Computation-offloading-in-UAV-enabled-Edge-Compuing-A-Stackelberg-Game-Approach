figure
subplot(2,3,1);
plot(1:epoch,Stackelberg_uav(:,1),'color','[0.64,0.08,0.18]','Marker','o','linestyle','--');hold on
title('UAV1')
xlabel('iteartions')
ylabel('Profit')
subplot(2,3,2);
plot(1:epoch,Stackelberg_uav(:,2),'color','[0.00,0.45,0.74]','Marker','o','linestyle','--');hold on
title('UAV2')
xlabel('iteartions')
ylabel('Profit')
subplot(2,3,3);
plot(1:epoch,Stackelberg_uav(:,3),'color','[0.49,0.18,0.56]','Marker','o','linestyle','--');hold on
title('UAV3')
xlabel('iteartions')
ylabel('Profit')
subplot(2,3,4);
plot(1:epoch,Stackelberg_uav(:,4),'color','[0.93,0.69,0.13]','Marker','o','linestyle','--');hold on
title('UAV4')
xlabel('iteartions')
ylabel('Profit')
subplot(2,3,5);
plot(1:epoch,Stackelberg_uav(:,5),'color','[1.00,0.07,0.65]','Marker','o','linestyle','--');hold on
title('UAV5')
xlabel('iteartions')
ylabel('Profit')
subplot(2,3,6);
plot(1:epoch,Stackelberg_uav(:,6),'color','[0.47,0.67,0.19]','Marker','o','linestyle','--');
title('UAV6')
xlabel('iteartions')
ylabel('Profit')