addpath('../mcode/')

id.output = {...
    'IkBa','IkBan','IkBaNFkB','IkBaNFkBn','IkBat', ... % 1-5
    'IkBb','IkBbn','IkBbNFkB','IkBbNFkBn','IkBbt', ... % 6-10
    'IkBe','IkBen','IkBeNFkB','IkBeNFkBn','IkBet', ... % 11-15
    'NFkB','NFkBn',                                ... % 16-17
    'LPSo','LPS','LPSen','TLR4','TLR4en',          ... % 18-22
    'TLR4LPS','TLR4LPSen','MyD88','MyD88s','TRIF', ... % 23-27,MyD88s means M6
    'TRIFs','TRAF6','TRAF6s','IKKK_off','IKKK',    ... % 28-32
    'IKK_off','IKK','IKK_i','TBK1','TBK1s'         ... % 33-37
    'IRF3','IRF3s','IRF3n','IRF3ns'              ... % 38-41
             };

id.genotype = 'tko';

id.dose = 100; 

id.inputP  =3 ; 
id.inputPid = 19; 
id.DT = 1; 
sim = getSimData(id); 

id.inputP = 1; 


figure('units','normalized','outerposition',[0 0 1 1])

for i = 1:41
    suplot(6,7,i) 
    plot(sim(i,:))
    hold on 
    title(id.output{i})
end

