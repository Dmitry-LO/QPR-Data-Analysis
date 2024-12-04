clc,clear

OSC_data=importdata('D:\CERNbox\QPR tests & Operation\PLL_TESTING\qpr_pll_phi125_2020-01-16_0_160104.Wfm.csv', ';', 0);
%OSC_data(:,4)=sqrt(OSC_data(:,2).^2+OSC_data(:,3).^2);
%qpr_pll_rfOFF_2020-01-16_0_161731.Wfm.csv
%qpr_pll_phase0_2020-01-16_0_161154.Wfm.csv
figure
hold on
%cc=100;
%plot(OSC_data(1:end,1),OSC_data(1:end,3),'.'); 
plot(OSC_data(1:end,1)); 
plot(OSC_data(1:end,2)); 
plot(OSC_data(1:end,3)); 
hold off
%%
plot(OSC_data(1:end,3),'.'); 