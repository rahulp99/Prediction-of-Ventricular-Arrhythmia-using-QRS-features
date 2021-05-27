clear all;

cudb = importdata('featureMatrixCUDB.mat');
nsrdb = importdata('resampledFeatureMatrixNSRDB.mat');

fm = [cudb;nsrdb];

ir=randsample(1:63,63);
dat=fm(ir,:);
fm=dat;

input = normalize(fm(:,1:6));
t = fm(:,7);

fm = [input t];
