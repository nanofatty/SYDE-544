function dydt = HH(t,y)

Ck_o = 5; % [K outside]
Ck_i = 100; % [K inside]
Cna_o = 150; % [Na outside]
Cna_i = 15; % [Na inside]

ENa= 61.54*log10(Cna_o/Cna_i); % mv Na equilibrium @ body temp
EK=61.54*log10(Ck_o/Ck_i);% mv Na equilibrium @ body temp
El=-49; % mv Leakage equilibrium

gNa=1.2; % Na conductance constant
gK=0.36; % K conductance constant
gL=0.003; % Leakage conductance constant

I = 0.1; %Applied Current
Cm = 0.01; %Membrane Capacitance

% Values set to equal input values
V = y(1);
n = y(2);
m = y(3);
h = y(4);

GNa= gNa*m^3*h; % Na conductance
GK= gK*n^4; % K conductance
GL= gL; % Leakage conductance
INa= GNa*(V-ENa);% Na current
IK= GK*(V-EK); % K current
Il= GL*(V-El); % Leak current

%Hodgkin-Huxley Model Equations
dydt = [(-IK-INa-Il+I)/Cm;% membrane voltage
    (an(V)*(1-n))-(bn(V)*n); % gating variable n
    (am(V)*(1-m))-(bm_(V)*m); % gating variable m
    (ah(V)*(1-h))-(bh(V)*h);]; % gating variable h