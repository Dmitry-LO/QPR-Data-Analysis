function T_RS_PD = srimp(TC,FAK,DLON,XKOH,RRR,FREQ,REST,TE)
% Computes BCS parameters
%   TC = Transition temperature (K)
%   FAK = DELTA / kTc
%   DLON = London penetration depth (A)
%   XKOH = Coherence length (A)
%   RRR = RRR
%   FREQ = Frequency (MHz)
%   REST = Accuracy of calcuation (.001)
%   TE = vector of temperatures to be evaluated

% OUTPUT: Temperature, Diffuse Reflection, Specular Reflection
%            T(K) , Rs(nOhm),PenDepth(nm), Rs(nOhm),PenDepth(nm)

FREI=27*RRR; FO=FREQ*1e6; IT=length(TE); T_RS_PD=zeros(IT,5);

% THE M0MENTUM INTEGRAL IS SPLIT INTO 6 PARTS OVER THE INTERVALS (G(I), G(I+1)).
G = [1.E-6, 1.E-2, .2, 2.0, 5.0, 50.0];
% THESE 6 INTEGRALS ARE EVALUATED BY SIMPSON'S RULE. 1/ID(I) GIVES THE SPACING OF THE ABCISSAS.
IS=floor((6.0*10^(-4)/REST)^0.25+1.0); 
PH=0.479*10.0^(-10);
CI=sqrt(-1);
FLO=XKOH/FREI;
AL=DLON/XKOH;
OG=PH*FO/TC/FAK;
ID =([5, 7, 15, 20, 20, 9]*IS);	 

% This loop sets DX, the spacing (mesh size) of the integral; spacing is different for different regions
DX=[0 G(1)]; DQ=zeros(1,5);
for n=1:5
	DQ(n)=(G(n+1)-G(n))/(ID(n))/6;			% DQ measures mesh size; used in haupt()
	d=linspace(G(n),G(n+1),2*ID(n)+1);
	DX = [DX d(2:length(d))];
end
% Set the last part of the spacing seperately here:
DQ(6)=(1/G(6)-G(1))/(ID(6))/6;
d=1./linspace(G(1),1/G(6),2*ID(6)+1);
DX = [DX d];
IQ = length(DX);
ID = ID-1;

for K=1:IT
    T=TE(K)/TC;
    B=pi/2.0*(1.0-T*T);
    AG=sqrt(sin(B));
    FL=FLO/AG;
    O=OG/AG;
	if(O<0.5)
        GP=AG/T*FAK;
        
        IS=floor(1.0/sqrt(O*REST)/5.0);		% Casting is implicit in FORTRAN code; done by hand here
        IP=floor(1.0/sqrt((2.0-O)*REST)/5.0);
        
        CDS = nonan(GP, O, IS, CI, FL, IQ, IP, DX);
        MS=floor(GP/(sqrt(REST)*2.0*pi));
        
        CDS = isum(GP, IQ, MS, O, CI, FL, CDS, DX);
        
        DQ1=abs(CDS(1));
        ENP=1.0/sqrt(DQ1);
        AK=AL*ENP*AG;
        A2=AK*AK;
        
        [CHS, CHD] = haupt(ID, DQ, AK, DX, DQ1, CDS, A2);
        
        CHS=CHS*ENP;
        CHD=CHD*ENP;
        XS=(real(CHS))*DLON; % Specular Reflection
        XD=(real(CHD))*DLON; % Diffuse Reflection
        
        B=(FO/(10.0)^17)*8.0*pi^2*DLON;
        RS=(imag(CHS))*B; % Specular Reflection
        RD=(imag(CHD))*B; % Diffuse Reflection
        
        % OUTPUT: Temperature, Diffuse Reflection, Specular Reflection
        %            T(K) , Rs(nOhm),PenDepth(nm), Rs(nOhm),PenDepth(nm)
        T_RS_PD(K,:)=[TE(K), RD*1e9 , XD/10,        RS*1e9 , XS/10 ];
	end
end
end

%---------------------------

function CT = wink(CL, CI, DX)
% Numerical stuff
    thresh=sign(ceil(abs(DX/CL)-.2));     % 1 for abs(DX(i)/CL)>.2, and 0 for the rest

    DX(1)=1;		% To preven NaN; reverted below
    CT=(0.75)./DX.*(-2.0*CL./DX+(1.0+(CL./DX).^2)/CI.*(log(CL./DX+CI)-log(CL./DX-CI))).*thresh + ...
        3.0/CL*(1.0/3.0-((DX/CL).^2).*(1.0/15.0-((DX/CL).^2).*(1.0/35.0-((DX/CL).^2).*(1.0/63.0-...
        ((DX/CL).^2).*(1.0/99.0-((DX/CL).^2).*(1.0/143.0-((DX/CL).^2).*(1.0/195.0-((DX/CL).^2)./255.0)))))))...
        .*(1-thresh);
%     DX(1)=0;
    CT(1)=1/CL;
end

%---------------------------

function CDS = isum(GP, IQ, MS, O, CI, FL, CDS, DX)
    G=pi/GP;
    DS(1:IQ)=zeros(1,IQ);   
    for M=1:MS
        B=2*(MS-M)+1;
        B=B*G;
        DU=B*B+1.0;
        CB=B+O*CI;
        CU=CB*CB+1.0;
        DW=sqrt(DU);
        CW=sqrt(CU);    
        CL=(DW+CW)/2.0+FL;
        CP=DW*CW;
        CA=(1.0-B*CB+CP)/CP;

        CT = wink(CL, CI, DX);

        DS(1:IQ)=real(DS(1:IQ)+CA*CT(1:IQ));
    end
    CDS(1:IQ)=DS(1:IQ)*G + CDS(1:IQ);
end

%----------------------------

function CDS = nonan(GP, O, IS, CI, FL, IQ, IP, DX)
% Most computational time spent here
    DS(1:IQ)=zeros(1,IQ);
    CDS=DS;
    OT=O/2.0*GP;
    if(OT<=0.2)
        O2=OT^2;
        DV=OT*(1.0+O2/6.0*(1.0+O2/20.0*(1.0+O2/42.0*(1.0+O2/72.0*(1.0+O2/110.0)))))*exp(-OT);
        OT=-OT*2.0;
    else
        OT=-OT*2.0;
        DV=(1.0-exp(OT))/2.0;
    end
    B=4.0*IS;
    BS=pi/B;

    for K=1:IS
        B=4.0*(IS-K)+2;
        D=B*BS;
        DZ=0.5*(1.0+cos(D));
        DU=GP/DZ;
        DA=exp(-DU);
        DG=exp(-DU+OT);
        DC=DA/((1.0+DG)*(1.0+DA))*DV;
        DP=DZ+1.0;
        DM=1.0-DZ;
        DU=DP*DM;
        DW=sqrt(DU);
        DA=DZ*O;
        DWO=sqrt(DU+DA*(2.0+DA));
        DP=DZ*sqrt(DZ*DP);
        DU=DA/DU;

        if(DU<=0.1)
            DU=DU*(2.0+DA)/2.0;
            DM=DU*(1.0-0.5*DU*(1.0-DU*(1.0-1.25*DU*(1.0-1.4*DU*(1.0-1.5*DU*...
            (1.0-11.0*DU/7.0*(1.0-1.5*DU*(1.0-13.0*DU/9.0*(1.0-1.4*DU)))))))))*DW;
        else
            DM=DWO-DW;
        end

        CY=-CI*DM/2./DZ+FL;

        CT = wink(CY, CI, DX);				%This could be precomputed...

        DU=DC/DP/DWO;
        DWU=DWO*DW;
        DM=1.+DZ*(DZ+O);
        DPS=(DM+DWU)*DU;
        DMS=(DM-DWU)*DU;

        CDS(1:IQ)=CDS(1:IQ)+DPS*CT(1:IQ); 

        DM=DWO+DW;
        CY=CI*DM/2.0/DZ+FL;

        CT = wink(CY, CI, DX);

        DS(1:IQ)=real(DS(1:IQ)+DMS*CT(1:IQ));
    end
	
	CY=-CI*BS*4.0;
	CDS(1:IQ)=(CDS(1:IQ)+DS(1:IQ))*CY; DS(1:IQ)=zeros(1,IQ);
	B=4*IP;
	BS=pi/B;

    for K=1:IP
        B=4*(IP-K)+2;
        D=B*BS;
        DZ=1.0+0.5*O*(1.0+cos(D));
        DU=GP*DZ;
        DA=exp(-DU);
        DG=exp(-DU-OT);
        DC=DG/((1.0+DG)*(1.0+DA))*DV;
        DP=DZ+1.0;
        DM=DZ-1.0;
        DW=sqrt(DP*DM);
        DA=O-DM;
        DU=DP-O;
        DWO=sqrt(DA*DU);
        CY=DWO+CI*DW+FL;

        CT = wink(CY, CI, DX);

        CY=(1.0+DZ*(DZ-O)+CI*DW*DWO)/sqrt(DP*DU)*DC;
        DS(1:IQ)=real(DS(1:IQ)+CY*CT(1:IQ));
    end
	
    B=+BS*4.0; % The plus sign was present in the FORTRAN code, but is apparently benign (& has no effect here)
    CDS(1:IQ)=CDS(1:IQ)+DS(1:IQ)*B;
end

%----------------------------

function [L, CS, CD] = intq(L, M, DQ1, CDS, DX, A2)
    CDG=CDS(L)/DQ1;
    DX2=DX(L)*DX(L);
    DA=DX2*A2;

    if (M==1)
        CS=1.0/(DA+CDG);
        CD=log(1.0+CDG/DA);	
    elseif(M==2)
        CS=1.0/(A2+CDG/DX2);
        CD=log(1.0+CDG/DA)*DX2;	
    end 
    L=L+1;
end

%----------------------------

function [CHS, CHD] = haupt(ID, DQ, AK, DX, DQ1, CDS, A2)
    M=1; I=2;
    [I,CS,CD]=intq(I,M,DQ1,CDS,DX,A2);
    CIS=DX(2)*CS;
    CID=DX(2)*CD+2.*DX(2);

    for J=1:6
        if(J>=6)
            M=2;
            [I,CS,CD]=intq(I,M,DQ1,CDS,DX,A2);
            CIS=CIS+CS*DX(2);
            CID=CID+CD*DX(2);
        end

        CES=0.; CED=0.; CAS=0.5*CS; CAD=0.5*CD; LL=ID(J);

        for K=1:LL
            [I,CS,CD]=intq(I,M,DQ1,CDS,DX,A2);
            CES=CES+CS; CED=CED+CD;
            [I,CS,CD]=intq(I,M,DQ1,CDS,DX,A2);
            CAS=CAS+CS; CAD=CAD+CD;
        end

        [I,CS,CD]=intq(I,M,DQ1,CDS,DX,A2);

        CES=CES+CS; CED=CED+CD;

        [I,CS,CD]=intq(I,M,DQ1,CDS,DX,A2);

        CIS=CIS+DQ(J)*(4.0*CES+(2.0*CAS+CS)); CID=CID+DQ(J)*(4.0*CED+(2.0*CAD+CD));
    end

    A=2.0/pi*AK; CHS=A*CIS; CHD=2.0/A/CID;
end
