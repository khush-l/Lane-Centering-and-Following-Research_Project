videoFilePath = '/Users/khushl/Downloads/imagedataleft1.mp4'; 
outputFolderPath = '/Users/khushl/Downloads/imleft'; 

extractFrames(videoFilePath, outputFolderPath);
function extractFrames(videoFilePath, outputFolderPath)
    % Create a VideoReader object to read the video
    videoObj = VideoReader(videoFilePath);

    frameIndex = 1;
    frameCount = 1;

    while hasFrame(videoObj)
        % Read the next frame
        frame = readFrame(videoObj);

        % Save every 2nd frame
        if mod(frameCount, 2) == 0
            % Create the filename
            frame = frame(1:10:end, 1:10:end, :);
            frameFileName = sprintf('frame_%04d.png', frameIndex);
            frameFilePath = fullfile(outputFolderPath, frameFileName);

            % Write the frame to file
            imwrite(frame, frameFilePath);

            % Increment frame index
            frameIndex = frameIndex + 1;
        end

        % Increment the frame count
        frameCount = frameCount + 1;
    end

    disp('Frame extraction complete.');
end
