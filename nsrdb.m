clear all;

%% Extracting 120s nsrdb normal data
datasets = [16265 16272 16273 16420 16483 16539 16786 16795 17052 17453 18177 18184 19088 19093 19140 19830];

% for i = 1:length(datasets)
%     s = num2str(datasets(i));
%     ecg = importdata(strcat('normalData/',s,'m.mat'));
%     extractedECG1 = ecg(1, (128*100):(128*220));
%     extractedECG2 = ecg(2, (128*200):(128*320));
%     extractedECG1 = extractedECG1/200;
%     extractedECG2 = extractedECG2/200;
%     save(strcat('normalExtracted/',s,'_1.mat'),'extractedECG1');
%     save(strcat('normalExtracted/',s,'_2.mat'),'extractedECG2');
% end

%% Making feature matrix

featureMatrix = zeros(28,7);

for i = 1:14
    s = num2str(datasets(i));
    ecg = importdata(strcat('normalExtracted/',s,'_1.mat'));
    
    % resample
    [P,Q] = rat(250/128);
    
    ecg = resample(ecg,P,Q);
    
    [qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(ecg,250,0);
    r_mean = mean(qrs_amp_raw);
    r_std = std(qrs_amp_raw);
    
    featureMatrix(i,1) = r_mean;
    featureMatrix(i,2) = r_std;
    
    [R,Q,S,T,P_w] = MTEO_qrst(ecg,250,0);
    if size(Q) == size(S) && Q(1,1) < S(1,1)
        x = [Q(:,1) S(:,1)];
        signedArea = zeros(size(Q(:,1)));
        absArea = zeros(size(Q(:,1)));
        for k = 1:size(Q(:,1))
            absSum = 0;
            signedSum = 0;
            for j = x(k,1):x(k,2)
                if j == 0
                    continue;
                end
                signedSum = signedSum + ecg(j);
                absSum = absSum + abs(ecg(j));
            end
            signedArea(k) = signedSum;
            absArea(k) = absSum;
        end
        
        qrs_mean = mean(signedArea);
        qrs_std = std(signedArea);
        
        qrs_abs_mean = mean(absArea);
        qrs_abs_std = std(absArea);
        
        featureMatrix(i,3) = qrs_mean;
        featureMatrix(i,4) = qrs_std;
        featureMatrix(i,5) = qrs_abs_mean;
        featureMatrix(i,6) = qrs_abs_std;
        featureMatrix(i,7) = 0;
    else
        continue;
    end
    
    ecg = importdata(strcat('normalExtracted/',s,'_2.mat'));
    
    % resample
    [P,Q] = rat(250/128);
    
    ecg = resample(ecg,P,Q);
    
    [qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(ecg,250,0);
    r_mean = mean(qrs_amp_raw);
    r_std = std(qrs_amp_raw);
    
    featureMatrix(i+14,1) = r_mean;
    featureMatrix(i+14,2) = r_std;
    
    [R,Q,S,T,P_w] = MTEO_qrst(ecg,250,0);
    if size(Q) == size(S) && Q(1,1) < S(1,1)
        x = [Q(:,1) S(:,1)];
        signedArea = zeros(size(Q(:,1)));
        absArea = zeros(size(Q(:,1)));
        for k = 1:size(Q(:,1))
            absSum = 0;
            signedSum = 0;
            for j = x(k,1):x(k,2)
                signedSum = signedSum + ecg(j);
                absSum = absSum + abs(ecg(j));
            end
            signedArea(k) = signedSum;
            absArea(k) = absSum;
        end
        
        qrs_mean = mean(signedArea);
        qrs_std = std(signedArea);
        
        qrs_abs_mean = mean(absArea);
        qrs_abs_std = std(absArea);
        
        featureMatrix(i+14,3) = qrs_mean;
        featureMatrix(i+14,4) = qrs_std;
        featureMatrix(i+14,5) = qrs_abs_mean;
        featureMatrix(i+14,6) = qrs_abs_std;
        featureMatrix(i+14,7) = 0;
    else
        continue;
    end
end

save('resampledFeatureMatrixNSRDB.mat','featureMatrix');