function CoolDownData = fm1_LoadingH5Data_CERN(Set1Data,Set2Data,Set3Data)

CoolDownData1 = h5read(Set1Data,'/Raw_data/calc/PDC1');
CoolDownData3 = h5read(Set3Data,'/Raw_data/calc/PDC1');
CoolDownData2 = h5read(Set2Data,'/Raw_data/calc/PDC1');
CoolDownDataAll.PDC1 = [CoolDownData1;CoolDownData2;CoolDownData3];
clearvars CoolDownData1 CoolDownData2 CoolDownData3;


CoolDownData1 = h5read(Set1Data,'/Raw_data/calc/PDC2');
CoolDownData3 = h5read(Set3Data,'/Raw_data/calc/PDC2');
CoolDownData2 = h5read(Set2Data,'/Raw_data/calc/PDC2');
CoolDownDataAll.PDC2 = [CoolDownData1;CoolDownData2;CoolDownData3];
clearvars CoolDownData1 CoolDownData2 CoolDownData3;

CoolDownData1 = h5read(Set1Data,'/Raw_data/calc/Pt');
CoolDownData3 = h5read(Set3Data,'/Raw_data/calc/Pt');
CoolDownData2 = h5read(Set2Data,'/Raw_data/calc/Pt');
CoolDownDataAll.Pt_raw_W = [CoolDownData1;CoolDownData2;CoolDownData3];
clearvars CoolDownData1 CoolDownData2 CoolDownData3;

CoolDownData1 = h5read(Set1Data,'/Raw_data/pwm/PF_raw_dBm');
CoolDownData3 = h5read(Set3Data,'/Raw_data/pwm/PF_raw_dBm');
CoolDownData2 = h5read(Set2Data,'/Raw_data/pwm/PF_raw_dBm');
CoolDownDataAll.PF_raw_dBm = [CoolDownData1;CoolDownData2;CoolDownData3];
clearvars CoolDownData1 CoolDownData2 CoolDownData3;

CoolDownData1 = h5read(Set1Data,'/Raw_data/pwm/PR_raw_dBm');
CoolDownData3 = h5read(Set3Data,'/Raw_data/pwm/PR_raw_dBm');
CoolDownData2 = h5read(Set2Data,'/Raw_data/pwm/PR_raw_dBm');
CoolDownDataAll.PR_raw_dBm = [CoolDownData1;CoolDownData2;CoolDownData3];
clearvars CoolDownData1 CoolDownData2 CoolDownData3;

CoolDownData1 = h5read(Set1Data,'/Raw_data/pwm/PT_raw_dBm');
CoolDownData3 = h5read(Set3Data,'/Raw_data/pwm/PT_raw_dBm');
CoolDownData2 = h5read(Set2Data,'/Raw_data/pwm/PT_raw_dBm');
CoolDownDataAll.PT_raw_dBm = [CoolDownData1;CoolDownData2;CoolDownData3];
clearvars CoolDownData1 CoolDownData2 CoolDownData3;

CoolDownData1 = h5read(Set1Data,'/Raw_data/fsv/FSV4_center_frequency_MHz');
CoolDownData3 = h5read(Set3Data,'/Raw_data/fsv/FSV4_center_frequency_MHz');
CoolDownData2 = h5read(Set2Data,'/Raw_data/fsv/FSV4_center_frequency_MHz');
CoolDownDataAll.F0_Hz = [CoolDownData1;CoolDownData2;CoolDownData3];
clearvars CoolDownData1 CoolDownData2 CoolDownData3;

CoolDownData1 = h5read(Set1Data,'/Raw_data/lakeshore/Cernox_4');
CoolDownData3 = h5read(Set3Data,'/Raw_data/lakeshore/Cernox_4');
CoolDownData2 = h5read(Set2Data,'/Raw_data/lakeshore/Cernox_4');
CoolDownDataAll.Temp = [CoolDownData1;CoolDownData2;CoolDownData3];
clearvars CoolDownData1 CoolDownData2 CoolDownData3;

CoolDownData1 = h5read(Set1Data,'/Raw_data/calc/Rs');
CoolDownData3 = h5read(Set3Data,'/Raw_data/calc/Rs');
CoolDownData2 = h5read(Set2Data,'/Raw_data/calc/Rs');
CoolDownDataAll.Rs = [CoolDownData1;CoolDownData2;CoolDownData3];
clearvars CoolDownData1 CoolDownData2 CoolDownData3;

CoolDownData1 = h5read(Set1Data,'/Raw_data/calc/Bpeak');
CoolDownData3 = h5read(Set3Data,'/Raw_data/calc/Bpeak');
CoolDownData2 = h5read(Set2Data,'/Raw_data/calc/Bpeak');
CoolDownDataAll.Bpeak = [CoolDownData1;CoolDownData2;CoolDownData3];
clearvars CoolDownData1 CoolDownData2 CoolDownData3;

dsize=size(CoolDownDataAll.PDC1)
q1i=1;
q2i=1;
q3i=1;

for i=1:dsize(1,1)
    
if and(CoolDownDataAll.F0_Hz(i)>300E6,CoolDownDataAll.F0_Hz(i)<500E6)
    CoolDownData.Q1.PDC1(q1i,1)= CoolDownDataAll.PDC1(i);
    CoolDownData.Q1.PDC2(q1i,1)= CoolDownDataAll.PDC2(i); 
    CoolDownData.Q1.Pt_raw_W(q1i,1) = CoolDownDataAll.Pt_raw_W(i);
    CoolDownData.Q1.PF_raw_dBm(q1i,1) = CoolDownDataAll.PF_raw_dBm(i);
    CoolDownData.Q1.PR_raw_dBm(q1i,1) = CoolDownDataAll.PR_raw_dBm(i);
    CoolDownData.Q1.PT_raw_dBm(q1i,1) = CoolDownDataAll.PT_raw_dBm(i);
    CoolDownData.Q1.F0_Hz(q1i,1) = CoolDownDataAll.F0_Hz(i);
    CoolDownData.Q1.Temp(q1i,1) = CoolDownDataAll.Temp(i);
    CoolDownData.Q1.Rs(q1i,1) = CoolDownDataAll.Rs(i);
    CoolDownData.Q1.Bpeak(q1i,1) = CoolDownDataAll.Bpeak(i);
    q1i=q1i+1;
elseif and(CoolDownDataAll.F0_Hz(i)>700E6,CoolDownDataAll.F0_Hz(i)<900E6)
    CoolDownData.Q2.PDC1(q2i,1)= CoolDownDataAll.PDC1(i);
    CoolDownData.Q2.PDC2(q2i,1)= CoolDownDataAll.PDC2(i); 
    CoolDownData.Q2.Pt_raw_W(q2i,1) = CoolDownDataAll.Pt_raw_W(i);
    CoolDownData.Q2.PF_raw_dBm(q2i,1) = CoolDownDataAll.PF_raw_dBm(i);
    CoolDownData.Q2.PR_raw_dBm(q2i,1) = CoolDownDataAll.PR_raw_dBm(i);
    CoolDownData.Q2.PT_raw_dBm(q2i,1) = CoolDownDataAll.PT_raw_dBm(i);
    CoolDownData.Q2.F0_Hz(q2i,1) = CoolDownDataAll.F0_Hz(i);
    CoolDownData.Q2.Temp(q2i,1) = CoolDownDataAll.Temp(i);
    CoolDownData.Q2.Rs(q2i,1) = CoolDownDataAll.Rs(i);
    CoolDownData.Q2.Bpeak(q2i,1) = CoolDownDataAll.Bpeak(i);
    q2i=q2i+1;
elseif and(CoolDownDataAll.F0_Hz(i)>1100E6,CoolDownDataAll.F0_Hz(i)<1400E6)
    CoolDownData.Q3.PDC1(q3i,1)= CoolDownDataAll.PDC1(i);
    CoolDownData.Q3.PDC2(q3i,1)= CoolDownDataAll.PDC2(i); 
    CoolDownData.Q3.Pt_raw_W(q3i,1) = CoolDownDataAll.Pt_raw_W(i);
    CoolDownData.Q3.PF_raw_dBm(q3i,1) = CoolDownDataAll.PF_raw_dBm(i);
    CoolDownData.Q3.PR_raw_dBm(q3i,1) = CoolDownDataAll.PR_raw_dBm(i);
    CoolDownData.Q3.PT_raw_dBm(q3i,1) = CoolDownDataAll.PT_raw_dBm(i);
    CoolDownData.Q3.F0_Hz(q3i,1) = CoolDownDataAll.F0_Hz(i);
    CoolDownData.Q3.Temp(q3i,1) = CoolDownDataAll.Temp(i);
    CoolDownData.Q3.Rs(q3i,1) = CoolDownDataAll.Rs(i);
    CoolDownData.Q3.Bpeak(q3i,1) = CoolDownDataAll.Bpeak(i);
    q3i=q3i+1;
end

end
end

