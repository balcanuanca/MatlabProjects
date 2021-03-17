t=double(dan_vasile.X.Data)';
y=double(dan_vasile.Y(1,1).Data)';%pozitia %y %pozitia unghiulara
w=double(dan_vasile.Y(1,2).Data)';%viteza %w %viteza unghiulara
u=double(dan_vasile.Y(1,3).Data)';%intrare (factorul de umplere PWM)%u

plot(t,[u*200,w,y]),shg,grid,legend('Intrarea u','Viteza w','Pozitia y'), ylabel('u [%] ; w [rad/sec] ;y [impulsuri]'), xlabel('t [sec]'), title('Datele experimentale u w y','fontsize',12);

%% Create data
% indexi identificare
i1 = 3439;
i2 = 5555;
%indexi validare
i3 = 6693;
i4 = 8769;

Te = t(2)-t(1);
data_id_w=iddata(w(i1:i2),u(i1:i2),Te);%datele de identificare
data_v_w=iddata(w(i3:i4),u(i3:i4),Te);%datele de validare
data_g_w = iddata(w,u,Te); %pt obtinerea gradului de suprapunere

data_id_th = iddata(y(i1:i2),w(i1:i2),Te);%datele de identificare
data_v_th = iddata(y(i3:i4),w(i3:i4),Te);%datele de validare
data_g_th = iddata(y,w,Te); %pt obtinerea gradului de suprapunere


%% ARX Viteza
m_arx_w = arx(data_id_w,[1 1 1])
Hd_arx_w = tf(m_arx_w.B,m_arx_w.A,Te, 'Variable', 'z^-1')
Hc_w_arx = d2c(Hd_arx_w,'zoh')

figure
resid(m_arx_w,data_v_w,10);
figure
compare(m_arx_w,data_v_w);
%% ARMAX Viteza
m_amx_w = armax(data_id_w,[1 1 1 1]);
Hd_amx_w = tf(m_amx_w.B,m_amx_w.A,Te, 'Variable', 'z^-1')
Hc_w_amx = d2c(Hd_amx_w,'zoh')

figure
resid(m_amx_w,data_id_w,10); 
figure
compare(m_amx_w,data_v_w);
%% IV4 Viteza
m_iv_w = iv4(data_id_w,[1 1 1]);
Hd_iv_w = tf(m_iv_w.B,m_iv_w.A,Te, 'Variable', 'z^-1')
Hc_iv_w = d2c(Hd_iv_w,'zoh')

figure
resid(m_iv_w,data_id_w,10); 
figure
compare(m_iv_w,data_v_w); 
%% OE Viteza
m_oe_w = oe(data_id_w,[1 1 1]);
Hd_oe_w = tf(m_oe_w.B,m_oe_w.F,Te, 'Variable', 'z^-1')
Hc_oe_w = d2c(Hd_oe_w,'zoh')

figure
resid(m_oe_w,data_v_w,10);
figure
compare(m_oe_w,data_v_w);
%%
compare(data_v_w,m_arx_w,m_amx_w,m_iv_w,m_oe_w)
%% Decimare
N = 12;
t_dec = t(1:N:end);
Te_dec  = t_dec(2)-t_dec(1);
d_dec = u(1:N:end);
w_dec = w(1:N:end);
y_dec = y(1:N:end);

figure
% plot(t,w);
% hold on
plot(t_dec,w_dec),shg,grid, legend('wi dec'),ylabel('wi dec [rad/sec]'), xlabel('t [sec]'), title('Viteza interpolata decimata','fontsize',12);

i1_dec = 288;
i2_dec = 452;
i3_dec = 559;
i4_dec = 725;

Te=t(2)-t(1);

data_id_w_dec=iddata(w_dec(i1_dec:i2_dec),d_dec(i1_dec:i2_dec),Te_dec);
data_v_w_dec=iddata(w_dec(i3_dec:i4_dec),d_dec(i3_dec:i4_dec),Te_dec);
data_g_w_dec = iddata(w_dec,d_dec,Te_dec); 

data_id_th_dec = iddata(y_dec(i1_dec:i2_dec),w_dec(i1_dec:i2_dec),Te_dec);
data_v_th_dec = iddata(y_dec(i3_dec:i4_dec),w_dec(i3_dec:i4_dec),Te_dec);
data_g_th_dec = iddata(y_dec,w_dec,Te_dec);
%% ARX Pozitie
m_arx_th = arx(data_id_th,[1 1 0]);
Hd_arx_th = tf(m_arx_th.B,m_arx_th.A,Te);

Hc_th_arx = tf(m_arx_th.B(end)/Te,[1 0]);

figure
resid(m_arx_th,data_v_th,10);
figure
compare(m_arx_th,data_v_th);
%% PEM ARX Pozitie
m_arx_th_pem = pem(m_arx_th,data_id_th);
figure
resid(m_arx_th_pem,data_v_th,10);
figure
compare(m_arx_th_pem,data_v_th);

%% ARX dec
m_arx_th_dec = arx(data_id_th_dec,[1 1 0]);

figure
resid(m_arx_th_dec, data_v_th_dec,10);
figure
compare(m_arx_th_dec,data_v_th_dec);
%% ARMAX Pozitie
m_amx_th = armax(data_id_th,[1 1 1 0]);
Hd_amx_th = tf(m_amx_th.B,m_amx_th.A,Te);

Hc_th_arx = tf(m_amx_th.B(end)/Te,[1 0]);

figure
resid(m_amx_th,data_id_th,10);
figure
compare(m_amx_th,data_v_th); 

%% PEM ARMAX Pozitie
m_amx_th_pem = pem(m_amx_th,data_id_th);
figure
resid(m_amx_th_pem,data_v_th,10);
figure
compare(m_amx_th_pem,data_v_th);

%% ARMAX dec
m_amx_th_dec = armax(data_id_th_dec,[1 1 1 0]);

figure
resid(m_amx_th_dec, data_v_th_dec,10);
figure
compare(m_amx_th_dec,data_v_th_dec);
Hd_amx_th_dec = tf(m_amx_th_dec.B,m_amx_th_dec.A,Te, 'variable','z^-1')
Hc_amx_th_dec = tf(m_amx_th_dec.B(end)/Te_dec,[1 0])

%% IV4 Pozitie
m_iv_th = iv4(data_id_th,[1 1 0]);
Hd_iv_th = tf(m_iv_th.B,m_iv_th.A,Te);

figure
resid(m_iv_th,data_id_th,10);
figure
compare(m_iv_th,data_v_th); 
%% PEM IV4 Pozitie
m_iv_th_pem = pem(m_iv_th,data_id_th);
figure
resid(m_iv_th_pem,data_v_th,10);
figure
compare(m_iv_th_pem,data_v_th);
%% OE Pozitie
m_oe_th = oe(data_id_th,[1 1 0]);
Hd_oe_th = tf(m_oe_th.B,m_oe_th.F,Te,'variable','z^-1')
Hc_oe_th = tf(m_oe_th.B(end)/Te,[1 0])

figure
resid(m_oe_th,data_v_th,10);
figure
compare(m_oe_th,data_v_th);
%%
compare(data_g_th,m_iv_th_pem,m_oe_th)

%%
Hc_auto = series(Hc_w_arx,Hc_amx_th_dec)
Hc_inter = series(Hc_iv_w,Hc_oe_th)