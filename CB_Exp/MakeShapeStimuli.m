%% Initilization
clear;format compact;clc;
ptb_cleanup;sca;clc;sca;clc;
% close cleanup PTB on clean up
magic_cleanup = onCleanup(@ptb_cleanup);

% initialize ptb and open a window
skipSync = 1;
visualDebug = 0;
hCursor = 1;
debugMode = 0; % set the debug mode

[w,wRect,ifi] = ptb_init(skipSync,visualDebug,hCursor,debugMode);
x = wRect(3);
y = wRect(4);

chRectPctInc = .05; %.05= 5 ; make it 5 percent large in all direction

fileListImg=dir(['Stimuli_img' filesep '*.jpg']);

files = length(fileListImg)/2;

As = 2*(1:files)-1;
Bs = 2*(1:files);

for j=1:files
    
    pathA = ['Stimuli_img' filesep fileListImg(As(j)).name];
    pathB = ['Stimuli_img' filesep fileListImg(Bs(j)).name];
    
    % Define the file names for the two pictures we will be alternating
    % between
    
    % Now load the images
    theImageA = imread(pathA);
    theImageB = imread(pathB);
    
    [s1, s2, s3] = size(theImageA);
    
    aspectRatio = s2 / s1;
    theRect = CenterRectOnPointd([0 0 y*aspectRatio y],x/2,y/2);
    
    chImg = sum(abs(theImageA-theImageB),3);
    [yPx, xPx] = find(chImg~=0);
    rectCh = [min(xPx) min(yPx) max(xPx) max(yPx)]./...
        [s2 s1 s2 s1].*...
        [y*aspectRatio y y*aspectRatio y]+[theRect(1) 0 theRect(1) 0].*...
        (ones(1,4)+[-1 -1 1 1]*chRectPctInc);%increase target area
    
    avgRect =[0 0 abs(rectCh(1)-rectCh(3)) abs(rectCh(2)-rectCh(4))];
    
    % Screen X positions of our three rectangles
    numShapes = 60;
    shapeXpos = [round(rand(numShapes,1)*x); mean([rectCh(1) rectCh(3)])];
    shapeYpos = [round(rand(numShapes,1)*y); mean([rectCh(2) rectCh(4)])];
    
    % Set the colors to Red, Green and Blue
    
    allColors = rand(numShapes,3).*255;
    [B I] = sort(rand(1,numShapes));
    
    allColorsA = [allColors;rand(1,3).*255];
    allColorsB = [allColors;rand(1,3).*255];
    
    
    % Make our rectangle coordinates
    
    allSides = 3:8; %6
    allSides = repmat(allSides,1,numShapes/length(allSides));
    
    targSideA = 4+round(rand());
    temp = rand();
    targSideB = targSideA + ((temp>=.5)*-1) + (temp<.5);
    
    allSidesA = [allSides(I) targSideA];
    
    allSidesB = [allSides(I) targSideB];
    
    allSizeAdjs = [(rand(numShapes,1).*1.5+.5);1];
    
    for i = 1:numShapes+1
        
        numSides = allSidesA(i);
        
        % Angles at which our polygon vertices endpoints will be. We start at zero
        % and then equally space vertex endpoints around the edge of a circle. The
        % polygon is then defined by sequentially joining these end points.
        anglesDeg = linspace(0, 360, numSides + 1);
        anglesRad = anglesDeg * (pi / 180);
        
        %         radiusX = avgRect(3)*allSizeAdjs(i);
        %         radiusY = avgRect(4)*allSizeAdjs(i);
        radius = (mean(avgRect(3:4))./3)*allSizeAdjs(i);
        
        % X and Y coordinates of the points defining out polygon, centred on the
        % centre of the screen
        yPosVector = sin(anglesRad) .* radius + shapeYpos(i);
        xPosVector = cos(anglesRad) .* radius + shapeXpos(i);
        
        % Set the color of the rect
        rectColor = allColorsA(i,:);
        
        % Cue to tell PTB that the polygon is convex (concave polygons require much
        % more processing)
        isConvex = 1;
        
        currRect = CenterRectOnPointd(avgRect*allSizeAdjs(i),shapeXpos(i),shapeYpos(i));
        
        % Draw the rect to the screen
        Screen('FillPoly', w, rectColor, [xPosVector; yPosVector]', isConvex);
        
        if i==numShapes+1
            if targSideA > targSideB
                Screen('FillOval', w,rectColor, currRect);
            else
                Screen('FillRect', w,rectColor, currRect);
            end
        end
    end
    
    % Flip to the screen
    Screen('Flip', w);
    imageArrayA = Screen('GetImage', w,theRect );
    % flip
    
    for i = 1:numShapes+1
        
        numSides = allSidesB(i);
        currRect = CenterRectOnPointd(avgRect*allSizeAdjs(i),shapeXpos(i),shapeYpos(i));
        
        % Angles at which our polygon vertices endpoints will be. We start at zero
        % and then equally space vertex endpoints around the edge of a circle. The
        % polygon is then defined by sequentially joining these end points.
        anglesDeg = linspace(0, 360, numSides + 1);
        anglesRad = anglesDeg * (pi / 180);
        %         radiusX = avgRect(3)*allSizeAdjs(i);
        %         radiusY = avgRect(4)*allSizeAdjs(i);
        radius = (mean(avgRect(3:4))./3)*allSizeAdjs(i);
        
        
        
        % X and Y coordinates of the points defining out polygon, centred on the
        % centre of the screen
        yPosVector = sin(anglesRad) .* radius + shapeYpos(i);
        xPosVector = cos(anglesRad) .* radius + shapeXpos(i);
        
        % Set the color of the rect to red
        rectColor = allColorsB(i,:);
        
        % Cue to tell PTB that the polygon is convex (concave polygons require much
        % more processing)
        isConvex = 1;
        
        % Draw the rect to the screen
        Screen('FillPoly', w, rectColor, [xPosVector; yPosVector]', isConvex);
        if i==numShapes+1
            if targSideA > targSideB
                Screen('FillRect', w,rectColor, currRect);
            else
                Screen('FillOval', w,rectColor, currRect);
            end
        end
        
    end
    
    % Flip to the screen
    Screen('Flip', w);
    %flip
    imageArrayB = Screen('GetImage', w,theRect );
    
    
    % imwrite is a Matlab function, not a PTB-3 function
    imwrite(imageArrayA,['Stimuli_shp' filesep 'shp_' fileListImg(As(j)).name]);
    imwrite(imageArrayB,['Stimuli_shp' filesep 'shp_' fileListImg(Bs(j)).name]);
    
    
end


%% clean up
clc;
ptb_cleanup;