% logreader.m
% Use this script to read data from your micro SD card

clear all;
%clf;
% 119 - first run - looking good 9:30am - Marika
%123 - 9:53 - second run - Emma
% 124 - 10:05 - Lucas
% 129 - 10:45 - Josaphat 
% 136/7/8/9 - 4 runs in sequence ending at 12:52

% 136 - 12:30 - Josaphat 
% 
filenum = '135'; % file number for the data you want to read
infofile = strcat('INF', filenum, '.TXT');
datafile = strcat('LOG', filenum, '.BIN');

%% map from datatype to length in bytes
dataSizes.('float') = 4;
dataSizes.('ulong') = 4;
dataSizes.('int') = 4;
dataSizes.('int32') = 4;
dataSizes.('uint8') = 1;
dataSizes.('uint16') = 2;
dataSizes.('char') = 1;
dataSizes.('bool') = 1;

%% read from info file to get log file structure
fileID = fopen(infofile);
items = textscan(fileID,'%s','Delimiter',',','EndOfLine','\r\n');
fclose(fileID);
[ncols,~] = size(items{1});
ncols = ncols/2;
varNames = items{1}(1:ncols)';
varTypes = items{1}(ncols+1:end)';
varLengths = zeros(size(varTypes));
colLength = 256;
for i = 1:numel(varTypes)
    varLengths(i) = dataSizes.(varTypes{i});
end
R = cell(1,numel(varNames));

%% read column-by-column from datafile
fid = fopen(datafile,'rb');
for i=1:numel(varTypes)
    %# seek to the first field of the first record
    fseek(fid, sum(varLengths(1:i-1)), 'bof');
    
    %# % read column with specified format, skipping required number of bytes
    R{i} = fread(fid, Inf, ['*' varTypes{i}], colLength-varLengths(i));
    eval(strcat(varNames{i},'=','R{',num2str(i),'};'));
end
fclose(fid);

%% Process your data here
figure(1)

plot (double(A00) * (3.3/1023));
title("Hall Effect Sensor")


figure(2)
subplot(2,1,1);
plot(double(A01) * (3.3/1023));
title("Photodiode Sensor")
subplot(2,1,2);
plot(double(A03) * (3.3/1023));


figure(3)
plot(double(A02) * (3.3/1023));
title("Pressure Sensor")

%Depth Plot
figure(4)
plot(depth)
title('Depth Plot')
ylabel('Depth [m]')



