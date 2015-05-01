function convertASignleFile_dataset(inputFileName, outputFile)
%CONVERTASINGLEFILE_dataset reads a raw data file of LIFE format and converts it
%into NHANES format.
%Reads the input file, and appends its converted form to the given
%outputfile.

%% Initializing variables.
ds = dataset('FILE', inputFileName, 'Delimiter', ',');
seqn = ds.pid(1);
paxstat = 1; % reliable.
paxcal = 1; % calibrated.
paxday = weekday(ds.startDt(1)); % Day of the week
paxn = 1; % number of minutes in total;
timeTokens = strsplit(ds.starttime{1}, ':');
paxhour = str2double(timeTokens{1}); % hour of the day
paxminut = str2double(timeTokens{2}); % minute
sec = str2double(timeTokens{3}); % second
paxstep = 0; % sum of steps for each minute.

%% Reading input file as dataset and selecting required columns
try
axis1_col = ds.axis1;
axis2_col = ds.axis2;
axis3_col = ds.axis3;
steps_col = ds.steps;
sortorder = ds.sortorder;
clear ds;

%% Sorting the data according to "sortorder"
[~, sortedIdx] = sort(sortorder, 'ascend');
axis1_col = axis1_col(sortedIdx);
axis2_col = axis2_col(sortedIdx);
axis3_col = axis3_col(sortedIdx);

%% Reading input file and appending the consumed information to the output file
hour = 0; % relative hour
axis1 = 0;
axis2 = 0;
axis3 = 0;
for i = 1:size(axis1_col, 1)
    
    axis1 = axis1 + axis1_col(i);
    axis2 = axis2 + axis2_col(i);
    axis3 = axis3 + axis3_col(i);
    paxstep = paxstep + steps_col(i);
    sec = sec + 1;
    if(sec >= 60) 
        paxinten = sqrt(axis1^2 + axis2^2 + axis3^2); % Vector Magnitude for each minute.
        fprintf(outputFile, '%d,%d,%d,%d,%d,%d,%d,%d,%f,%d,%d,%d,%d\n', seqn, paxstat, paxcal, paxday, paxn, paxhour, hour, paxminut, paxinten, axis1, axis2, axis3, paxstep);
        paxn = paxn + 1;
        paxminut = paxminut + 1;
        if(paxminut >= 60)
            paxminut = 0;
            paxhour = paxhour + 1;
            hour = hour + 1; %Relative hour does not need to reset
            if(paxhour >= 24)
                paxhour = 0;
                paxday = paxday + 1;
                if(paxday > 7)
                    paxday = 1;
                end
            end
        end
        % Everything resets
        axis1 = 0;
        axis2 = 0;
        axis3 = 0;
        paxstep = 0;
        sec = 0;
    end
end

catch exception
    fprintf('An error occured while reading %s file... !!!\n%s\n', inputFileName, exception.message);
end

end

