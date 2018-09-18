function [hit,missCnt,hitRT, hitIterNum] = ShowCBstim(ifi,w,mSize,iterNum, texA, texB,presVector, theRect,rectCh)

% This is our drawing loop
waitframes = 1;% Numer of frames to wait before re-drawing
numPresLoopFrames = length(presVector);
respMade = 0;
numFrames = 0;
frame = 0;
hit = 0;
miss = 0;
iter = 0;
[mx,my,buttons] = GetMouse(w);
mClickDownLastFrame = any(buttons);
while respMade == 0 &&  iter <= iterNum
    
    % Increment the number of frames
    numFrames = numFrames + 1;
    frame = frame + 1;
    if frame > numPresLoopFrames
        frame = 1;
        iter = iter+1;
    end
    
    % Decide what we are showing on this frame
    showWhat = presVector(frame);
    
    % Draw the textures or a blank frame
    if showWhat == 1
        Screen('DrawTexture', w, texA, [], theRect, 0);
    elseif showWhat == 2
        Screen('DrawTexture', w, texB, [], theRect, 0);
    elseif showWhat == 0
        Screen('FillRect', w, [128 128 128]);
    end
    Screen('FillOval', w,[255 255 255], [mx-mSize my-mSize mx+mSize my+mSize]);
    Screen('FrameOval', w,[1 1 1], [mx-mSize my-mSize mx+mSize my+mSize]);
    % Flip to the screen
    if numFrames == 1
        vbl = Screen('Flip', w);
    else
        vbl = Screen('Flip', w, vbl + (waitframes - 0.5) * ifi);
    end
    
    % Poll the mouse
    [mx,my,buttons] = GetMouse(w);
    mClickDown = any(buttons);
    
    if  mClickDown && ~mClickDownLastFrame
        if IsInRect(mx, my, rectCh)
            respMade=1;
            hit=1;
        else
            miss=miss+1;
        end
    end
    mClickDownLastFrame = mClickDown;
    
    
end

% Calculate the time it took the person to see the change
hitRT = numFrames * ifi;
missCnt = miss;
hitIterNum = ceil(numFrames/numPresLoopFrames);



end




