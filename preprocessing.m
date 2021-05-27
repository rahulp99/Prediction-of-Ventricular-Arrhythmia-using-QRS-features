%Extract required time data
for d=1:35
   s=num2str(d);
   if d<10
       s=strcat('0',s); 
   end
   B=importdata(strcat('data/cu',s,'m.mat'));
   D=importdata(strcat('data/cu',s,'_rr.mat'));
   l=D(end);
   ind=[l-(165*250)+1:l-(45*250)];
   main=B(l-(165*250)+1:l-(45*250));
   %plot(ind,main)
   label=[ind;main];
   save(strcat('cudb45raw/ecg',s,'.mat'),'label');
end