clc
% clear all
% fileID = fopen('Laelaps Trajectory Planning - Trotting 11 - Kp45.0Kd0.03Ki0.0Filter20.csv','r');
% formatSpec = '%f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d %f %d';
% sizeA = [72 Inf];
% A = fscanf(fileID,formatSpec,sizeA);
% fclose(fileID);
filename = '~/catkin_ws/src/ighm_ros/rqt_multiplot.txt';
A = readtable(filename);
Hip_PWM_Limit = 41.17;
Knee_PWM_Limit = 38.25;

Hip_max_velocity = 75.83*2*pi/60; %rad/s in 60 V
Knee_max_velocity = 55.5*2*pi/60; %rad/s in 60 V

i_knee=(8*26)/(343*48);
i_hip=(12*26)/(637*48);

% Initializations
% t=zeros(1,length(A));
% % Hind Right Leg
% HR_knee_angle_deg=zeros(1,length(A));
% HR_hip_angle_deg=zeros(1,length(A));
% HR_velocity_hip=zeros(1,length(A)); 
% HR_velocity_knee=zeros(1,length(A));
% HR_uk_hip=zeros(1,length(A));
% HR_uk_knee=zeros(1,length(A));
% HR_Desired_hip_angle=zeros(1,length(A));
% HR_Desired_knee_angle=zeros(1,length(A));
% HR_time=zeros(1,length(A));

% Hind Left Leg
% HL_knee_angle_deg=zeros(1,length(A));
% HL_hip_angle_deg=zeros(1,length(A));
% HL_velocity_hip=zeros(1,length(A)); 
% HL_velocity_knee=zeros(1,length(A));
% HL_uk_hip=zeros(1,length(A));
% HL_uk_knee=zeros(1,length(A));
% HL_Desired_hip_angle=zeros(1,length(A));
% HL_Desired_knee_angle=zeros(1,length(A));
% HL_time=zeros(1,length(A));

% Fore Right Leg
% FR_knee_angle_deg=zeros(1,length(A));
% FR_hip_angle_deg=zeros(1,length(A));
% FR_velocity_hip=zeros(1,length(A)); 
% FR_velocity_knee=zeros(1,length(A));
% FR_step_command_hip=zeros(1,length(A));
% FR_step_command_knee=zeros(1,length(A));
% FR_uk_hip=zeros(1,length(A));
% FR_uk_knee=zeros(1,length(A));
% FR_Desired_hip_angle=zeros(1,length(A));
% FR_Desired_knee_angle=zeros(1,length(A));
% FR_time=zeros(1,length(A));

% Fore Left Leg
% FL_knee_angle_deg=zeros(1,length(A));
% FL_hip_angle_deg=zeros(1,length(A));
% FL_velocity_hip=zeros(1,length(A)); 
% FL_velocity_knee=zeros(1,length(A));
% FL_uk_hip=zeros(1,length(A));
% FL_uk_knee=zeros(1,length(A));
% FL_Desired_hip_angle=zeros(1,length(A));
% FL_Desired_knee_angle=zeros(1,length(A));
% FL_time=zeros(1,length(A));
% j=1;
A.Properties.VariableNames{'x_pdo_in_slave_0_time'} = 'Time';
A.Properties.VariableNames{'x_pdo_in_slave_0_desired_hip_angle'} = 'HR_desired_hip_angle';
A.Properties.VariableNames{'x_pdo_in_slave_1_desired_hip_angle'} = 'HL_desired_hip_angle';
A.Properties.VariableNames{'x_pdo_in_slave_2_desired_hip_angle'} = 'FL_desired_hip_angle';
A.Properties.VariableNames{'x_pdo_in_slave_3_desired_hip_angle'} = 'FR_desired_hip_angle';


t = A.Time;
HR_Desired_hip_angle = - A.HR_desired_hip_angle / 100;
HL_Desired_hip_angle = A.HL_desired_hip_angle / 100;
FR_Desired_hip_angle = - A.FR_desired_hip_angle / 100;
FL_Desired_hip_angle = A.FL_desired_hip_angle / 100;
% for i=1:length(A)
%     t(i)=A(1,i)/1000;
%     HR_hip_angle_deg(i)= -A(2,i)/100;
%     HR_knee_angle_deg(i)= -A(4,i)/100;
%     HR_Desired_hip_angle(i)=-A(6,i)/100;
%     HR_Desired_knee_angle(i)=-A(8,i)/100;
%     HR_uk_hip(i)=A(10,i)/100;
%     HR_uk_knee(i)=A(12,i)/100;
%     HR_velocity_hip(i)=-A(14,i)*i_hip/1000;
%     HR_velocity_knee(i)=-A(16,i)*i_knee/1000;
%     HR_time(i)=A(18,i)/100;
%      
%     HL_hip_angle_deg(i)= A(20,i)/100;
%     HL_knee_angle_deg(i)= A(22,i)/100;
%     HL_Desired_hip_angle(i)=A(24,i)/100;
%     HL_Desired_knee_angle(i)=A(26,i)/100;
%     HL_uk_hip(i)=A(28,i)/100;
%     HL_uk_knee(i)=A(30,i)/100;
%     HL_velocity_hip(i)=A(32,i)*i_hip/1000;
%     HL_velocity_knee(i)=A(34,i)*i_knee/1000;
%     HL_time(i)=A(36,i)/100;
%     
%     FR_hip_angle_deg(i)= -A(38,i)/100;
%     FR_knee_angle_deg(i)= -A(40,i)/100;
%     FR_Desired_hip_angle(i)=-A(42,i)/100;
%     FR_Desired_knee_angle(i)=-A(44,i)/100;
%     FR_uk_hip(i)=A(46,i)/100;
%     FR_uk_knee(i)=A(48,i)/100;
%     FR_velocity_hip(i)=-A(50,i)*i_hip/1000;
%     FR_velocity_knee(i)=-A(52,i)*i_knee/1000;
%     FR_time(i)=A(54,i)/100;
%        
%     FL_hip_angle_deg(i)=A(56,i)/100;
%     FL_knee_angle_deg(i)=A(58,i)/100;
%     FL_Desired_hip_angle(i)=A(60,i)/100;
%     FL_Desired_knee_angle(i)=A(62,i)/100;
%     FL_uk_hip(i)=A(64,i)/100;
%     FL_uk_knee(i)=A(66,i)/100;
%     FL_velocity_hip(i)=A(68,i)*i_hip/1000;
%     FL_velocity_knee(i)=A(70,i)*i_knee/1000;
%     FL_time(i)=A(72,i)/100;
%     
%     if (i>30000 && i<35000)
%     [HR_x(j), HR_y(j)]=ForwardKinematics(HR_hip_angle_deg(i),HR_knee_angle_deg(i));
%     [HR_x_desired(j), HR_y_desired(j)]=ForwardKinematics(HR_Desired_hip_angle(i),HR_Desired_knee_angle(i));
%     [HL_x(j), HL_y(j)]=ForwardKinematics(HL_hip_angle_deg(i),HL_knee_angle_deg(i));
%     [HL_x_desired(j), HL_y_desired(j)]=ForwardKinematics(HL_Desired_hip_angle(i),HL_Desired_knee_angle(i));
%     [FR_x(j), FR_y(j)]=ForwardKinematics(FR_hip_angle_deg(i),FR_knee_angle_deg(i));
%     [FR_x_desired(j), FR_y_desired(j)]=ForwardKinematics(FR_Desired_hip_angle(i),FR_Desired_knee_angle(i));
%     [FL_x(j), FL_y(j)]=ForwardKinematics(FL_hip_angle_deg(i),FL_knee_angle_deg(i));
%     [FL_x_desired(j), FL_y_desired(j)]=ForwardKinematics(FL_Desired_hip_angle(i),FL_Desired_knee_angle(i));
%     j=j+1;
%     end  
% end

%End Effector of Laelaps II Legs
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,2,1)
% plot(FR_x,FR_y,'k',FR_x_desired,FR_y_desired,'r')
%      grid on
%      ylabel('+ <-- y axis','fontsize',14)
%      xlabel('x axis --> +','fontsize',14)
%      title('FR End Effector in Steady State','fontsize',14)
%      set(gca,'Ydir','reverse')
% subplot(2,2,2)
% plot(FL_x,FL_y,'k',FL_x_desired,FL_y_desired,'r')
%      grid on
%      ylabel('+ <-- y axis','fontsize',14)
%      xlabel('x axis --> +','fontsize',14)
%      title('FL End Effector in Steady State','fontsize',14)
%      set(gca,'Ydir','reverse')
% subplot(2,2,3)
% plot(HR_x,HR_y,'k',HR_x_desired,HR_y_desired,'r')
%      grid on
%      ylabel('+ <-- y axis','fontsize',14)
%      xlabel('x axis --> +','fontsize',14)
%      title('HR End Effector in Steady State','fontsize',14)
%      set(gca,'Ydir','reverse')
% subplot(2,2,4)
% plot(HL_x,HL_y,'k',HL_x_desired,HL_y_desired,'r')
%      grid on
%      ylabel('+ <-- y axis','fontsize',14)
%      xlabel('x axis --> +','fontsize',14)
%      title('HL End Effector in Steady State','fontsize',14)
%      set(gca,'Ydir','reverse')
% tightfig;

%Responce of knee angles
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(4,1,1)
% plot(t,FR_knee_angle_deg,'k',t,FR_Desired_knee_angle,'r')
%      grid on
%      ylabel('Angle [deg]')
%    	 title('Response of FR Knee Angle','fontsize',13)
% subplot(4,1,2)
% plot(t,FL_knee_angle_deg,'k',t,FL_Desired_knee_angle,'r')
%      grid on
%      ylabel('Angle [deg]')
%    	 title('Response of FL Knee Angle','fontsize',13)
% subplot(4,1,3)
% plot(t,HR_knee_angle_deg,'k',t,HR_Desired_knee_angle,'r')
%      grid on
%      ylabel('Angle [deg]')
%    	 title('Response of HR Knee Angle','fontsize',13)
% subplot(4,1,4)
% plot(t,HL_knee_angle_deg,'k',t,HL_Desired_knee_angle,'r')
%      grid on
%      ylabel('Angle [deg]')
%      xlabel('Time [s]')
%    	 title('Response of HL Knee Angle','fontsize',13)
% tightfig;

%Responce of hip angles
figure
set(gcf, 'Position', [100 50 900 800],'color','w');
subplot(4,1,1)
plot(t,FR_Desired_hip_angle,'r') % t,FR_hip_angle_deg,'k',
     grid on
     ylabel('Angle [deg]')
   	 title('Response of FR Hip Angle','fontsize',13)
subplot(4,1,2)
plot(t,FL_Desired_hip_angle,'r') % t,FL_hip_angle_deg,'k',
     grid on
     ylabel('Angle [deg]')
   	 title('Response of FL Hip Angle','fontsize',13)
subplot(4,1,3)
plot(t,HR_Desired_hip_angle,'r') % t,HR_hip_angle_deg,'k', 
     grid on
     ylabel('Angle [deg]')
   	 title('Response of HR Hip Angle','fontsize',13)
subplot(4,1,4)
plot(t,HL_Desired_hip_angle,'r') % t,HL_hip_angle_deg,'k', 
     grid on
     ylabel('Angle [deg]')
     xlabel('Time [s]')
   	 title('Response of HL Hip Angle','fontsize',13)
tightfig;

%PWM Commands of Knee motors
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(4,1,1)
% plot(t,FR_uk_knee,'k','LineWidth',0.1)
% hold on
% plot(t,Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
%      ylabel('PWM Command [%]')
%    	 title('PWM Command of FR Knee','fontsize',13)
% subplot(4,1,2)
% plot(t,FL_uk_knee,'k','LineWidth',0.1)
% hold on
% plot(t,Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
%      ylabel('PWM Command [%]')
%    	 title('PWM Command of FL Knee','fontsize',13)
% subplot(4,1,3)
% plot(t,HR_uk_knee,'k','LineWidth',0.1)
% hold on
% plot(t,Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
%      ylabel('PWM Command [%]')
%    	 title('PWM Command of HR Knee','fontsize',13)
% subplot(4,1,4)
% plot(t,HL_uk_knee,'k','LineWidth',0.1)
% hold on
% plot(t,Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
%      ylabel('PWM Command [%]')
%      xlabel('Time [s]')
%    	 title('PWM Command of HL Knee','fontsize',13)
% tightfig;

%PWM Commands of Hip motors
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(4,1,1)
% plot(t,FR_uk_hip,'k','LineWidth',0.1)
% hold on
% plot(t,Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
%      ylabel('PWM Command [%]')
%    	 title('PWM Command of FR Hip','fontsize',13)
% subplot(4,1,2)
% plot(t,FL_uk_hip,'k','LineWidth',0.1)
% hold on
% plot(t,Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
%      ylabel('PWM Command [%]')
%    	 title('PWM Command of FL Hip','fontsize',13)
% subplot(4,1,3)
% plot(t,HR_uk_hip,'k','LineWidth',0.1)
% hold on
% plot(t,Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
%      ylabel('PWM Command [%]')
%    	 title('PWM Command of HR Hip','fontsize',13)
% subplot(4,1,4)
% plot(t,HL_uk_hip,'k','LineWidth',0.1)
% hold on
% plot(t,Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
%      ylabel('PWM Command [%]')
%      xlabel('Time [s]')
%    	 title('PWM Command of HL Hip','fontsize',13)
% tightfig;

%Velocity of Knee motors
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(4,1,1)
% hold on
% plot(t,Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,FR_velocity_knee,'k')
%      grid on
%      ylabel('Velocity [rad/s]')
%    	 title('Response of FR Knee Velocity','fontsize',13)
% subplot(4,1,2)
% hold on
% plot(t,Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,FL_velocity_knee,'k')
%      grid on
%      ylabel('Velocity [rad/s]')
%    	 title('Response of FL Knee Velocity','fontsize',13)
% subplot(4,1,3)
% hold on
% plot(t,Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,HR_velocity_knee,'k')
%      grid on
%      ylabel('Velocity [rad/s]')
%    	 title('Response of HR Knee Velocity','fontsize',13)
% subplot(4,1,4)
% hold on
% plot(t,Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,HL_velocity_knee,'k')
%      grid on
%      ylabel('Velocity [rad/s]')
%      xlabel('Time [s]')
%    	 title('Response of HL Knee Velocity','fontsize',13)
% tightfig;

%Velocity of Hip motors
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(4,1,1)
% hold on
% plot(t,Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,FR_velocity_hip,'k')
%      grid on
%      ylabel('Velocity [rad/s]')
%    	 title('Response of FR Hip Velocity','fontsize',13)
% subplot(4,1,2)
% hold on
% plot(t,Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,FL_velocity_hip,'k')
%      grid on
%      ylabel('Velocity [rad/s]')
%    	 title('Response of FL Hip Velocity','fontsize',13)
% subplot(4,1,3)
% hold on
% plot(t,Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,HR_velocity_hip,'k')
%      grid on
%      ylabel('Velocity [rad/s]')
%    	 title('Response of HR Hip Velocity','fontsize',13)
% subplot(4,1,4)
% hold on
% plot(t,Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,HL_velocity_hip,'k')
%      grid on
%      ylabel('Velocity [rad/s]')
%      xlabel('Time [s]')
%    	 title('Response of HL Hip Velocity','fontsize',13)
% tightfig;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Commented section by Stamatis%%%%%%%%%%%%%%%%%%%%%%%%%%     
% % Plot Hind Right Leg's Diagrams
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,1,1)
% plot(t,HR_knee_angle_deg,'k',t,HR_Desired_knee_angle,'r')
%      grid on
% %      axis([-0.7 0.7 -0.1 0.7])
%      ylabel('Angle [deg]')
%      xlabel('Time [s]')
%    	 title('Response of HR Knee Angle','fontsize',13)
% subplot(2,1,2)
% plot(t,HR_hip_angle_deg,'k',t,HR_Desired_hip_angle,'r')
%      grid on
% %      axis([-0.7 0.7 -0.1 0.7])
%      ylabel('Angle [deg]')
%      xlabel('Time [s]')
%    	 title('Response of HR Hip Angle','fontsize',13)
% tightfig;
% 
% figure  
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,1,1)
% plot(t,HR_uk_knee,'k','LineWidth',0.1)
% hold on
% plot(t,Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
%      ylabel('PWM Command [%]')
%      xlabel('Time [s]')
%    	 title('PWM Command of HR Knee','fontsize',13)
% subplot(2,1,2)
% plot(t,HR_uk_hip,'k','LineWidth',0.1)
% hold on
% plot(t,Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
% %     axis([2 7 -50 60])
%      ylabel('PWM Command [%]')
%      xlabel('Time [s]')
%    	 title('PWM command of HR Hip','fontsize',13)
% tightfig;
% 
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,1,1)
% hold on
% plot(t,Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,HR_velocity_knee,'k')
%      grid on
%      ylabel('Velocity [rad/s]')
%      xlabel('Time [s]')
%    	 title('Response of HR Knee Velocity','fontsize',13)
% subplot(2,1,2)
% hold on
% plot(t,Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,HR_velocity_hip,'k')
%      grid on
%      ylabel('Velocity [rad/s]')
%      xlabel('Time [s]')
%    	 title('Response of HR Hip Velocity','fontsize',13)
% tightfig;
% 
% % Plot Hind Left Leg's Diagrams
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,1,1)
% plot(t,HL_knee_angle_deg,'k',t,HL_Desired_knee_angle,'r')
%      grid on
% %      axis([-0.7 0.7 -0.1 0.7])
%      ylabel('Angle [deg]')
%      xlabel('Time [s]')
%    	 title('Response of HL Knee Angle','fontsize',13)
% subplot(2,1,2)
% plot(t,HL_hip_angle_deg,'k',t,HL_Desired_hip_angle,'r')
%      grid on
% %      axis([-0.7 0.7 -0.1 0.7])
%      ylabel('Angle [deg]')
%      xlabel('Time [s]')
%    	 title('Response of HL Hip Angle','fontsize',13)
% tightfig;
% 
% figure  
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,1,1)
% plot(t,HL_uk_knee,'k','LineWidth',0.1)
% hold on
% plot(t,Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
% %     axis([2 7 -50 60])
%      ylabel('PWM Command [%]')
%      xlabel('Time [s]')
%    	 title('PWM Command of HL Knee','fontsize',13)
% subplot(2,1,2)
% plot(t,HL_uk_hip,'k','LineWidth',0.1)
% hold on
% plot(t,Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
% %     axis([2 7 -50 60])
%      ylabel('PWM Command [%]')
%      xlabel('Time [s]')
%    	 title('PWM command of HL Hip','fontsize',13)
% tightfig;
% 
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,1,1)
% hold on
% plot(t,Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,HL_velocity_knee,'k')
%      grid on
%      ylabel('Velocity [rad/s]')
%      xlabel('Time [s]')
%    	 title('Response of HL Knee Velocity','fontsize',13)
% subplot(2,1,2)
% hold on
% plot(t,Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,HL_velocity_hip,'k')
%      grid on
%      ylabel('Velocity [rad/s]')
%      xlabel('Time [s]')
%    	 title('Response of HL Hip Velocity','fontsize',13)
% tightfig;
% 
% % Plot Fore Right Leg's Diagrams
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,1,1)
% hold all
% plot(t,FR_knee_angle_deg,'k',t,FR_Desired_knee_angle,'r')
%      grid on
% %      axis([-0.7 0.7 -0.1 0.7])
%      ylabel('Angle [deg]')
%      xlabel('Time [s]')
%    	 title('Response of FR Knee Angle','fontsize',13)
% subplot(2,1,2)
% plot(t,FR_hip_angle_deg,'k',t,FR_Desired_hip_angle,'r')
%      grid on
% %      axis([-0.7 0.7 -0.1 0.7])
%      ylabel('Angle [deg]')
%      xlabel('Time [s]')
%    	 title('Response of FR Hip Angle','fontsize',13)
% tightfig;
% 
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,1,1)
% plot(t,FR_uk_knee,'k','LineWidth',0.1)
% hold on
% plot(t,Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
% %     axis([2 7 -50 60])
%      ylabel('PWM Command [%]')
%      xlabel('Time [s]')
%    	 title('PWM Command of FR Knee','fontsize',13)
% subplot(2,1,2)
% plot(t,FR_uk_hip,'k','LineWidth',0.1)
% hold on
% plot(t,Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
% %     axis([2 7 -50 60])
%      ylabel('PWM Command [%]')
%      xlabel('Time [s]')
%    	 title('PWM Command of FR Hip','fontsize',13)
%  tightfig;
%  
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,1,1)
% hold on
% plot(t,Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,FR_velocity_knee,'k')
%      grid on
% %      axis([-0.7 0.7 -0.1 0.7])
%      ylabel('Velocity [rad/s]')
%      xlabel('Time [s]')
%    	 title('Response of FR Knee Velocity','fontsize',13)
% subplot(2,1,2)
% hold on
% plot(t,Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,FR_velocity_hip,'k')
%      grid on
% %      axis([-0.7 0.7 -0.1 0.7])
%      ylabel('Velocity [rad/s]')
%      xlabel('Time [s]')
%    	 title('Response of FR Hip Velocity','fontsize',13)
% tightfig;
%  
% % Plot Fore Left Leg's Diagrams
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,1,1)
% hold all
% plot(t,FL_knee_angle_deg,'k',t,FL_Desired_knee_angle,'r')
%      grid on
% %      axis([-0.7 0.7 -0.1 0.7])
%      ylabel('Angle [deg]')
%      xlabel('Time [s]')
%    	 title('Response of FL Knee Angle','fontsize',13)
% subplot(2,1,2)
% plot(t,FL_hip_angle_deg,'k',t,FL_Desired_hip_angle,'r')
%      grid on
% %      axis([-0.7 0.7 -0.1 0.7])
%      ylabel('Angle [deg]')
%      xlabel('Time [s]')
%    	 title('Response of FL Hip Angle','fontsize',13)
% tightfig;
% 
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,1,1)
% plot(t,FL_uk_knee,'k','LineWidth',0.1)
% hold on
% plot(t,Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
% %     axis([2 7 -50 60])
%      ylabel('PWM Command [%]')
%      xlabel('Time [s]')
%    	 title('PWM Command of FL Knee','fontsize',13)
% subplot(2,1,2)
% plot(t,FL_uk_hip,'k','LineWidth',0.1)
% hold on
% plot(t,Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_PWM_Limit*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
% %     axis([2 7 -50 60])
%      ylabel('PWM Command [%]')
%      xlabel('Time [s]')
%    	 title('PWM Command of FL Hip','fontsize',13)
%  tightfig;
%  
% figure
% set(gcf, 'Position', [100 50 900 800],'color','w');
% subplot(2,1,1)
% hold on
% plot(t,Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Knee_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,FL_velocity_knee,'k')
%      grid on
% %      axis([-0.7 0.7 -0.1 0.7])
%      ylabel('Velocity [rad/s]')
%      xlabel('Time [s]')
%    	 title('Response of FL Knee Velocity','fontsize',13)
% subplot(2,1,2)
% hold on
% plot(t,Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
% plot(t,-Hip_max_velocity*ones(length(t),1),'r','LineWidth',0.1);
%      grid on
% plot(t,FL_velocity_hip,'k')
% %      axis([-0.7 0.7 -0.1 0.7])
%      ylabel('Velocity [rad/s]')
%      xlabel('Time [s]')
%    	 title('Response of FL Hip Velocity','fontsize',13)
% tightfig;