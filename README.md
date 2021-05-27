## Prediction of Occurrence of Ventricular Arrhythmia using QRS features

Ventricular arrhythmia (VA) causes a very fast heart rate and eventual death if there is no immediate medical attention given. Most sudden cardiac deaths are caused by abnormal heart rhythms, also called arrhythmia. There are mainly two different arrhythmias which are Ventricular Fibrillation(VF) & Ventricular Tachycardia(VT). This project is about training a Machine Learning model to predict Ventricular Fibrillation before its occurrence.

#### Dataset Decsription

The following freely available databases in PhysioNet are used -
- For ventricular fibrillation data, [Creighton University (CU) ventricular tachyarrhythmia(CUDB) Database](https://www.physionet.org/content/cudb/1.0.0/), with *250 Hz* sampling frequency, is used.

- For the control dataset (of normal ECG signal), the [MIT-BIH normal sinus rhythm database (NSRDB)](https://www.physionet.org/content/nsrdb/1.0.0/), with *128 Hz* sampling frequency, is used.

There are 35 recordings in the CUDB, used for feature extraction for VF. The control group consists of 28 subjects from the NSRDB. The database contains information about the nature of the beats through annotations. These annotations indicate specific locations in the ECG recordings and describe the corresponding occurring beat or non-beat event.

#### Data Pre-processing

- Starting from the onset of VF, raw ECG signals are trimmed up to the 150s duration before the onset of VF.

- The trimmed ECG signal is divided into two parts:
	1. **Required Time** (120s duration, *150s to 30s prior to VF occurrence*)
	2. **Forecast Time** (30s duration, *30s to 0s prior to VF occurrence*)

![Required and Forecast time](/images/preprocessing.png "Required and Forecast time")

- QRS features are extracted from the *Required Time* ECG.

- Due to the difference in sampling rate of the 2 databases, the data from NSRDB is resampled from 128Hz to 250Hz.

#### Feature Extraction

- The QRS complex contains Q, R and S waves, from which signed and unsigned areas, and R-peak amplitudes are calculated.

- *Pan Tompkins* algorithm is used to extract the R-peak amplitude.

- QRS complex signed area is calculated as the weighted sum of the samples between 2 points, point Q and point S.

- QRS complex unsigned area is calculated as the absolute weighted sum of the samples between 2 points, point Q and point S.

- For locating the Q and S points *MTEO_qrst.m* function from the [BioSigKit](https://in.mathworks.com/matlabcentral/fileexchange/67805-biosigkit-a-toolkit-for-bio-signal-analysis) is used, which is a toolkit for Bio-Signal Analysis in MATLAB.

- Mean and Standard Deviation is calculated for each of the 3 components found above. These constitute the features for training our model.

- After this, we get a feature matrix that consists of 63 samples and 6 features.

- The feature matrix is then normalised.

#### Model Training

- Models are trained using two sets of features:

	1. **6 Features:** Used mean and standard deviation for all the 3 components, R-peak amplitude and QRS signed and unsigned area, giving total of 6 features.

	2. **4 Features:** Used mean and standard deviation for only 2 components, R-peak amplitude and QRS signed area, giving total of 4 features.

- Algorithms used are K-Nearest Neighbor (KNN), Logistic Regression, Support Vector Machine (SVM), Discriminant Analysis, Naïve Bayes, Decision Tree and Ensemble Classifier.

- Table below contains the accuracy of the models trained.

![Table with Accuracies](/images/table.png "Table with Accuracies")

> **NOTE:** The above process is also done with 45s forecast time, to predict the occurrence of Ventricular Arrhythmia earlier, and the result is shown in table above.