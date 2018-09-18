function [w, wRect,ifi] = ptb_init(skipSync,visualDebug,hCursor,debugMode) % set debugMode=1 to open smaller screen

% check for OpenGL compatibility, abort otherwise:
AssertOpenGL;

% Make sure keyboard mapping is the same on all supported operating systems
% Apple MacOS/X, MS-Windows and GNU/Linux:
KbName('UnifyKeyNames');

% set skipSync=1 to skip the test
Screen('Preference', 'SkipSyncTests', skipSync);
% set visualDebug=0 to skip the visual debug test
Screen('Preference', 'VisualDebugLevel', visualDebug);

% Get screenNumber of stimulation display. We choose the display with
% the maximum index, which is usually the right one, e.g., the external
% display on a Laptop:
screens=Screen('Screens');
screenNumber=max(screens);

% Define black and white
wI = WhiteIndex(screenNumber); % white
bI = BlackIndex(screenNumber); % black
gI = round(wI / 2,0);% grey

rect = Screen(screenNumber,'Rect');
[xC,yC] = RectCenter(rect);

if debugMode
    rect = rect ./ 2; %quarter the size window
    rect = CenterRectOnPoint(rect,xC,yC);
end

% Hide the mouse cursor:
if hCursor
    HideCursor;
end

% Open a double buffered fullscreen window on the stimulation screen
% 'screenNumber' and choose/draw a gray background. 'w' is the handle
% used to direct all drawing commands to that window - the "Name" of
% the window. 'wRect' is a rectangle defining the size of the window.
% See "help PsychRects" for help on such rectangles and useful helper
% functions:

[w, wRect]=Screen('OpenWindow',screenNumber,[gI gI gI],rect);

%[w, wRect] = PsychImaging('OpenWindow', screenNumber, grey,rect);

% Set the blend funciton for the screen
Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Set text size (Most Screen functions must be called after
% opening an onscreen window, as they only take window handles 'w' as
% input:
Screen('TextFont', w, 'Arial');
Screen('TextSize', w, 40);

%don't echo keypresses to Matlab window
ListenChar(2);

% Do dummy calls to GetSecs, WaitSecs, KbCheck to make sure
% they are loaded and ready when we need them - without delays
% in the wrong moment:
KbCheck;
WaitSecs(0.1);
GetSecs;

% Set priority for script execution to realtime priority:
priorityLevel=MaxPriority(w);
Priority(priorityLevel);

ifi = Screen('GetFlipInterval',w);% inter-flip time

end
