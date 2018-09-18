function DrawExpFix(w,x,y,ifi)
% fixation
DrawFixation(w,x,y,1,15);
lastFlipTime=Screen('Flip',w);
DrawFixation(w,x,y,.7,15);
lastFlipTime=Screen('Flip',w,lastFlipTime+1.5-ifi/2);
lastFlipTime=Screen('Flip',w,lastFlipTime+1-ifi/2);


end