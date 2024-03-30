%% Initilization and user info input
clear;format compact;clc;
ptb_cleanup;sca;clc;sca;clc;
% close cleanup PTB on clean up
magic_cleanup = onCleanup(@ptb_cleanup);

exp_1_start = WaitSecs(0);
%gather machine information
pMachine = computer;
pOS = getenv('OS');
pOS2 = system_dependent('getos');

PTBverStruct = ver('Psychtoolbox');
PTBver = PTBverStruct(1).Version;
PTBrel = PTBverStruct(1).Release;
PTBrelDt = PTBverStruct(1).Date;
MATLABverStruct = ver('MATLAB');
MATLABver = MATLABverStruct(1).Version;
MATLABrel = MATLABverStruct(1).Release;
MATLABrelDt = MATLABverStruct(1).Date;

exp_2_userInfo_start = WaitSecs(0);

[pID, pInitials, pGender, pAge] = GetUserInfo();

% initialize ptb and open a window
skipSync = 1;
visualDebug = 0;
hCursor = 1;
debugMode = 0; % set the debug mode
exp_3_ptb_start = WaitSecs(0);
[w,wRect,ifi] = ptb_init(skipSync,visualDebug,hCursor,debugMode);
x = wRect(3);
y = wRect(4);
% Get the centre coordinate of the window
%[xCenter, yCenter] = RectCenter(wRect);
fSize = round(y/16);
Screen('TextSize', w, fSize);

mSize = round(y/100);

%%
stimInt = .75;
maskInt = .25;
iterNum = 10;

fileListImg=dir(['Stimuli_img' filesep '*.jpg']);
fileListShp=dir(['Stimuli_shp' filesep '*.jpg']);

%%

chRectPctInc = .05; %.05= 5 ; make it 5 percent large in all direction
% How long should the image stay up during flicker in time and frames
imageSecs = stimInt;
imageFrames = round(imageSecs / ifi);

% Duration (in seconds) of the blanks between the images during flicker
blankSecs = maskInt;
blankFrames = round(blankSecs / ifi);

% Make a vector which shows what we do on each frame
presVector = [ones(1, imageFrames) zeros(1, blankFrames)...
    ones(1, imageFrames) .* 2 zeros(1, blankFrames)];

cond = 2;
condTrials = 10;
condTrialsHalf = condTrials/2;
totalTrials = condTrials*cond;

trialConds=sortrows([[zeros(condTrials,1);ones(condTrials,1)]...
    repmat([zeros(condTrialsHalf,1);ones(condTrialsHalf,1)],2,1)...
    rand(totalTrials,1)],3);
trialCond = trialConds(:,1)';
trialCondTrace = trialConds(:,2)';

As = 2*(1:condTrials)-1;
Bs = 2*(1:condTrials);

[B,I]=sort(rand(1,condTrials));

As = As(I);%suffled
Bs = Bs(I);%suffled

imgCounter=0;
shpCounter=0;

[yVals,xVals] = find(ones(y,x));

% msg = 'Start...\n\npress any key to begin...';
% DrawFormattedText(w,msg,'center', 'center', [255 255 255 255]);
% Screen('Flip', w);% Flip
% KbStrokeWait;% Wait for a key press

Welcome(w, wRect,ifi);
exp_4_instructions_start = WaitSecs(0);
%%
% Instructions(w, wRect);

msg = 'A small white circle will appear on the screen.\nFollow the circle with your mouse, SLOWLY.\nIf you deviate from the line too much,\n your mouse will not move.\n\n**NOTE: If the cursor gets stuck click the mouse\nWe will practice this once. \n\nPress enter...';
DrawFormattedText(w, msg,'center', 'center', [0 0 0]);
lastFlipTime = Screen('Flip', w);
KbStrokeWait;

[~,~]= MouseTrace(w,mSize,x,y,[x/y y/2],[x/10 x/10]);

msg = 'Once you reach a certain spot, \nthe tracing will end and shapes \nwill begin to flash on the screen. \nYour job is to find the shape\n that is changing shape/color. \nAs soon as you find the shape \nthat is changing shape/color, \nclick on it. \n\nPress enter to see an example.';
DrawFormattedText(w, msg,'center', 'center', [0 0 0]);
lastFlipTime = Screen('Flip', w);
KbStrokeWait;

msg = 'In this example, \nthe left shoe of the player on the \nleft side of the image will change colors.\n\nPress enter to start...';
DrawFormattedText(w, msg,'center', 'center', [0 0 0]);
lastFlipTime = Screen('Flip', w);
KbStrokeWait;

pathA = 'inst-a.jpg';
pathB = 'inst-b.jpg';

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

% Make the images into textures
texA = Screen('MakeTexture', w, theImageA);
texB = Screen('MakeTexture', w, theImageB);

[xtPt,ytPt] = RectCenter(rectCh);

allDist = sqrt(((xVals)-xtPt).^2+((yVals)-ytPt).^2);
xtPtO = xVals(allDist==max(allDist));
ytPtO = yVals(allDist==max(allDist));

xmPt = round(mean([xtPt xtPtO]));
ymPt = round(mean([ytPt ytPtO]));

DrawExpFix(w,x,y,ifi);
ShowCursor;
[~, ~, ~, ~] = ShowCBstim(ifi,w,mSize,iterNum, texA, texB,presVector, theRect,rectCh);
% Bin the textures we used
Screen('Close', texA);
Screen('Close', texB);


%%

lastFlipTime = Screen('Flip', w);
for i=128:200
    Screen('FillRect', w ,[i i i],wRect);
    lastFlipTime=Screen('Flip',w,lastFlipTime+3*ifi/2);
end

Screen('FillRect', w ,[200 200 200],wRect);
PreExp_ins = 'Please raise your hand at this point if\nyou have any questions about the instructions.\n\notherwise, press any key to continue.';
DrawFormattedText(w, PreExp_ins,'center', 'center', [0 0 0]);
Screen('Flip', w);
KbStrokeWait;
lastFlipTime = Screen('Flip', w);
for i=200:255
    Screen('FillRect', w ,[i i i],wRect);
    lastFlipTime=Screen('Flip',w,lastFlipTime+3*ifi/2);
end

Screen('FillRect', w ,[255 255 255],wRect);
PreExp_ins = 'You will now begin the actual experiment.\n\npress any key to continue.';
DrawFormattedText(w, PreExp_ins,'center', 'center', [0 0 0]);
lastFlipTime = Screen('Flip', w);
KbStrokeWait;
Screen('FillRect', w ,[255 255 255],wRect);
lastFlipTime = Screen('Flip', w);
for i=255:-1:128
    Screen('FillRect', w ,[i i i],wRect);
    lastFlipTime=Screen('Flip',w,lastFlipTime+3*ifi/2);
end

exp_5_preExp = WaitSecs(0);
for i=1:totalTrials
    
    if trialCond(i)==0 %image
        imgCounter = imgCounter+1;
        
        pathA = ['Stimuli_img' filesep fileListImg(As(imgCounter)).name];
        pathB = ['Stimuli_img' filesep fileListImg(Bs(imgCounter)).name];
        
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
        
        % Make the images into textures
        texA = Screen('MakeTexture', w, theImageA);
        texB = Screen('MakeTexture', w, theImageB);
        
        [xtPt,ytPt] = RectCenter(rectCh);
        xtPtChange(i) = xtPt;
        ytPtChange(i) = ytPt;
        
        allDist = sqrt(((xVals)-xtPt).^2+((yVals)-ytPt).^2);
        xtPtO = xVals(allDist==max(allDist));
        ytPtO = yVals(allDist==max(allDist));
        
        xmPt = round(mean([xtPt xtPtO]));
        ymPt = round(mean([ytPt ytPtO]));
        
        DrawExpFix(w,x,y,ifi);
        ShowCursor;
        if trialCondTrace(i)==1 % from mid to target
            [mouseX(i),mouseY(i)]= MouseTrace(w,mSize,x,y,[xmPt ymPt],[xtPt ytPt]);
        else
            [mouseX(i),mouseY(i)]= MouseTrace(w,mSize,x,y,[xmPt ymPt],[xtPtO ytPtO]);
        end
        % figure out the rect to stop by passig in the chRect and finding the
        % farthest point, then find midpoint(start trace) and either pass chRect or
        % chRectOpp for the opposite rect
        % draw the trace and pass the rect to stop and the start location
        [hits(i) missCnt(i), hitRT(i), hitIterNum(i)] = ShowCBstim(ifi,w,mSize,iterNum, texA, texB,presVector, theRect,rectCh);
        % Bin the textures we used
        Screen('Close', texA);
        Screen('Close', texB);
        
    else
        % do shape
        shpCounter=shpCounter+1;
        pathA = ['Stimuli_shp' filesep fileListShp(As(shpCounter)).name];
        pathB = ['Stimuli_shp' filesep fileListShp(Bs(shpCounter)).name];
        
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
        
        % Make the images into textures
        texA = Screen('MakeTexture', w, theImageA);
        texB = Screen('MakeTexture', w, theImageB);
        
        % theRect(1) gray bars to mirror the images
        
        [xtPt,ytPt] = RectCenter(rectCh);
        
        xtPtChange(i) = xtPt;
        ytPtChange(i) = ytPt;
        
        allDist = sqrt(((xVals)-xtPt).^2+((yVals)-ytPt).^2);
        xtPtO = xVals(allDist==max(allDist));
        ytPtO = yVals(allDist==max(allDist));
        
        xmPt = round(mean([xtPt xtPtO]));
        ymPt = round(mean([ytPt ytPtO]));
        
        DrawExpFix(w,x,y,ifi);
        ShowCursor;
        if trialCondTrace(i)==1 % from mid to target
            [mouseX(i),mouseY(i)]= MouseTrace(w,mSize,x,y,[xmPt ymPt],[xtPt ytPt]);
        else
            [mouseX(i),mouseY(i)]= MouseTrace(w,mSize,x,y,[xmPt ymPt],[xtPtO ytPtO]);
        end
        % figure out the rect to stop by passig in the chRect and finding the
        % farthest point, then find midpoint(start trace) and either pass chRect or
        % chRectOpp for the opposite rect
        % draw the trace and pass the rect to stop and the start location
        [hits(i) missCnt(i), hitRT(i), hitIterNum(i)] = ShowCBstim(ifi,w,mSize,iterNum, texA, texB,presVector, theRect,rectCh);
        % Bin the textures we used
        Screen('Close', texA);
        Screen('Close', texB);
        
    end
    
    HideCursor;
    
end
exp_6_complete = WaitSecs(0);
%% thank you!!! Save Data!
formatOut = 'mmddyyyy_HHMMSS';
filename = ['Results' filesep 'CB_ExpData_' datestr(now,formatOut) '_' num2str(pID) '.mat'];
exp_7_saveVars = WaitSecs(0);
save(filename);

%Screen('TextSize', w, fSize*1.5);

lastFlipTime=Screen('Flip',w);
for i=128:1:255
    Screen('FillRect', w ,[i i i],wRect);
    lastFlipTime=Screen('Flip',w,lastFlipTime+3*(ifi/2));
end

Screen('FillRect', w ,[255 255 255],wRect);
Final_ins = 'Thank you for your participation!\n\nPlease locate the ".mat" file in this folder:\n"MATLAB > CB_Exp > Results"\nand email it to:\n---\nSubject Line: Psych 20B Exp.\n\n\n\n\n';
DrawFormattedText(w, Final_ins,'center', 'center', [0 0 0]);
Screen('Flip', w);
WaitSecs(3);
Screen('FillRect', w ,[255 255 255],wRect);
Final_ins = 'Thank you for your participation!\n\nPlease locate the ".mat" file in this folder:\n"MATLAB > CB_Exp > Results"\nand email it to:\n---\nSubject Line: Psych 20B Exp.\n\nPress any key to exit.\n\nthe email address also appears on the next screen\nafter you exit.';
DrawFormattedText(w, Final_ins,'center', 'center', [0 0 0]);
Screen('Flip', w);
KbStrokeWait;
exp_7_complete = WaitSecs(0);

%% clean up
clc;
ptb_cleanup;
clear;
clc;
disp('Thank you for your contribution to science!');
disp(' ');
disp(' ');
disp('Please locate the ".mat" file in this folder:');
disp('"MATLAB > CB_Exp > Results"');
disp(' ');
disp('and email the file to:');
disp('---');
disp(' ');

%%
