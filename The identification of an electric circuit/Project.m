%% TREAPTA
t_t = scope11(:,1);
u_t = scope11(:,2);
y_t = scope11(:,3);
figure;
plot(t_t,[u_t y_t]),shg,grid,legend('u','y'), ylabel('Amplitude [V]'), xlabel('t [sec]'), title('Raspunsul circuitului la intrarea de tip treapta');

i1t = 447;
i2t = 485;
i3t = 930;
i4t = 978; 
i5t = 579;
i6t = 500;

u0_t = mean(u_t(i1t:i2t));
y0_t = mean(y_t(i1t:i2t));

ust_t = mean(u_t(i3t:i4t));
yst_t = mean(y_t(i3t:i4t));
hold on
%plot(t_t,ust_t*ones(1,length(t_t)),'--');
%plot(t_t,yst_t*ones(1,length(t_t)),'--');
%plot(t_t,u0_t*ones(1,length(t_t)),'--');
%plot(t_t,y0_t*ones(1,length(t_t)),'--');

K_t = (yst_t-y0_t)/(ust_t-u0_t); %factor de proportionalitate
 
ymax_t = y_t(i5t);

sigma_t = (ymax_t-yst_t)/(yst_t-y0_t); %suprareglajul
tita_t = -log(sigma_t)/(sqrt(pi^2+log(sigma_t)^2)); %factorul de amortizare

Tosc_t = 2.*(t_t(i5t)-t_t(i6t)); %perioada de oscilatie (intre un maxim si un minim)
wosc_t = 2*pi/Tosc_t; %pulsatia de oscilatie
wn_t=wosc_t/sqrt(1-tita_t^2); %pulsatia naturala

% H=tf(K_t*wn_t^2,[1,2*tita_t*wn_t,wn_t^2]);
% ysim_t=lsim(H,u_t,t_t);
% figure
% plot(t_t,[u_t y_t ysim_t]);

A_t = [0 1; -wn_t^2 -2*tita_t*wn_t];
B_t = [0; K_t*wn_t^2];
C =[1 0];
D = 0;
ysim_t = lsim(A_t,B_t,C,D,u_t,t_t,[y_t(1),0]); 

figure;
plot(t_t,[u_t,y_t,ysim_t]),shg,grid,legend('u','y','ysim'), ylabel('Amplitude [V]'), xlabel('t [sec]');


J_t=norm(y_t-ysim_t)/(sqrt(1000)); %eroarea medie patratica
Empn_t=norm(y_t-ysim_t)/(norm(y_t-mean(y_t))); %eproarea medie patratica normalizata 
%%
%verificarea modelului impuls intrare treapta
figure;
y_i=lsim(A,B,C,D,u_t,t_t,[y_t(1),0]);
plot(t_t,[y_t ysim_t y_i]),shg,grid,legend('y','ysim treapta', 'ysim impuls'), ylabel('Amplitude [V]'), xlabel('t [sec]');
eroarea_impuls=norm(y_t-y_i)/norm(y_t-mean(y_t));
J_impuls=norm(y_t-y_i)/sqrt(1000);
%% IMPULS
t=scope12(:,1);
u=scope12(:,2);
y=scope12(:,3);

plot(t,[u,y]),shg,grid,legend('u','y'), ylabel('Amplitude [V]'), xlabel('t [sec]'), title('Raspunsul circuitului la intrarea de tip impuls');

 i1=936;
 i2=983;
 i3=521; %t0
 i4=586; %t1
 i5=659; %t2
 i6= 540; %t3
 i7= 614; %t4
 
 ust= mean(u(i1:i2));
 yst= mean(y(i1:i2));
 
%  hold on
% plot(t,ust*ones(1,length(t)),'--');
% plot(t,yst*ones(1,length(t)),'--');
% plot(t,yst*ones(1,length(t)),'r');
 k=yst/ust; %factor de proportionalitate

 Apoz=sum(abs((y(i3:i4)-yst)))*(t(2)-t(1));
 Aneg=sum(abs((y(i4:i5)-yst)))*(t(2)-t(1));
 sigma=Aneg/Apoz; %suprareglaj
 
 tita=(-log(sigma))/(sqrt(pi*pi+(log(sigma))^2)); %factor de amortizare

 Tosc=2*(t(i7)-t(i6)); %perioada de oscilatie
 wosc = 2*pi/Tosc; %pulsatia de oscilatie
 wn=wosc/sqrt(1-tita^2); %pulsatia naturala
 
%  H=tf(K*wn^2,[1,2*tita*wn,wn^2]);
%  ysim=lsim(H,u,t);
%  figure
%  plot(t,[u y ysim]);

 A=[0 1; -wn^2 -2*tita*wn];
 B=[0; k*wn^2]; 
 C=[1 0];
 D=0;
 
 ysim1=lsim(A,B,C,D,u,t,[y(1) 0]);
 figure;
 plot(t,[u,y,ysim1]),shg,grid,legend('u','y','ysim'), ylabel('Amplitude [V]'), xlabel('t [sec]');
 
 J=norm(y-ysim1); %eroarea medie patratica
 Empn=(norm(y-ysim1))/(norm(y-mean(y))); %eraorea medie patratica normalizata
%%
%verificarea modelului treapta intrare impuls
figure;
y_tr=lsim(A_t,B_t,C,D,u,t,[y(1),0]);
plot(t,[y ysim1 y_tr]),shg,grid,legend('y','ysim impuls', 'ysim treapta'), ylabel('Amplitude [V]'), xlabel('t [sec]');
eroarea_treapta=norm(y-y_tr)/norm(y-mean(y));
J_treapta=norm(y-y_tr)/sqrt(1000);