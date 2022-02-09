%% Calculating Impedance of an Inductor wound on a Ferrite Toroid core.
% 220209 
%
% Inductance is calculated using a formula derived from equations in the 
% papter: "Specifying a Ferrite for EMI Suppression," by Carole U. Parker 
% of Fair-Rite Products.  This paper appeared in the June, 2008 issue of
% "Conformity", but should be found on the Fair-Rite site (Google title).
%
% Self-Resonant-Frequency (SRF) is simulated by specifying a shunt 
% capacitance value paralled with the inductor.
%
% The ferrite mix's u' and u'' values (vs frequency) come from a .CSV file
% downloaded from the Fair-Rite website.
%
% The inductor analyzed in this example is 12 turns wound on a Mix 31 
% FT-240 core.
%
% Run on MATLAB Version R2020a
% k6jca

clear;
clc;
close all;

comment1='12 tight turns on FT-240 Mix 31 Core';  % for Plot annotation

% The ferrite mix u' and u'' data is in the following .CSV file.  Note that 
% the data in Fair-rite's downloadable .CSV file spans the frequency range
% of 10 KHz to 1 GHz (much more than I need), and so I trimmed it down 
% to cover only 1-60 MHz and renamed the file:
ftoread = '31-Material-Fair-Rite_1MHz-60MHz.csv'; % File with Mix data

N = 12;  % inductor's number of turns

% FT240 dimensions
OD = 61;    % outer-diameter, in mm
ID = 35.55; % inner-diameter, in mm
HT = 12.7;  % height, in mm

% Define the inductor's shunt capacitance (which affect the inductor's 
% self-resonant-frequency (SRF).
% (One can manually adjust so that calculated SRF is similar to
% measured SRF).
Cs = 0.65e-12;               % in Farads
Cs_text = num2str(Cs*1e12);  % For plot annotation

% Read Fair-Rite's "mix" data from the CSV file and store in matrices.
% Note that the Excel file is in a directory parallel with the directory
% holding this matlab script.
A = readmatrix(['..\Excel\',ftoread]);  % CSV file is in EXCEL directory
f = A(:,1);      % frequency
u1 = A(:,2);     % Ferrite's u' value
u2 = A(:,3);     % Ferrite's u'' value
len = length(f);

jw = 1i*2*pi*f;  % convert frequency to radians

% Calculate the inductor's impedance.
% (Formula derived from equations in the papter: "Specifying a Ferrite
%  for EMI Suppression," by Carole U. Parker of Fair-Rite Products.)
Zl = jw*4.6052e-10*(N^2).*(u1-1i*u2)*HT*log10(OD/ID);

% The shunt capacitance is in parallel with the inductor, and is
% the source of the inductor's Self-Resonant-Frequency.
%
% Because it is in parallel, a simple way to calculate its effect
% on impedance is to convert the inductor's and capacitor's impedances
% to admittances (admittance is just the inverse of impedance), add them, 
% and then convert the sum back to impedance.
% Matlab has two nice routines for doing the matrix inversions:
% z2y() and y2z().
%
YZl = squeeze(z2y(Zl));      % inductor's admittance
YCs = (jw*Cs);               % capacitor's admittance
Ytot = YZl + YCs;            % sum admittances
Ztotal = squeeze(y2z(Ytot)); % Final impedance (Z(inductor) paralled with
                             % Z(cap)) is the inversion of Y

%% Plot Impedance Characteristics vs Frequency 
%
figure(1)

x0=650;
y0=220;
width=750;
height=500;
set(gcf,'units','points','position',[x0,y0,width,height]);
sgt = sgtitle({'Calculated Impedance of ',comment1,['(shunt capacitance = ',Cs_text,' pF)'],''}, 'FontWeight','bold');  % Title on 3 lines

subplot(2,2,1);
plot(f*1e-6,abs(Ztotal),'Color', [0.3010, 0.7450, 0.9330],'LineStyle','-','linewidth',2);

title('Impedance Magnitude (|Z|)');
grid on;
grid minor;
ax = gca;
%ax.GridColor = [0.5, 0.5, 0.5];  % [R, G, B]
ax.GridAlpha = 0.4;  % Make grid lines less transparent.
ax.GridColor = [0,0,0]; % 
ax.MinorGridAlpha = 0.5;  % Make grid lines less transparent.
ax.MinorGridColor = [0,0,0]; % 
ylabel('Ohms');
xlabel('MHz');


subplot(2,2,3);
plot(f*1e-6,(angle(Ztotal)*180/pi),'Color', [0.3010, 0.7450, 0.9330],'LineStyle','-','linewidth',2);

title('Impedance Phase');
grid on;
grid minor;
ax = gca;
%ax.GridColor = [0.5, 0.5, 0.5];  % [R, G, B]
ax.GridAlpha = 0.4;  % Make grid lines less transparent.
ax.GridColor = [0,0,0]; % 
ax.MinorGridAlpha = 0.5;  % Make grid lines less transparent.
ax.MinorGridColor = [0,0,0]; % 
ylabel('Degrees');
xlabel('MHz');


subplot(2,2,2);
plot(f*1e-6,real(Ztotal),'Color', [0.3010, 0.7450, 0.9330],'LineStyle','-','linewidth',2);

title('Resistance');
grid on;
grid minor;
ax = gca;
%ax.GridColor = [0.5, 0.5, 0.5];  % [R, G, B]
ax.GridAlpha = 0.4;  % Make grid lines less transparent.
ax.GridColor = [0,0,0]; % 
ax.MinorGridAlpha = 0.5;  % Make grid lines less transparent.
ax.MinorGridColor = [0,0,0]; % 
ylabel('Ohms');
xlabel('MHz');


subplot(2,2,4);
plot(f*1e-6,imag(Ztotal),'Color', [0.3010, 0.7450, 0.9330],'LineStyle','-','linewidth',2);

title('Reactance');
grid on;
grid minor;
ax = gca;
%ax.GridColor = [0.5, 0.5, 0.5];  % [R, G, B]
ax.GridAlpha = 0.4;  % Make grid lines less transparent.
ax.GridColor = [0,0,0]; % 
ax.MinorGridAlpha = 0.5;  % Make grid lines less transparent.
ax.MinorGridColor = [0,0,0]; % 
ylabel('Ohms');
xlabel('MHz');


