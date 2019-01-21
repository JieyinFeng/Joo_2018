function [display,config,result] = RunPractice(subjectName,subjectIni,ver)

% clearvars -except subjectName subjectIni ver eccen

mainDir = pwd;
%%
kb = InitKeyboard;

mt_prepSounds;

if ver == 2
    joymex2('open',0);
end

%%
% subjectName = input('Your name? : ', 's');
% subjectIni = input('Your Initials? : ', 's');

oldenablekeys = RestrictKeysForKbCheck([kb.escKey, kb.spaceKey, kb.downKey, kb.rightKey]);

display.bkColor = [128 128 128];
display.fixColor = [0 0 0];

display.dist = 58;
display.width = 53.3;
display.widthInVisualAngle = 2*atan(display.width/2/display.dist) * 180/pi;

display = OpenWindow(display);
HideCursor(display.wPtr);
% Screen('CloseAll');

display.fixShape = 'bullseye';
display.fixSize = 1*display.ppd;
display.fixation = [display.cx display.cy];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
config.nStairs = 2;
config.nTrials = 25;

config.nTotalTrials = config.nStairs*config.nTrials;

result.response = NaN * ones(1, config.nTotalTrials);

% if eccen == 1 % 4 degree eccentricity
%     config.eccen = 4;
% else % 8 degree eccentricity
%     config.eccen = 8;
% end

config.startPoint = 6 * .5 * 1.3; % 1.3 times critical spacing Bouma
result.q = PrepareQuest(config);
result.quest = zeros(config.nTrials, 3, config.nStairs);
result.response = NaN * ones(1,config.nTotalTrials);
result.keyResponse = NaN * ones(1,config.nTotalTrials);

config.randOrder = repmat([1 2], 1, config.nTrials);
config.randOrder = Shuffle(config.randOrder); % Stair order
config.dir = repmat([0 1], 1, config.nTotalTrials/2); % up or down the gap
config.dir = Shuffle(config.dir);
config.loc = repmat([0 1], 1, config.nTotalTrials/2); % left or right
config.loc = Shuffle(config.dir);

config.dur = .2; % 150 ms duration
config.ovalSize = 1 * display.ppd; % in diameter
    
stair1 = 1; stair2 = 1; trial = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

config.eccen = [6*ones(1,10) 6*ones(1,10) 10*ones(1,10) 10*ones(1,10)]; % single single crowding crowding
config.spacing = config.eccen * .5;
    
MakeFixation(display);
Screen('Flip', display.wPtr);
WaitSecs(.5);

if ~config.loc(2) % left
    config.rect(1,:) = [display.cx - config.eccen(trial)*display.ppd - config.spacing(1)*display.ppd, ...
        display.cy, display.cx - config.eccen(trial)*display.ppd - config.spacing(1)*display.ppd, ...
        display.cy];
    config.rect(2,:) = [display.cx - config.eccen(trial)*display.ppd, ...
        display.cy - config.spacing(1)*display.ppd, display.cx - config.eccen(trial)*display.ppd, ...
        display.cy - config.spacing(1)*display.ppd];
    config.rect(3,:) = [display.cx - config.eccen(trial)*display.ppd + config.spacing(1)*display.ppd, ...
        display.cy, display.cx - config.eccen(trial)*display.ppd + config.spacing(1)*display.ppd, ...
        display.cy];
    config.rect(4,:) = [display.cx - config.eccen(trial)*display.ppd, ...
        display.cy + config.spacing(1)*display.ppd, display.cx - config.eccen(trial)*display.ppd, ...
        display.cy + config.spacing(1)*display.ppd];
    config.rect(5,:) = [display.cx - config.eccen(trial)*display.ppd, ...
        display.cy, display.cx - config.eccen(trial)*display.ppd, ...
        display.cy];
else
    config.rect(1,:) = [display.cx + config.eccen(trial)*display.ppd - config.spacing(1)*display.ppd, ...
        display.cy, display.cx + config.eccen(trial)*display.ppd - config.spacing(1)*display.ppd, ...
        display.cy];
    config.rect(2,:) = [display.cx + config.eccen(trial)*display.ppd, ...
        display.cy - config.spacing(1)*display.ppd, display.cx + config.eccen(trial)*display.ppd, ...
        display.cy - config.spacing(1)*display.ppd];
    config.rect(3,:) = [display.cx + config.eccen(trial)*display.ppd + config.spacing(1)*display.ppd, ...
        display.cy, display.cx + config.eccen(trial)*display.ppd + config.spacing(1)*display.ppd, ...
        display.cy];
    config.rect(4,:) = [display.cx + config.eccen(trial)*display.ppd, ...
        display.cy + config.spacing(1)*display.ppd, display.cx + config.eccen(trial)*display.ppd, ...
        display.cy + config.spacing(1)*display.ppd];
    config.rect(5,:) = [display.cx + config.eccen(trial)*display.ppd, ...
        display.cy, display.cx + config.eccen(trial)*display.ppd, ...
        display.cy];
end
config.rect = config.rect + repmat([-config.ovalSize/2 -config.ovalSize/2 config.ovalSize/2 config.ovalSize/2],5,1);

if config.dir(trial) % Up gap
    startAngle = 345;
    arcAngle = 30;
else
    startAngle = 165;
    arcAngle = 30;
end

str1 = 'Upward facing gap = move joystick up';
str2 = 'Downward facing gap = move joystick Down';
str5 = 'Hit space key to continue.';
str6 = 'HIT ESCAPE to EXIT';

textBounds1 = Screen('TextBounds',display.wPtr,str1);
textBounds2 = Screen('TextBounds',display.wPtr,str2);
textBounds5 = Screen('TextBounds',display.wPtr,str5);
textBounds6 = Screen('TextBounds',display.wPtr,str6);

Screen('DrawText',display.wPtr, str1, display.cx - round((textBounds1(3)-textBounds1(1))/2), ...
    display.cy - 400,[0 0 0]);
Screen('DrawText',display.wPtr, str2, display.cx - round((textBounds2(3)-textBounds2(1))/2), ...
    display.cy - 300,[0 0 0]);
Screen('DrawText',display.wPtr, str5, display.cx - round((textBounds5(3)-textBounds5(1))/2), ...
    display.cy + 100,[0 0 0]);
Screen('DrawText',display.wPtr, str6, display.cx - round((textBounds6(3)-textBounds6(1))/2), ...
    display.cy + 200,[0 0 0]);

for iOval = 1: 5
    Screen('FrameOval', display.wPtr, [0 0 0], config.rect(iOval,:), 3, 3);
end
Screen('FrameArc', display.wPtr, [128 128 128], config.rect(5,:), startAngle, arcAngle, 3, 3);
MakeFixation(display);
Screen('Flip', display.wPtr);

wait4Space = 0;
while ~wait4Space
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(-1);
    if keyIsDown && keyCode(kb.spaceKey)
        wait4Space = 1;
    end
end
FlushEvents('KeyIsDown')    
WaitSecs(.5);

try
%% Trials
while trial <= 40
    if trial == 1
        str1 = 'A target will appear nearby the fixation mark.';
        str2 = 'The target will be surrounded by circles.';
        str5 = 'Hit space key when you are ready.';
        textBounds1 = Screen('TextBounds',display.wPtr,str1);
        textBounds2 = Screen('TextBounds',display.wPtr,str2);
        textBounds5 = Screen('TextBounds',display.wPtr,str5);
        %     textBounds6 = Screen('TextBounds',display.wPtr,str6);
        
        Screen('DrawText',display.wPtr, str1, display.cx - round((textBounds1(3)-textBounds1(1))/2), ...
            display.cy - 400,[0 0 0]);
        Screen('DrawText',display.wPtr, str2, display.cx - round((textBounds2(3)-textBounds2(1))/2), ...
            display.cy - 300,[0 0 0]);
        Screen('DrawText',display.wPtr, str5, display.cx - round((textBounds5(3)-textBounds5(1))/2), ...
            display.cy + 100,[0 0 0]);
        %     Screen('DrawText',display.wPtr, str6, display.cx - round((textBounds6(3)-textBounds6(1))/2), ...
        %         display.cy + 200,[0 0 0]);
        
        Screen('Flip', display.wPtr);
        
        wait4Space = 0;
        while ~wait4Space
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(-1);
            if keyIsDown && keyCode(kb.spaceKey)
                wait4Space = 1;
            end
        end
    elseif trial == 11
        str1 = 'A target will appear nearby the fixation mark.';
        str2 = 'The target will be displayed alone.';
        str5 = 'Hit space key when you are ready.';
        textBounds1 = Screen('TextBounds',display.wPtr,str1);
        textBounds2 = Screen('TextBounds',display.wPtr,str2);
        textBounds5 = Screen('TextBounds',display.wPtr,str5);
        %     textBounds6 = Screen('TextBounds',display.wPtr,str6);
        
        Screen('DrawText',display.wPtr, str1, display.cx - round((textBounds1(3)-textBounds1(1))/2), ...
            display.cy - 400,[0 0 0]);
        Screen('DrawText',display.wPtr, str2, display.cx - round((textBounds2(3)-textBounds2(1))/2), ...
            display.cy - 300,[0 0 0]);
        Screen('DrawText',display.wPtr, str5, display.cx - round((textBounds5(3)-textBounds5(1))/2), ...
            display.cy + 100,[0 0 0]);
        %     Screen('DrawText',display.wPtr, str6, display.cx - round((textBounds6(3)-textBounds6(1))/2), ...
        %         display.cy + 200,[0 0 0]);
        
        Screen('Flip', display.wPtr);
        
        wait4Space = 0;
        while ~wait4Space
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(-1);
            if keyIsDown && keyCode(kb.spaceKey)
                wait4Space = 1;
            end
        end
    elseif trial == 21
        str1 = 'A target will appear far from the fixation mark.';
        str2 = 'The target will be surrounded by circles.';
        str5 = 'Hit space key when you are ready.';
        textBounds1 = Screen('TextBounds',display.wPtr,str1);
        textBounds2 = Screen('TextBounds',display.wPtr,str2);
        textBounds5 = Screen('TextBounds',display.wPtr,str5);
        %     textBounds6 = Screen('TextBounds',display.wPtr,str6);
        
        Screen('DrawText',display.wPtr, str1, display.cx - round((textBounds1(3)-textBounds1(1))/2), ...
            display.cy - 400,[0 0 0]);
        Screen('DrawText',display.wPtr, str2, display.cx - round((textBounds2(3)-textBounds2(1))/2), ...
            display.cy - 300,[0 0 0]);
        Screen('DrawText',display.wPtr, str5, display.cx - round((textBounds5(3)-textBounds5(1))/2), ...
            display.cy + 100,[0 0 0]);
        %     Screen('DrawText',display.wPtr, str6, display.cx - round((textBounds6(3)-textBounds6(1))/2), ...
        %         display.cy + 200,[0 0 0]);
        
        Screen('Flip', display.wPtr);
        
        wait4Space = 0;
        while ~wait4Space
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(-1);
            if keyIsDown && keyCode(kb.spaceKey)
                wait4Space = 1;
            end
        end
    elseif trial == 31
        str1 = 'A target will appear far from the fixation mark.';
        str2 = 'The target will be displayed alone.';
        str5 = 'Hit space key when you are ready.';
        textBounds1 = Screen('TextBounds',display.wPtr,str1);
        textBounds2 = Screen('TextBounds',display.wPtr,str2);
        textBounds5 = Screen('TextBounds',display.wPtr,str5);
        %     textBounds6 = Screen('TextBounds',display.wPtr,str6);
        
        Screen('DrawText',display.wPtr, str1, display.cx - round((textBounds1(3)-textBounds1(1))/2), ...
            display.cy - 400,[0 0 0]);
        Screen('DrawText',display.wPtr, str2, display.cx - round((textBounds2(3)-textBounds2(1))/2), ...
            display.cy - 300,[0 0 0]);
        Screen('DrawText',display.wPtr, str5, display.cx - round((textBounds5(3)-textBounds5(1))/2), ...
            display.cy + 100,[0 0 0]);
        %     Screen('DrawText',display.wPtr, str6, display.cx - round((textBounds6(3)-textBounds6(1))/2), ...
        %         display.cy + 200,[0 0 0]);
        
        Screen('Flip', display.wPtr);
        
        wait4Space = 0;
        while ~wait4Space
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(-1);
            if keyIsDown && keyCode(kb.spaceKey)
                wait4Space = 1;
            end
        end
    end

    config.spacing(trial) = config.eccen(trial) * .5;
    
    MakeFixation(display);
    Screen('Flip', display.wPtr);
    WaitSecs(.5);
    
    if ~config.loc(trial) % left
        config.rect(1,:) = [display.cx - config.eccen(trial)*display.ppd - config.spacing(trial)*display.ppd, ...
            display.cy, display.cx - config.eccen(trial)*display.ppd - config.spacing(trial)*display.ppd, ...
            display.cy];
        config.rect(2,:) = [display.cx - config.eccen(trial)*display.ppd, ...
            display.cy - config.spacing(trial)*display.ppd, display.cx - config.eccen(trial)*display.ppd, ...
            display.cy - config.spacing(trial)*display.ppd];
        config.rect(3,:) = [display.cx - config.eccen(trial)*display.ppd + config.spacing(trial)*display.ppd, ...
            display.cy, display.cx - config.eccen(trial)*display.ppd + config.spacing(trial)*display.ppd, ...
            display.cy];
        config.rect(4,:) = [display.cx - config.eccen(trial)*display.ppd, ...
            display.cy + config.spacing(trial)*display.ppd, display.cx - config.eccen(trial)*display.ppd, ...
            display.cy + config.spacing(trial)*display.ppd];
        config.rect(5,:) = [display.cx - config.eccen(trial)*display.ppd, ...
            display.cy, display.cx - config.eccen(trial)*display.ppd, ...
            display.cy];
    else
        config.rect(1,:) = [display.cx + config.eccen(trial)*display.ppd - config.spacing(trial)*display.ppd, ...
            display.cy, display.cx + config.eccen(trial)*display.ppd - config.spacing(trial)*display.ppd, ...
            display.cy];
        config.rect(2,:) = [display.cx + config.eccen(trial)*display.ppd, ...
            display.cy - config.spacing(trial)*display.ppd, display.cx + config.eccen(trial)*display.ppd, ...
            display.cy - config.spacing(trial)*display.ppd];
        config.rect(3,:) = [display.cx + config.eccen(trial)*display.ppd + config.spacing(trial)*display.ppd, ...
            display.cy, display.cx + config.eccen(trial)*display.ppd + config.spacing(trial)*display.ppd, ...
            display.cy];
        config.rect(4,:) = [display.cx + config.eccen(trial)*display.ppd, ...
            display.cy + config.spacing(trial)*display.ppd, display.cx + config.eccen(trial)*display.ppd, ...
            display.cy + config.spacing(trial)*display.ppd];
        config.rect(5,:) = [display.cx + config.eccen(trial)*display.ppd, ...
            display.cy, display.cx + config.eccen(trial)*display.ppd, ...
            display.cy];
    end
    config.rect = config.rect + repmat([-config.ovalSize/2 -config.ovalSize/2 config.ovalSize/2 config.ovalSize/2],5,1);
    
    if config.dir(trial) % Up gap
        startAngle = 345;
        arcAngle = 30;
    else
        startAngle = 165;
        arcAngle = 30;
    end
    
    j = 1; t = GetSecs;
    PsychPortAudio('Start', 2, 1, 0, 1);

    while j <= config.dur*display.frameRate
        if trial <= 10 || (trial > 20 && trial <=30)
            for iOval = 1: 5
                Screen('FrameOval', display.wPtr, [0 0 0], config.rect(iOval,:), 3, 3);
            end
        else
            Screen('FrameOval', display.wPtr, [0 0 0], config.rect(5,:), 3, 3);
        end
        Screen('FrameArc', display.wPtr, [128 128 128], config.rect(5,:), startAngle, arcAngle, 3, 3);
        MakeFixation(display);
        Screen('Flip', display.wPtr);
        j = j + 1;
        while GetSecs-t < (j-1)*display.ifi, ;, end
%         KbStrokeWait;
    end
    result.displayDur(trial) = GetSecs - t;
    
    MakeFixation(display);
    Screen('Flip', display.wPtr);
    
    isResponded = 0;
    FlushEvents('keyDown');
    while ~isResponded
        if ver == 1 % keyboard response
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(-1);
            if keyIsDown
                if keyCode(kb.downKey)
                    result.keyResponse(trial) = 1;
                    isResponded = 1;
                elseif keyCode(kb.rightKey)
                    result.keyResponse(trial) = 0;
                    isResponded = 1;
                elseif keyCode(kb.escKey)
                    Screen('CloseAll');
                    ListenChar(0);
                    ShowCursor;
                    break;
                end
            end
        else % joystick response
            a = joymex2('query',0);
            if a.axes(2) < -10000 %|| a.axes(3) < -10000
                result.keyResponse(trial) = 1;
                isResponded = 1;
            elseif a.axes(2) > 10000 %|| a.axes(3) > 10000
                result.keyResponse(trial) = 0;
                    isResponded = 1;
            else
                [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(-1);
                if keyCode(kb.escKey)
                    Screen('CloseAll');
                    ListenChar(0);
                    ShowCursor;
                    break;
                end
            end
        end
    end
    result.response(trial) = result.keyResponse(trial) == config.dir(trial);
    repeatAgain = 0;
    
    oldTextSize = Screen('TextSize', display.wPtr, 30);
    if result.response(trial)
        PsychPortAudio('Start', 0, 1, 0, 1);
        str = '+';
        textBounds = Screen('TextBounds',display.wPtr,str);
        Screen('DrawText',display.wPtr, str, display.cx - round((textBounds(3)-textBounds(1))/2), ...
            display.cy - round((textBounds(4)-textBounds(2))/2),[0 255 0]);
%         score = score + 1;
    else
        PsychPortAudio('Start', 2, 1, 0, 1);
        str = '-';
        textBounds = Screen('TextBounds',display.wPtr,str);
        Screen('DrawText',display.wPtr, str, display.cx - round((textBounds(3)-textBounds(1))/2), ...
            display.cy - round((textBounds(4)-textBounds(2))/2),[255 0 0]);
        if stair1 == 1 || stair2 == 1
            repeatAgain = 1;
        end
    end
    Screen('Flip',display.wPtr);
    
    Screen('TextSize', display.wPtr, oldTextSize);
    
    if ~repeatAgain
        if config.randOrder(trial) == 1
            result.quest(stair1, 1, 1) = result.response(trial);
            result.quest(stair1, 2, 1) = QuestMean(result.q(1));
            result.quest(stair1, 3, 1) = 10^(QuestMean(result.q(1)));
            result.q(1) = QuestUpdate(result.q(1),QuestMean(result.q(1)),result.response(trial));
            stair1 = stair1 + 1;
        elseif config.randOrder(trial) == 2
            result.quest(stair2, 1, 2) = result.response(trial);
            result.quest(stair2, 2, 2) = QuestMean(result.q(2));
            result.quest(stair2, 3, 2) = 10^(QuestMean(result.q(2)));
            result.q(2) = QuestUpdate(result.q(2),QuestMean(result.q(2)),result.response(trial));
            stair2 = stair2 + 1;
        end
        
        if ver == 2
            joyCorrect = 0;
            while ~joyCorrect
                a = joymex2('query',0);
                if (a.axes(1) > -1000 && a.axes(1) < 1000) && (a.axes(2) > -1000 && a.axes(2) < 1000)
                    joyCorrect = 1;
                end
            end
        end
    
        trial = trial + 1;
    end
    
    WaitSecs(1);
end

% if isempty(dir('Data'))
%     mkdir('Data');
% end
% cd('Data');
% fn = sprintf('%s-%s.mat',subjectIni,datestr(now,'yyyymmdd-HHMM'));
% save(fn,'display','config','result','dots');
% cd(mainDir);

% str1 = 'HALL of FAME';
% str2 = sprintf('1. %s \t 147', 'Chloe');
% str3 = sprintf('2. %s \t %d', subjectName, score*3);
% str4 = sprintf('3. %s \t %d', 'Jason', score*3-30);
str5 = 'Hit space key to continue.';

% textBounds1 = Screen('TextBounds',display.wPtr,str1);
% textBounds2 = Screen('TextBounds',display.wPtr,str2);
% textBounds3 = Screen('TextBounds',display.wPtr,str3);
% textBounds4 = Screen('TextBounds',display.wPtr,str4);
textBounds5 = Screen('TextBounds',display.wPtr,str5);

% if flag
% Screen('DrawText',display.wPtr, str1, display.cx - round((textBounds1(3)-textBounds1(1))/2), ...
%         display.cy - 400,[0 0 0]);
% Screen('DrawText',display.wPtr, str2, display.cx - round((textBounds2(3)-textBounds2(1))/2), ...
%         display.cy - 300,[0 0 0]);
% Screen('DrawText',display.wPtr, str3, display.cx - round((textBounds3(3)-textBounds3(1))/2), ...
%         display.cy - 200,[0 0 0]);
% Screen('DrawText',display.wPtr, str4, display.cx - round((textBounds4(3)-textBounds4(1))/2), ...
%         display.cy - 100,[0 0 0]);
% end
Screen('DrawText',display.wPtr, str5, display.cx - round((textBounds5(3)-textBounds5(1))/2), ...
        display.cy + 100,[0 0 0]);

Screen('Flip', display.wPtr);

wait4Space = 0;
while ~wait4Space
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(-1);
    if keyIsDown && keyCode(kb.spaceKey)
        wait4Space = 1;
    end
end

if isempty(dir('Data'))
    mkdir('Data');
end
cd('Data');
fn = sprintf('P-%s-%s.mat',subjectIni,datestr(now,'yyyymmdd-HHMM'));
save(fn,'display','config','result');
cd(mainDir);

catch ME
Screen('CloseAll');
ShowCursor;
ListenChar(0);
RestrictKeysForKbCheck([]); % Re-enable all keys
rethrow(ME)
end

Screen('CloseAll');
ShowCursor;
ListenChar(0);
RestrictKeysForKbCheck([]); % Re-enable all keys
