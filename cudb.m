clear all;

featureMatrix = zeros(35,7);

for i = 1:35
    s = num2str(i);
    if i<10
        s = strcat('0',s);
    end
    ecg = importdata(strcat('cudbExtracted/ecg',s,'.mat'));
    
    ecg = ecg(2,:);
    ecg = ecg/400;
    
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
        featureMatrix(i,7) = 1;
    else
        continue;
    end
end

save('featureMatrixCUDB.mat','featureMatrix');