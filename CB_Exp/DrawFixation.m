function DrawFixation(window,x,y,darkCode,size)
c = ones(3,1)*(255-(darkCode*254));
%Screen('DrawDots', window, [0;0], size,c,[x/2 y/2],1);
Screen('FillOval', window,c, [x/2-size y/2-size x/2+size y/2+size]);
end