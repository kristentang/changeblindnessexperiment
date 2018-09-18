function [r_pID, r_pInitials, r_pGender, r_pAge] = GetUserInfo()

userInput = input('\n\nAre you ready to begin?\n\nPress Enter to continue.\nPress "Q" to quit the experiment.','s');
if ~isempty(userInput) && (userInput(1)=='q' || userInput(1)=='Q')
    clc;
    error('User quit');
end
clc;

disp('Thank you for participating in this experiment.');
disp(' ');
disp('This experiment is about attention and perception.');
disp(' ');
disp('Please provide some information about yourself before we begin.');

clc;
pID = [];
while isempty(pID)
    userInput = input('\n\nWhat is the last 4 digits of your university ID?\n\nResponse: ','s');
    clc;
    pID = str2num(userInput);
    if isempty(pID)
        disp('Please enter a non-numeric value.');
    else
        pID = round(pID);
    end
end
clc;
pInitials = [];
while isempty(pInitials)
    userInput = input('\n\nWhat are your initials?\n\nResponse: ','s');
    clc;
    pInitials = userInput;
end

pGender = [];
while isempty(pGender)
    userInput = input('\n\nWhat is your gender (M,F,I)?\n\nResponse: ','s');
    clc;
    if isempty(userInput)
        disp('Please provide a response.');
    elseif ~(upper(userInput(1)) == 'M' || upper(userInput(1)) == 'F' || upper(userInput(1)) == 'I')
        disp('Please provide a valid response.');
    else pGender = upper(userInput(1));
    end
end

pAge = [];
while isempty(pAge)
    userInput = input('\n\nWhat is your age?\n\nResponse: ','s');
    clc;
    pAge = str2num(userInput);
    if isempty(pAge)
        disp('Please enter a non-numeric value.');
    elseif pAge <=0
        disp('Please enter a number greater than zero.');
        pAge= [];
    else
        pAge = round(pAge);
    end
end

clc;
input('\n\nThank you.\n\nPress Enter to begin...','s');
clc;

r_pID = pID;
r_pInitials = pInitials;
r_pGender = pGender;
r_pAge = pAge;




end 