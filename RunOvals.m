PsychJavaTrouble

clear all

clc

fprintf('Welcome!\n\n\n');

subjectName = input('What is your name? ','s');
fprintf('\n');
subjectIni = input('What is your subject ID? ','s');
fprintf('\n');
ver = 2;
fprintf('\n');
block = input('Block order (0 or 1)? ');

fprintf('\n');
fprintf('Thank you!\n');
fprintf('\n');
fprintf('\n');

doPractice = 1;
trial = 1;

while doPractice
    if trial == 1
        aaa = input('Do you want to practice (y/n) ? ','s');
    else
        aaa = input('Do you want to practice more (y/n) ? ','s');
    end
    if strcmp(aaa, 'y')
        [display,config,result] = RunPractice(subjectName,subjectIni,ver);
        clc;
    else
        doPractice = 0;
        clc;
    end
    trial = trial + 1;
end

doRunMain = 1;
trial = 1;

while doRunMain
    if trial == 1
        aaa = input('Do you want to run the main exp (y/n) ? ','s');
    else
        aaa = input('Do you want to run the main exp again (y/n) ? ','s');
    end
    
    if block
        switch trial
            case 1
                eccen = 6;
            case 2
                eccen = 10;
            case 3
                eccen = 6;
            case 4
                eccen = 10;
            case 5
                eccen = 6;
            case 6
                eccen = 10;
        end
    else
        switch trial
            case 1
                eccen = 10;
            case 2
                eccen = 6;
            case 3
                eccen = 10;
            case 4
                eccen = 6;
            case 5
                eccen = 10;
            case 6
                eccen = 6;
        end
    end
    
    if strcmp(aaa, 'y')
        [display,config,result] = RunCrowding(subjectName,subjectIni,ver,eccen);
        clc;
    else
        doRunMain = 0;
    end
    
    trial = trial + 1;
end