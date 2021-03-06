function ScopeCSVReport
% -------------------------------------------------------------------
% File:    ScopeCSVReport.m
% Descr:   This file reads in a user-prompted csv file that was 
%          generated by an oscilloscope and generates a
%          MS-Word report.
%          
%          Report contents:
%          
%          
%          Tested with: MS Word 2013, Tektronix XXXXXX
% 
% Input
%     User prompted csv file (multiple file support to be supported)
%     [incomplete]
%     
% Output
%     [incomplete]
% 
% Created by: Raj Vinjamuri
%
% Revisions:
% 20151028  RV  Creation of file (not complete)
%
%
% TO DO:
% Combine dialogs into single prompt
%     Warn that large files could take a while
% Add feature tracking
%     Prompt for "event threshold"
%     Find and compile log of events over time
% Add labels to plots based on channel data
%     Y-Axis (channel info read)
%     X-Axis (time and time scale read)
% Add ink saver as option to prompt/dialog
% Change errors to include error dialog boxes (msgbox with error flag)
% Change warnings to include warning dialog boxes (msgbox with warning flag)
% Seek for time in multiple columns for other scopes
% Output statistics with histogram like in minitab
% Chose Specific files in directory (choose multiple, but not all)
% Compare files
%      Overlap Waveform option
% Save option to save figures
%
%
% DONE (many features just added on the fly and not lsited):
% Handle empty channels (eg. Ch1,2,4 used and 3 unused) data sets
% Increase the window size from default window size of plots
% Generate number of plots dependent on number of channels
% Read in multiple files
% -------------------------------------------------------------------

%% Clear the workspace 
clear all %#ok<CLSCR>
% Normally adding a sheet triggers a warning, so supress it, since this
% is what we want to happen
warning('off','MATLAB:xlswrite:AddSheet');
% clc

%% TO DO - incomplete: Give user dialog box of how-to or instructions
% All prompts are being replaced by a comprehensive GUI (in progress)
% Example time to read 4 channel 100k record file (30.6MB) - raw/num/text
howTitle = 'HOW-TO';
howText = 'Have UUT Serial Data ready (or just give a name to data).; Order excel files via name in same order as serial data entry. Reading the files may take time.';
uiwait(msgbox(howText,howTitle,'modal'));

%% Obtain file names, directories and UUT serial info

% Retrieve the number of files the user wants to process
prompt = 'Enter Number of Files to Process: ';
% Note: inputdlg() returns a cell but we want just a number
numFiles = str2num(cell2mat(inputdlg(prompt)));

%initialize
fName = '';
cdUp = 0;

% User wants to process multiple files
if (numFiles > 1)
    dirName = uigetdir('C:\','Select directory that data is located');
    curDir = pwd;
    addpath(dirName); %not really needed. Added just in case
    cd(dirName);
    if ~strcmp(pwd,curDir)
        cdUp = 1; %at the end of hte function, cd back up
    end
    
    %Get all the file names
    files = dir(fullfile(dirName,'*.csv'));% dir() returns a struct of files with name.date.bytes.isdir.datenum
    numDirFiles = numel(files);
    if numDirFiles ~= numFiles
        warning0 = sprintf('WARNING: User entered %i files ~= %i files available in directory.\nReading %i files.',...
            numFiles,numDirFiles,numFiles);
        uiwait(msgbox(warning0,'Warning','modal'));
    end
    
    % TO DO: Allocate Office summary output space based on numFiles
    % ~~~~~~~~~
    %
    
%     %sort alphabetically
%     %(dir sorts already but puts uppercase letters before lowercase)
%     fName = files.name; %temp grab of file names **DOES NOT WORK**
%     [~, fid] = sort(lower(fName)); %lower changes the array to lowercase so ignore the output
%     fName = fName(fid);
    
    %Get multiple serial numbers
    prompt = 'Enter space-separated UUT ID/Serial Numbers';
    userInput = inputdlg(prompt,'Data ID');
    serialInput = str2num(userInput{:}); %#ok<*ST2NM>
    %WARNING: User entered more/less serial numbers than numFiles which made
    %str2num fail and output NaN
    if (isnan(serialInput) | (numel(serialInput) ~= numFiles))
        warning1 = sprintf('WARNING: Serial Number(s) entered invalid. \n\t(e.g. # of Serial#s ~= # of Files)');
        uiwait(msgbox(warning1,'Warning','modal'));
        %Fix serialInput
        [m,n] = size(serialInput);
        if (n > numFiles) %remove extra serial numbers
            cols2remove = [numFiles+1:n];
            serialInput(:,cols2remove)=[];
        else %add in default values where there are missing values
            for i=1:numFiles
                if (i+n > numFiles)
                    break
                end
                serialInput(i+n) = i+n; %give a default numbering to the data
            end
        end
    end
    %WARNING: User entered identical serial numbers.
    if (length(unique(serialInput))<length(serialInput(:)))
        warning2 = sprintf('WARNING: Idendical serial #s entered. Extra/Missing entries auto-corrected.');
        uiwait(msgbox(warning2,'Warning','modal'));
    end
    

% User wants to process single file
elseif (numFiles == 1)
    % Get file name
    [fName,dirName] = uigetfile('*.csv','Select the scope-generated csv file');
    addpath(dirName);
    % ERROR: Invalid filename. Throw error and terminate.
    if (fName == 0) 
        error1 = sprintf('Error: Invalid File Selected.\nFile must be a csv.');
        error(error1); %#ok<*SPERR>
    end
    
    %Get one serial number
    prompt = 'Enter UUT ID#(i.e. Serial Number): ';
    userInput = inputdlg(prompt);
    serialInput = str2num(cell2mat(userInput));
    %WARNING: User entered more/less serial numbers than numFiles which made
    %str2num fail and output NaN
    if (isnan(serialInput) | (numel(serialInput) ~= numFiles))
        warning1 = sprintf('WARNING: Serial Number(s) entered invalid. \n\t(e.g. # of Serial#s ~= # of Files)');
        uiwait(msgbox(warning1,'Warning','modal'));
        %Fix serialInput
        serialInput = 1;
    end
    
% ERROR: User entered invalid numFiles; throw error and terminate
else
    error2 = sprintf('Error: Number of files invalid. Must be >= 1.');
    error(error2);
end

%% Use the retrieved CSV data

if (numFiles == 1)
    %Read file to workspace
    disp('Reading...');
    tic
    fOut = readCSVFile(fName);
    display(sprintf('Done reading csv file %s',fName));
    toc


    % Plot Figure(s) with subplot plots for each Channel
    disp('Plotting...');
    tic
    plotSingleCSV(fName, serialInput, false,fOut);
    display(sprintf('Done plotting csv file %s',fName));
    toc


    % Plot Figure(s) with subplot histograms for each Channel
    disp('Maing Histograms...');
    tic
    histSingleCSV(fName, serialInput, false,fOut);
    display(sprintf('Done making histogram of csv file %s',fName));
    toc

    % % Plot Figure(s) with subplot frequency spectrum plots for each Channel
    % disp('Plotting...');
    % tic
    % plotFSpec(fName, serialInput, false, fOut)
    % toc
    %display(sprintf('Done plotting frequency spectrum of csv file %s',fName));
elseif (numFiles > 1)
    tic
    for n=1:numFiles
        display(sprintf('Processing %s',files(n).name));
        %Read files to workspace
        fOut = readCSVFile(files(n).name);

        %Plot Figure(s) with subplot plots for each Channel
        plotSingleCSV(files(n).name, serialInput, false,fOut);

        %Plot Figure(s) with subplot histograms for each Channel
        histSingleCSV(files(n).name, serialInput, false,fOut);

%         % Plot Figure(s) with subplot frequency spectrum plots for each Channel
%         disp('Plotting...');
%         tic
%         plotFSpec(fName, serialInput, false, fOut)
%         toc
%         display(sprintf('Done plotting frequency spectrum of csv file %s',fName));
    end
        toc
end

%% change back to original directory
if cdUp == 1
    cd ../
end

end %END ScopeCSVReport (main function)



%% ------------------------------------------------------------------
% function readCSVFile description:
%
% Reads a single file and returns usable workspace data
% Read non-data contents and keep track of position where data starts 
% *To be completed*
%
% (fOut is a struct of the entire file)
% -------------------------------------------------------------------
function fOut = readCSVFile(fName)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Read file
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% hack to find where data starts
% strfind returns the index from which we find the data labels
%         returns empty array when not found
% bug: if string 'time' is in the header anywhere except where data
% starts then this will return the wrong index
fid = fopen(fName,'r');
dataInd = 15; %initialize to a value previously found in a scope output
for i=1:50
    line = fgets(fid);
    if line == -1 %reached end of file
        dataInd = i;
        break

    elseif strfind(lower(line),'time');
        dataInd = i;
        break
    end
end
% get struct with fOut.data/textdata/colheaders
fOut = importdata(fName,',',dataInd); 
%ALT: [num,txt,raw] = xlsread(fName);% importdata() is MUCH faster than xlsread()
%ALT: [~,~,raw] = xlsread(fName); this cut off ~2 seconds for a 100k for 4Chan

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Find data characteristics
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ***********Need to redo since xlsread replaced with importdata **********

fOut.numCh = (size(fOut.data,2)-1); %number of channels: one column each for X and Y of data

%split the single column header text back into columns
for j=1:dataInd-1 %iter rows; the last row is columns for data already
    temp_split = regexp(fOut.textdata(j),',','split'); % outputs cell
    size_tSplit = size(temp_split{:},2); %number of columns of data from row j
    temp_splitCols = mat2cell(vertcat(temp_split{:}), ...
        size(fOut.textdata(j),1),ones(1,size_tSplit));
    for k=1:fOut.numCh+1 % iter columns
        if (k > size_tSplit | size_tSplit < 1)
            break
        else
            %disp(temp_splitCols{k});
            fOut.textdata(j,k) = temp_splitCols{k};
        end
    end
end
%fOut.textdata(:) %debug text

chDatInd = 0;  labelInd = 0; %initialize
for i=1:dataInd
    if (strcmpi('Horizontal Units',fOut.textdata{i}))
        fOut.hUnits = fOut.textdata{i,2};
        fOut.hScale = fOut.textdata{i+1,2};
    elseif (strcmpi('Record Length',fOut.textdata{i}))
        fOut.dataLength = str2num(fOut.textdata{i,2});
    elseif (strcmpi('Gating',fOut.textdata{i}))
        chDatInd = i; %where chanel specific header info starts
    elseif (strcmpi('Label',fOut.textdata{i}))
        labelInd = i; %where chanel specific label is
    end
end

switch fOut.numCh
    case 4
        if ~isempty(fOut.textdata(labelInd,2)) 
                % Replace underscore with dash to prevent matlab interpreting as a subscript
                fOut.label1 = strrep(char(fOut.textdata{labelInd,2}),'_','-');
        else    fOut.label1 = 'Ch1'; % Default label to Channel number
        end
        if ~isempty(fOut.textdata(labelInd,3)) 
                fOut.label2 = strrep(char(fOut.textdata{labelInd,3}),'_','-');
        else    fOut.label2 = 'Ch2';
        end
        if ~isempty(fOut.textdata(labelInd,4)) 
                fOut.label3 = strrep(char(fOut.textdata{labelInd,4}),'_','-');
        else    fOut.label3 = 'Ch3';
        end
        if ~isempty(fOut.textdata(labelInd,5)) 
                fOut.label4 = strrep(char(fOut.textdata{labelInd,5}),'_','-');
        else    fOut.label4 = 'Ch4';
        end
    case 3
        if ~isempty(fOut.textdata(labelInd,2)) 
                fOut.label1 = strrep(char(fOut.textdata{labelInd,2}),'_','-');
        else    fOut.label1 = 'Ch1';
        end
        if ~isempty(fOut.textdata(labelInd,3)) 
                fOut.label2 = strrep(char(fOut.textdata{labelInd,3}),'_','-');
        else    fOut.label2 = 'Ch2';
        end
        if ~isempty(fOut.textdata(labelInd,4)) 
                fOut.label3 = strrep(char(fOut.textdata{labelInd,4}),'_','-');
        else    fOut.label3 = 'Ch3';
        end
    case 2
        if ~isempty(fOut.textdata(labelInd,2)) 
                fOut.label1 = strrep(char(fOut.textdata{labelInd,2}),'_','-');
        else    fOut.label1 = 'Ch1';
        end
        if ~isempty(fOut.textdata(labelInd,3)) 
                fOut.label2 = strrep(char(fOut.textdata{labelInd,3}),'_','-');
        else    fOut.label2 = 'Ch2';
        end
    case 1
        if ~isempty(fOut.textdata(labelInd,2)) 
                fOut.label1 = strrep(char(fOut.textdata{labelInd,2}),'_','-');
        else    fOut.label1 = 'Ch1';
        end
    otherwise
        error3 = sprintf('Error: Number of Channels not within 1:4');
        error(error3);
end

% fOut.textdata(labelInd,:) debug text

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Find data
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
switch fOut.numCh
    case 4
        fOut.Ch1Dat = fOut.data(1:end,[1,2]);
        fOut.Ch2Dat = fOut.data(1:end,[1,3]);
        fOut.Ch3Dat = fOut.data(1:end,[1,4]);
        fOut.Ch4Dat = fOut.data(1:end,[1,5]);
    case 3
        fOut.Ch1Dat = fOut.data(1:end,[1,2]);
        fOut.Ch2Dat = fOut.data(1:end,[1,3]);
        fOut.Ch3Dat = fOut.data(1:end,[1,4]);
    case 2
        fOut.Ch1Dat = fOut.data(1:end,[1,2]);
        fOut.Ch2Dat = fOut.data(1:end,[1,3]);
    case 1
        fOut.Ch1Dat = fOut.data(1:end,[1,2]);
    otherwise
        error3 = sprintf('Error: Number of Channels not within 1:4');
        error(error3);
end

%OLD CODE
% hDelay = cell2mat(raw(hInd+2,2));
% sampleInterval = cell2mat(raw(hInd+3,2));
% dataLength = cell2mat(raw(hInd+4,2));
% display(sprintf('Done grabbing header data for %s',fName));
% 
% Get Channel dependent info
% chAtten = cell2mat(raw(chDatInd+1,2:fOut.numCh+1));
% chVUnits = raw(chDatInd+2,2:fOut.numCh+1);
% chVOffset = cell2mat(raw(chDatInd+3,2:fOut.numCh+1));
% chVScale = cell2mat(raw(chDatInd+4,2:fOut.numCh+1));
% chLabel = raw(chDatInd+5,2:fOut.numCh+1);

end %END readCSVFile()


%% ------------------------------------------------------------------
% function plotSingleCSV description:
%
% *To be done*
%
% -------------------------------------------------------------------
function plotSingleCSV(fName, serialInput, inkSaverBool, fOut)

% Setup Figure
scrsz = get(groot,'ScreenSize'); % get screen size
if fOut.numCh < 3 %numCh 1 or 2, so make window bigger
    fig = figure('position', ... %take most of left side of screen
        [100 40 scrsz(3)/2 (scrsz(4)/4*fOut.numCh)], ... 
        'name',sprintf('Plot of %s (s/n: %d)',fName, serialInput)); %Window title
else %numCh 3+, so make window full height
    fig = figure('position', ... %take most of left side of screen
        [100 40 scrsz(3)/2 (scrsz(4)/4*fOut.numCh)-150], ... 
        'name',sprintf('Plot of %s (s/n: %d)',fName, serialInput)); %Window title
end
chCol = ['k' 'c' 'm' 'g' 'w']; %line colors: black, cyan, magenta, green
if (inkSaverBool ~= true) 
    whitebg(fig); %toggle figure bg from white to black/grey
    chCol(1) = 'y'; %change Ch1 from black to yellow #BlackAndYellow
end

% Plot
% TO DO: NEEDS LABELS AND CONTEXT INFO
hold on;
zero = zeros(1,double(fOut.dataLength));
switch fOut.numCh
    case 4
        subplot(fOut.numCh,1,1);
        plot(fOut.Ch1Dat(:,1),fOut.Ch1Dat(:,2),chCol(1));
        hold on;
        plot(fOut.Ch1Dat(:,1),zero,'LineStyle',':','Color',chCol(5));
        legend(fOut.label1);
        xlim([fOut.Ch1Dat(1,1) fOut.Ch1Dat(fOut.dataLength-1,1)]);
        %line([0 0],ylim,'LineStyle',':','Color',chCol(5));
        grid on;

        subplot(fOut.numCh,1,2);
        plot(fOut.Ch2Dat(:,1),fOut.Ch2Dat(:,2),chCol(2));
        hold on;
        plot(fOut.Ch2Dat(:,1),zero,'LineStyle',':','Color',chCol(5));
        legend(fOut.label2);
        xlim([fOut.Ch2Dat(1,1) fOut.Ch2Dat(fOut.dataLength-1,1)]);
        %line([0 0],ylim,'LineStyle',':','Color',chCol(5));
        grid on;

        subplot(fOut.numCh,1,3);
        plot(fOut.Ch3Dat(:,1),fOut.Ch3Dat(:,2),chCol(3));
        hold on;
        plot(fOut.Ch3Dat(:,1),zero,'LineStyle',':','Color',chCol(5));
        legend(fOut.label3);
        xlim([fOut.Ch3Dat(1,1) fOut.Ch3Dat(fOut.dataLength-1,1)]);
        %line([0 0],ylim,'LineStyle',':','Color',chCol(5));
        grid on;

        subplot(fOut.numCh,1,4);
        plot(fOut.Ch4Dat(:,1),fOut.Ch4Dat(:,2),chCol(4));
        hold on;
        plot(fOut.Ch4Dat(:,1),zero,'LineStyle',':','Color',chCol(5));
        legend(fOut.label4);
        xlim([fOut.Ch4Dat(1,1) fOut.Ch4Dat(fOut.dataLength-1,1)]);
        %line([0 0],ylim,'LineStyle',':','Color',chCol(5));
        grid on;

    case 3
        subplot(fOut.numCh,1,1);
        plot(fOut.Ch1Dat(:,1),fOut.Ch1Dat(:,2),chCol(1));
        hold on;
        plot(fOut.Ch1Dat(:,1),zero,'LineStyle',':','Color',chCol(5));
        legend(fOut.label1);
        xlim([fOut.Ch1Dat(1,1) fOut.Ch1Dat(fOut.dataLength-1,1)]);
        %line([0 0],ylim,'LineStyle',':','Color',chCol(5));
        grid on;

        subplot(fOut.numCh,1,2);
        plot(fOut.Ch2Dat(:,1),fOut.Ch2Dat(:,2),chCol(2));
        hold on;
        plot(fOut.Ch2Dat(:,1),zero,'LineStyle',':','Color',chCol(5));
        legend(fOut.label2);
        xlim([fOut.Ch2Dat(1,1) fOut.Ch2Dat(fOut.dataLength-1,1)]);
        %line([0 0],ylim,'LineStyle',':','Color',chCol(5));
        grid on;

        subplot(fOut.numCh,1,3);
        plot(fOut.Ch3Dat(:,1),fOut.Ch3Dat(:,2),chCol(3));
        hold on;
        plot(fOut.Ch3Dat(:,1),zero,'LineStyle',':','Color',chCol(5));
        legend(fOut.label3);
        xlim([fOut.Ch3Dat(1,1) fOut.Ch3Dat(fOut.dataLength-1,1)]);
        %line([0 0],ylim,'LineStyle',':','Color',chCol(5));
        grid on;

    case 2
        subplot(fOut.numCh,1,1);
        plot(fOut.Ch1Dat(:,1),fOut.Ch1Dat(:,2),chCol(1));
        hold on;
        plot(fOut.Ch1Dat(:,1),zero,'LineStyle',':','Color',chCol(5));
        legend(fOut.label1);
        xlim([fOut.Ch1Dat(1,1) fOut.Ch1Dat(fOut.dataLength-1,1)]);
        %line([0 0],ylim,'LineStyle',':','Color',chCol(5));
        grid on;

        subplot(fOut.numCh,1,2);
        plot(fOut.Ch2Dat(:,1),fOut.Ch2Dat(:,2),chCol(2));
        hold on;
        plot(fOut.Ch2Dat(:,1),zero,'LineStyle',':','Color',chCol(5));
        legend(fOut.label2);
        xlim([fOut.Ch2Dat(1,1) fOut.Ch2Dat(fOut.dataLength-1,1)]);
        %line([0 0],ylim,'LineStyle',':','Color',chCol(5));
        grid on;

    case 1
        plot(fOut.Ch1Dat(:,1),fOut.Ch1Dat(:,2),chCol(1));
        hold on;
        plot(fOut.Ch1Dat(:,1),zero,'LineStyle',':','Color',chCol(5));
        legend(fOut.label1);
        xlim([fOut.Ch1Dat(1,1) fOut.Ch1Dat(fOut.dataLength-1,1)]);
        %line([0 0],ylim,'LineStyle',':','Color',chCol(5));
        grid on;

    otherwise
        error3 = sprintf('Error: Number of Channels not within 1:4');
        error(error3);
end

xlabel(sprintf('Time(%s)',lower(fOut.hUnits)));

end %END plotSingleCSV()


%% ------------------------------------------------------------------
% function histSingleCSV description:
%
% *To be done*
%
% -------------------------------------------------------------------
function histSingleCSV(fName, serialInput, inkSaverBool, fOut)

% Setup Figure
fig = figure('name',sprintf('Histogram of %s (s/n: %d)',fName, serialInput)); %Window title
% TODO: Resize histogram to right side of screen. This is left side stuff:
% scrsz = get(groot,'ScreenSize'); % get screen size
% if fOut.numCh < 3 %numCh 1 or 2, so make window bigger
%     fig = figure('position', ... %take most of left side of screen
%         [100 40 scrsz(3)/2 (scrsz(4)/4*fOut.numCh)], ... 
%         'name',sprintf('Histogram of %s (s/n: %d)',fName, serialInput)); %Window title
% else %numCh 3+, so make window full height
%     fig = figure('position', ... %take most of left side of screen
%         [100 40 scrsz(3)/2 (scrsz(4)/4*fOut.numCh)-150], ... 
%         'name',sprintf('Histogram of %s (s/n: %d)',fName, serialInput)); %Window title
% end

% chCol = ['k' 'c' 'm' 'g' 'w']; %line colors: black, cyan, magenta, green
if (inkSaverBool ~= true) 
    whitebg(fig); %toggle figure bg from white to black/grey
%     chCol(1) = 'y'; %change Ch1 from black to yellow #BlackAndYellow
end


% Histogram
% NEEDS LABELS AND CONTEXT INFO
hold on;
switch fOut.numCh
    case 4
        subplot(fOut.numCh,1,1);
        histogram(fOut.Ch1Dat(:,2));

        subplot(fOut.numCh,1,2);
        histogram(fOut.Ch2Dat(:,2));

        subplot(fOut.numCh,1,3);
        histogram(fOut.Ch3Dat(:,2));

        subplot(fOut.numCh,1,4);
        histogram(fOut.Ch4Dat(:,2));

    case 3
        subplot(fOut.numCh,1,1);
        histogram(fOut.Ch1Dat(:,2));

        subplot(fOut.numCh,1,2);
        histogram(fOut.Ch2Dat(:,2));

        subplot(fOut.numCh,1,3);
        histogram(fOut.Ch3Dat(:,2));
    
    case 2
        subplot(fOut.numCh,1,1);
        histogram(fOut.Ch1Dat(:,2));

        subplot(fOut.numCh,1,2);
        histogram(fOut.Ch2Dat(:,2));
        
    case 1
        subplot(fOut.numCh,1,1);
        histogram(fOut.Ch1Dat(:,2));
        
    otherwise
        error3 = sprintf('Error: Number of Channels not within 1:4');
        error(error3);
end

% TODO: MAKE THIS UNIVERSAL
xlabel('Voltage');
ylabel('n');

end %END histSingleCSV()


%% ------------------------------------------------------------------
% function plotFSpec description:
% INCOMPLETE FUNCTION...DOES NOT WORK YET
% *To be done*
%
% -------------------------------------------------------------------
function plotFSpec(fName, serialInput, inkSaverBool, fOut)

%Setup Figure
scrsz = get(groot,'ScreenSize'); % get screen size
if fOut.numCh < 3 %numCh 1 or 2, so make window bigger
    fig = figure('position', ... %take most of left side of screen
        [100 40 scrsz(3)/2 (scrsz(4)/4*fOut.numCh)], ... 
        'name',sprintf('Plot of %s (s/n: %d)',fName, serialInput)); %Window title
else %numCh 3+, so make window full height
    fig = figure('position', ... %take most of left side of screen
        [100 40 scrsz(3)/2 (scrsz(4)/4*fOut.numCh)-150], ... 
        'name',sprintf('Plot of %s (s/n: %d)',fName, serialInput)); %Window title
end
chCol = ['k' 'c' 'm' 'g']; %line colors: black, cyan, magenta, green
if (inkSaverBool ~= true) 
    whitebg(fig); %toggle figure bg from white to black/grey
    chCol(1) = 'y'; %change Ch1 from black to yellow #BlackAndYellow
end

% FFT
Fs = 1e9; %assume bandwidth of scope is 500Mhz, therefore nyquist is 1G
T = 1/Fs;
L = fOut.dataLength;
t = (0:L-1)*T;


% switch fOut.numCh
%     case 4
        Y1 = fft(fOut.Ch1Dat);
        Y1P2 = abs(Y1/L); %two-sided spectrum
        Y1P1 = Y1P2(1:L/2+1); %single-sided spectrum
        Y1P1(2:end-1) = 2*Y1P1(2:end-1);
        f1 = Fs*(0:(L/2))/L;
        plot(f,Y1P1);


xlabel('f(Hz)');

end %END plotFSpec()