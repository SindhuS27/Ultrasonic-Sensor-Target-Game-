clc;
clear all;
close all;
oldSerial = instrfind();
if (~isempty(oldSerial))
    delete(oldSerial);
    clear ("randomValue");
end

% Define the serial port
serialPortName = 'COM5';  %serial port for Arduino
disp(serialportlist);

% Open the serial port
serialPortNew = serialport();
get(serialPortNew);
fopen(serialPortNew);

timeThreshold=10; %time threshold (in seconds) for newDistance to reach randomValue
startTime=tic; % function to start a timer and assigns the current time to the variable
isFirstTime = true;

while true
       if ~exist('randomValue', 'var') || toc(startTime) > timeThreshold %checks if randomValue doesn't exist or if the elapsed time since startTime exceeds the specified timeThreshold
            randomValue = rand() * 30;  % Generate a new random value
            disp(['New Target: ', num2str(randomValue)]);
            startTime = tic;  % Reset the timer
       end

       if serialPortNew.NumBytesAvailable > 0
            distance = str2double(readline(serialPortNew)); %in serial port its initially in string format so to convert it to numerical this is used
            scatter(randomValue, 0, 150, "red", 'o', 'filled');
            xlim([0, 30]);
            ylim([-10, 10]);
            %disp(randomValue);
            drawnow;
            hold on;
            if(distance > 0 && distance < 50)
                %fprintf('Distance: %.2f cm\n', distance);
                if (isFirstTime==true)
                    firstDistance= distance;
                    isFirstTime = false;
                end
                newDistance = abs(distance - firstDistance);
                scatter(newDistance, 0, 'blue', 'filled', 'o');
                xlim([0,30]);
                ylim([-10,10]);
                drawnow;
                hold off;
                if abs(newDistance - randomValue) <= 0.5 %target range
                    disp('TARGET REACHED');
                    break;  % Exit the loop
                end
            end
        end
        %pause(0.1);  % delay
end

delete serialPortNew;
clear serialPortNew;