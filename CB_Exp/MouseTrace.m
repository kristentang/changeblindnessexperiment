function [mouseX,mouseY]= MouseTrace(w,mSize,x,y,startXY,endXY)

% example call:

x1=startXY(1);x2=endXY(1);
y1=startXY(2);y2=endXY(2);

xM = mean([x1,x2]);
xM1 = mean([x1,xM]);
xM2 = mean([xM,x2]);
yM = mean([y1,y2]);
yM1 = mean([y1,yM]);
yM2 = mean([yM,y2]);

adjX = [1 (1+((rand(1,3)-.5)/3)) 1];
adjY = [1 (1+((rand(1,3)-.5)/3)) 1];

X = [x1 xM1 xM xM2 x2].*adjX;
Y = [y1 yM1 yM yM2 y2].*adjY;

intX = linspace(x1,x2, round(abs(x1-x2)));
intY = interp1(X,Y,intX,'linear');

pts = [intX;intY];

whiteColor = [255 255 255];

%%
%border = round(y/8);

[~,numPts]=size(pts);

ptStatus = false(1,numPts);

bRectSide = round(y/75);
bRect = [0 0 bRectSide bRectSide];
nextPathLen = round(y/50);
nextPathLenHalf = round(y/100);

%xy = [1:x;(1:x)/x*y+sin((1:x)/10)*20];
xy = pts;
%Screen('DrawLines', w, xy(:,1:bRectSide),1,[255 255 255],[0 0],1);

ShowCursor;
mx=xy(1,1);
my=xy(2,1);
SetMouse(mx,my,w);
ptStatus(1)=true;

lastPt = find(ptStatus,1,'last');
mRect = CenterRectOnPointd(bRect,xy(1,lastPt),xy(2,lastPt));%allowed mouse rect

mRectEnd = CenterRectOnPointd(bRect,xy(1,end),xy(2,end));%target mouse rect

nextPt = (lastPt+nextPathLenHalf<=numPts)*(lastPt+nextPathLenHalf)+...
    (lastPt+nextPathLenHalf>numPts)*numPts;

Screen('DrawDots', w, xy(:,lastPt:nextPt),1,whiteColor);

%Screen('DrawLines', w, xy,1,[255 255 255],[0 0],1);
lastFlip  = Screen('Flip', w,0,1);% first Flip to get time
buttons = false(1,3);
%[pmx,pmy,buttons] = GetMouse(w);
pmx = xy(1,lastPt);
pmy = xy(2,lastPt);
while ~IsInRect(pmx, pmy,mRectEnd) && ~any(buttons)
    %tic;
    %  i=i+1;
    lastPt = find(ptStatus,1,'last');
    mRect = CenterRectOnPointd(bRect,xy(1,lastPt),xy(2,lastPt));%allowed mouse rect
    [mx,my,buttons] = GetMouse(w);
    if ~IsInRect(mx, my, mRect);% if not in bRect
        SetMouse(pmx,pmy,w);
        mx=pmx;my=pmy; % go back to prev position
    end
    
    statusChangeRect = CenterRectOnPointd(bRect,mx,my);
    uptoPt = find(logical((xy(1,:)>=statusChangeRect(1)).*...
        (xy(2,:)>=statusChangeRect(2)).*...
        (xy(1,:)<=statusChangeRect(3)).*...
        (xy(2,:)<=statusChangeRect(4))),1,'last');
    
    ptStatus(1:uptoPt)=true;
    
    Screen('DrawDots', w, [mx;my],2,whiteColor);
    nextPt = (lastPt+nextPathLen<=numPts-1)*(lastPt+nextPathLen)+...
        (lastPt+nextPathLen>numPts-1)*(numPts-1);
    %Screen('DrawLines', w, xy(:,1:nextPt),1,whiteColor,[],2);
 %   e = lastPt == nextPt;
 %   Screen('DrawDots', w, xy(:,lastPt-e:nextPt),3,whiteColor*.6);
    Screen('DrawDots', w, xy(:,nextPt),3,whiteColor);
    Screen('FillOval', w,[255 255 255], [mx-mSize my-mSize mx+mSize my+mSize]);
    Screen('FrameOval', w,[1 1 1], [mx-mSize my-mSize mx+mSize my+mSize]);
    %lastFlip  = Screen('Flip', w, lastFlip + (1 - 0.5) * ifi,1);
    lastFlip  = Screen('Flip', w, []);
    %    data(i,1:2)=[mx my];
    %   data(i,3)=toc;
    %  pmx=mx;pmy=my;
    pmx = xy(1,lastPt);
    pmy = xy(2,lastPt);
end

mouseX = mx;
mouseY = my;

end