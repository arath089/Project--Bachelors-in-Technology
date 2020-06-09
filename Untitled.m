clear all;clc;%---Clear workspace and command window
%---Read image form the specified path and assign it to In
In = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';'*.*','All Files' },'Select Image File');
In = imread(In);%---Read iamge and assign it to In
I_Pre = Preprocess(In);%---Preprocessing Original Image
Ig = I_Pre.Ig;%---Assigning Image of double class to Ig
figure(1);subplot(1,2,1);imshow(In);%---Show Original Image on first Figure window
%---Check for RGB or Gray Scale Image
if I_Pre.o==1
    title('Original Grayscale Image');%---Title for Original Grayscale Image
else
    title('Original RGB Image');%---Title for Original RGB Image
end
figure(1);subplot(1,2,2);imshow(Ig);%---Show grayscale Image on first Figure window
%---Title for Grayscale double class image of an Original Image
title('Grayscale double class image of an Original Image');

%-----------------------------Analysis Starts-----------------------------%

%-------------------------Median Filter Analysis--------------------------%

%---Creating cell Fields for passing it to an excel file
Fields = {'Filter','Window','MSE','PSNR','SNR'};
%---Excel file in which performance metrics has to be written
xlswrite('Performance Metrics.csv', Fields, 1, 'A1');%---Writing on 1st sheet
for c = [3 5 8 10]
    I_anyl = NSRFilters(In,'med',c,c);%---Applying median filter
    if c == 3
        i = 1;
    elseif c == 5
        i = 2;
    elseif c == 8
        i = 3;
    else
        i = 4;
    end
    figure(2);subplot(2,2,i);imshow(I_anyl);%---Show Filtered Image on second Figure window
    title(['Filtered Image using Median Filter; window size = ',num2str(c)]);
    QM(i) = MetricsMeasurement(Ig,I_anyl);%---Calculating Performance Metrics
    mfmse(i) = QM(i).M_SE;mfpsnr(i) = QM(i).PSNR; mfsnr(i) = QM(i).SNR;
    QMxls = {'Median',c,QM(i).M_SE,QM(i).PSNR,QM(i).SNR};
    index_num = i+1;
    index = num2str(index_num);
    cell = strcat('A',index);
end
c = [3 5 8 10];
axis square;
figure(11);subplot(2,2,1);
semilogy(c,mfmse,'-ro',c,mfpsnr,'-ms',c,mfsnr,'-bd');
legend('MSE','PSNR','SNR',0);
xlabel('Window Size');
ylabel('Performacne Metrics');
title('Variation in performance metrics with window size for Median Filter');
