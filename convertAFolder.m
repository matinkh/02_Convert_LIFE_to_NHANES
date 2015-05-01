function convertAFolder(folderName, outputFileName)
%CONVERTAFOLDER reads all files of the selected folder and writes the
%converted data into a single file.

if(ischar(folderName))
    if(ischar(outputFileName))
        outputFile = fopen(outputFileName, 'w');
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
        fclose(outputFile);
        pause(1);
        close(h);
    end
end

end

