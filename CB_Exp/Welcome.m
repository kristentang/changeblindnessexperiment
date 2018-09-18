function Welcome(window, windowRect,ifi)
x = windowRect(3);
y = windowRect(4);
enterKey = KbName('Return');
RestrictKeysForKbCheck(enterKey); % enter only
% pre-exp instructions
Screen('FillRect', window ,[128 128 128],windowRect);
%Screen('TextSize', window, fSize);
DrawFormattedText(window, 'Welcome!\n\nPress ENTER to continue.','center', 'center', [0 0 0]);
onsetTime0=Screen('Flip',window);
KbStrokeWait;

DrawFormattedText(window, 'Before the actual experiment\nyou will first be introduced to the tasks\nand do a few practice rounds.\n\nPress enter to continue.','center', 'center', [0 0 0]);
onsetTime0=Screen('Flip',window);
KbStrokeWait;

DrawFormattedText(window, 'Prior to each trial of this experiment\na fixation point will appear briefly\nto let you know that the trial is about to begin.\nThe fixation point stays for 1.5 sec\nthen turns dark grey and stays for 1 sec\nafter which the trial will begin\n\nPress enter to see the fixation point.','center', 'center', [0 0 0]);
onsetTime0=Screen('Flip',window);
KbStrokeWait;
% fixation
DrawExpFix(window,x,y,ifi);

RestrictKeysForKbCheck([]); % any

end