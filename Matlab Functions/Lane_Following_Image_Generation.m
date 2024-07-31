framenum = 115; 

lanesignal = 1;

FrontCam = read(VideoReader("/Users/khushl/Downloads/imagedataone.mp4"), framenum);
LeftCam = read(VideoReader("/Users/khushl/Downloads/imagedataleftone.mp4"), framenum);
RightCam = read(VideoReader("/Users/khushl/Downloads/imagedatarightone.mp4"), framenum);
speed = 0.2;
Right = RightCam;
figure;
subplot(1, 3, 1);
imshow(LeftCam);
title('Original Left Camera Image');

subplot(1, 3, 2);
imshow(RightCam);
title('Original Right Camera Image');

subplot(1, 3, 3);
imshow(FrontCam);
title('Original Front Camera Image');
monoCams = cell(3, 1);

if FrontCam(1, 1, 1) == 0 && FrontCam(1, 1, 2) == 0 && FrontCam(1, 1, 3) == 0 || LeftCam(1, 1, 1) == 0 && LeftCam(1, 1, 2) == 0 && LeftCam(1, 1, 3) == 0 || RightCam(1, 1, 1) == 0 && RightCam(1, 1, 2) == 0 && RightCam(1, 1, 3) == 0
    steeringAngle = 0.2;
    return;
end

FrontCam = FrontCam(1:10:480, 1:10:640, :);
LeftCam = LeftCam(1:10:480, 1:10:640, :);
RightCam = RightCam(1:10:480, 1:10:640, :);

height = 85;
yaw = 0;
pitch = 0;
roll = 0;

% Plot Resized Side Images
figure;
subplot(1, 3, 1);
imshow(LeftCam);
title('Resized Left Camera Image');
 
subplot(1, 3, 2);
imshow(RightCam);
title('Resized Right Camera Image');
 
subplot(1, 3, 3);
imshow(FrontCam);
title('Resized Front Camera Image');


monoCams{1} = monoCamera(cameraIntrinsics([74.436956267387340,73.961386855604320],[32.280149907106400,25.661409210179094],[48,64]), height, ...
                             "Pitch", pitch, ...
                             "Yaw"  , yaw, ...
                             "Roll" , roll, ...
                             "SensorLocation", [0, 0],"WorldUnits", "millimeters");



frontBevImgs  = transformImage(birdsEyeView(monoCams{1}, [200, 700, -250, 250], [64, NaN]), undistortImage(FrontCam, monoCams{1}.Intrinsics));

%Plot Birdseye  Images

figure;
imshow(frontBevImgs);
title('Birds-eye Front Camera Image');

FrontCam = frontBevImgs;

if speed == 0
    steeringAngle = 0;
    return;
end

%Define thresholds for channel 1 based on histogram settings
channel1Min = 80.000;
channel1Max = 255.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 80.000;
channel2Max = 255.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 80.000;
channel3Max = 255.000;

% Front camera bw
sliderBWFront = (FrontCam(:,:,1) >= channel1Min ) & (FrontCam(:,:,1) <= channel1Max) & ...
           (FrontCam(:,:,2) >= channel2Min ) & (FrontCam(:,:,2) <= channel2Max) & ...
           (FrontCam(:,:,3) >= channel3Min ) & (FrontCam(:,:,3) <= channel3Max);
BWFront = sliderBWFront;

BWFront = BWFront(end:-1:1, :);  % Flip the image vertically


%left camera bw
sliderBWLeft = (LeftCam(:,:,1) >= channel1Min ) & (LeftCam(:,:,1) <= channel1Max) & ...
           (LeftCam(:,:,2) >= channel2Min ) & (LeftCam(:,:,2) <= channel2Max) & ...
           (LeftCam(:,:,3) >= channel3Min ) & (LeftCam(:,:,3) <= channel3Max);
BWLeft = sliderBWLeft;

BWLeft = BWLeft(end:-1:1, :);  % Flip the image vertically


%right camera bw
sliderBWRight = (RightCam(:,:,1) >= channel1Min ) & (RightCam(:,:,1) <= channel1Max) & ...
           (RightCam(:,:,2) >= channel2Min ) & (RightCam(:,:,2) <= channel2Max) & ...
           (RightCam(:,:,3) >= channel3Min ) & (RightCam(:,:,3) <= channel3Max);
BWRight = sliderBWRight;

BWRight = BWRight(end:-1:1, :);  % Flip the image vertically
% subsampling

% %Plot Binary Side Images
figure;
subplot(1, 3, 1);
imshow(BWLeft(end:-1:1, :));
title('Binary Left Camera Image');
% % 
subplot(1, 3, 2);
imshow(BWRight(end:-1:1, :));
title('Binary Right Camera Image');
subplot(1, 3, 3);
imshow(BWFront(end:-1:1, :));
title('Binary Front Camera Image');

binnedFront = zeros(32, 32);

for frontbinidx = 1:2:64
    for frontbinYidx = 1:2:64
        binnedFront(round(frontbinidx/2 + 0.5), round(frontbinYidx/2 + 0.5)) = max(BWFront(frontbinidx:frontbinidx+1, frontbinYidx:frontbinYidx+1), [], "all");
    end
end

binnedLeft = zeros(24, 32);

for leftbinidx = 1:2:48
    for leftbinYidx = 1:2:64
        binnedLeft(round(leftbinidx/2 + 0.5), round(leftbinYidx/2 + 0.5)) = max(BWLeft(leftbinidx:leftbinidx+1, leftbinYidx:leftbinYidx+1), [], "all");
    end
end

binnedRight = zeros(24, 32);

for rightbinidx = 1:2:48
    for rightbinYidx = 1:2:64
        binnedRight(round(rightbinidx/2 + 0.5), round(rightbinYidx/2 + 0.5)) = max(BWRight(rightbinidx:rightbinidx+1, rightbinYidx:rightbinYidx+1), [], "all");
    end
end

 
% Plot Binned Images
figure;
subplot(1, 3, 1);
imshow(binnedLeft(end:-1:1, :));
title('Binned Left Camera Image');

subplot(1, 3, 2);
imshow(binnedRight(end:-1:1, :));
title('Binned Right Camera Image');

subplot(1, 3, 3);
imshow(binnedFront(end:-1:1, :));
title('Binned Front Camera Image');

% Conversion factor
mm_per_pixel = 2.08;

% Convert all coordinates from pixels to millimeters
% For Right Camera
[rows, cols] = find(binnedRight);
RightCoordinates = [cols, rows] * mm_per_pixel;

% For Left Camera
[rows, cols] = find(binnedLeft);
LeftCoordinates = [cols, rows] * mm_per_pixel;

offsetv=0;
% Right Camera Polyfit
right_sorted_coords = sortrows(RightCoordinates, 1);
[right_unique_x, ~, idx] = unique(right_sorted_coords(:, 1));

rightResult = zeros(length(right_unique_x), 2);
for i = 1:length(right_unique_x)
    right_current_x_idx = (right_sorted_coords(:, 1) == right_unique_x(i));
    right_min_y = min(right_sorted_coords(right_current_x_idx, 2));
    rightResult(i, :) = [right_unique_x(i), right_min_y];
end

pRight = polyfit(rightResult(:, 1), rightResult(:, 2), 3);
right_lowest_y = min(rightResult(:, 2));
right_offset_y = right_lowest_y; % Offset by adding the lowest y-value
if right_offset_y < 10
    offsetv = 1/right_offset_y;
end

% Left Camera Polyfit
left_sorted_coords = sortrows(LeftCoordinates, 1);
[left_unique_x, ~, idx] = unique(left_sorted_coords(:, 1));

leftResult = zeros(length(left_unique_x), 2);
for i = 1:length(left_unique_x)
    left_current_x_idx = (left_sorted_coords(:, 1) == left_unique_x(i));
    left_min_y = min(left_sorted_coords(left_current_x_idx, 2));
    leftResult(i, :) = [left_unique_x(i), left_min_y];
end

pLeft = polyfit(leftResult(:, 1), leftResult(:, 2), 3);
left_lowest_y = min(leftResult(:, 2));
left_offset_y = left_lowest_y; % Offset by adding the lowest y-value
if left_offset_y < 10
    offsetv = -1/left_offset_y;
end
% Front Camera Polyfit and Transformation
% For Front Camera
[rows, cols] = find(binnedFront);
FrontCoordinates = [cols, rows];
epsilon = 2;
minPts = 4;
minClusterSize = 20;
maxClusterSize = 100;
FrontClusters = dbscan(FrontCoordinates, epsilon, minPts);
FrontUniqueClusters = unique(FrontClusters);
FrontClusterSizes = histcounts(FrontClusters, [FrontUniqueClusters; max(FrontUniqueClusters)+1]);
FrontmaxYRange = 0;
FrontBestClusterIdx = -1;

% Plot all clusters
figure;
hold on;
numClusters = length(FrontUniqueClusters);
colors = hsv(numClusters); % Generate a set of vibrant colors
for iFront = 1:numClusters
    FrontClusterIdx = (FrontClusters == FrontUniqueClusters(iFront));
    if FrontUniqueClusters(iFront) == -1
        clusterColor = [0, 0, 0]; % Black for noise points
    else
        clusterColor = colors(iFront, :);
    end
    FrontClusterCoords = FrontCoordinates(FrontClusterIdx, :);
    scatter(FrontClusterCoords(:, 1), FrontClusterCoords(:, 2), 10, 'MarkerEdgeColor', clusterColor, 'MarkerFaceColor', clusterColor);
    if FrontClusterSizes(iFront) >= minClusterSize && FrontClusterSizes(iFront) <= maxClusterSize
        FrontYRange = max(FrontClusterCoords(:, 2)) - min(FrontClusterCoords(:, 2));
        if FrontYRange > FrontmaxYRange
            FrontmaxYRange = FrontYRange;
            FrontBestClusterIdx = double(FrontUniqueClusters(iFront));
        end
    end
end
%title('DBSCAN Clusters for Front Camera');
xlabel('X Coordinate');
ylabel('Y Coordinate');
hold off;

if FrontBestClusterIdx ~= -1
    FrontClusterIdx = (FrontClusters == FrontBestClusterIdx);
    FrontbestClusterCoords = FrontCoordinates(FrontClusterIdx, :);
    FrontTheta = 90;
    FrontR = [cosd(FrontTheta) -sind(FrontTheta); sind(FrontTheta) cosd(FrontTheta)];
    newFrontCoords = FrontbestClusterCoords * FrontR;
    newFrontCoords(:, 2) = newFrontCoords(:, 2) + 16;
    purePurs = polyfit(newFrontCoords(:, 1), newFrontCoords(:, 2), 3);
    newFrontCoords = newFrontCoords * mm_per_pixel;
    pFront = polyfit(newFrontCoords(:, 1), newFrontCoords(:, 2), 3);
    frontOffset = polyval(pFront, 0);
else
    steeringAngle = 0;
    error('No suitable front camera cluster found');
end


% Transformations
% Front Camera: Move 215 mm forward
newFrontCoords(:, 1) = newFrontCoords(:, 1) + 215;

% Left Camera: Move 75 mm up and 185 mm forward
leftResult(:, 2) = leftResult(:, 2) +75+173;
leftResult(:, 2) = leftResult(:, 2);
leftResult(:, 1) = leftResult(:, 1) + 30-85+48;

% Right Camera: Move 75 mm down and 185 mm forward
rightResult(:, 2) = rightResult(:, 2) *-1;
rightResult(:, 2) = rightResult(:, 2) -75-173;
%+173
rightResult(:, 1) = rightResult(:, 1) + 30-85+48;
pRight = polyfit(rightResult(:, 1), rightResult(:, 2), 3);
pLeft = polyfit(leftResult(:, 1), leftResult(:, 2), 3);
pFront = polyfit(newFrontCoords(:, 1), newFrontCoords(:, 2), 3);
lane_size = min(leftResult(:, 2)) - max(rightResult(:, 2));
% Steering Calculation
currentPos = [215, 0];
lookVal = 250;
left_y = polyval(pLeft, lookVal);
right_y = polyval(pRight, lookVal);
front_y = polyval(pFront, lookVal);

dx = lookVal - currentPos(1);
dy = front_y - currentPos(2);
dx=20;
dy=polyval(purePurs, 20);
Lfw = sqrt(dx^2 + dy^2);
mu = atan(dy / dx);
R = Lfw / (2 * sin(mu));
arcLength = 2 * mu * R;
speed = 1;  % Assuming speed is given in mm/s for simplicity
time = arcLength / speed;
steeringAngle = (2 * mu) / time;
steeringAngle = steeringAngle * 38.5;
steeringAngle = steeringAngle + offsetv;

figure;
hold on;

% Plot the lines for the right camera
right_x_range = linspace(min(rightResult(:, 1)), max(rightResult(:, 1)), 100);
right_y_fit = polyval(pRight, right_x_range);
plot(right_x_range, right_y_fit, '-r', 'LineWidth', 2, 'DisplayName', 'Right Camera Fit');

% Plot the lines for the left camera
left_x_range = linspace(min(leftResult(:, 1)), max(leftResult(:, 1)), 100);
left_y_fit = polyval(pLeft, left_x_range);
plot(left_x_range, left_y_fit, '-b', 'LineWidth', 2, 'DisplayName', 'Left Camera Fit');

% Plot the lines for the front camera
front_x_range = linspace(min(newFrontCoords(:, 1)), max(newFrontCoords(:, 1)), 100);
front_y_fit = polyval(pFront, front_x_range);
plot(front_x_range, front_y_fit, '-g', 'LineWidth', 2, 'DisplayName', 'Front Camera Fit');

% Add the rectangle in black
% Add legend without including the rectangle
% Add legend manually
legend({'Right Camera Fit', 'Left Camera Fit', 'Front Camera Fit'}, 'Location', 'best');
title('Lane Lines From All Three Cameras');
xlabel('X (mm)');
ylabel('Y (mm)');
axis tight;
hold off;
