function convertAFolder()
%CONVERTAFOLDER reads all files of the selected folder and writes the
%converted data into a single file.

folderName = uigetdir('C:/');
if(ischar(folderName))
    [outputFileName, outputPathName] = uiputfile('*.csv', 'Save As');
    if(ischar(outputFileName))
        outputFile = fopen([outputPathName, outputFileName], 'a');
        if(~ischar(outputFileName))
            return;
        end
        fprintf(outputFile, 'seqn,paxstat,paxcal,paxday,paxn,paxhour,paxhour_rel,paxminut,paxinten,paxinten_ax1,paxinten_ax2,paxinten_ax3,paxstep\n');
        h = waitbar(0, 'Converting...');
        pause(1);
        fileNames = dir([folderName, '/*.csv']);
        numberOfFiles = size(fileNames, 1);
        for i = 1:numberOfFiles
            inputFileName = fileNames(i).name;
            waitbar(i/numberOfFiles, h, sprintf('%s (%.2f)', inputFileName, (i/numberOfFiles * 100.00)));
            convertASignleFile_dataset([folderName, '/', inputFileName], outputFile);
        end
        waitbar(1, h, 'Converting completed...');
        pause(1);
        close(h);
    end
end

end

