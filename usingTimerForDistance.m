clc;
clear all;
close all;
randomValue = rand() * 30;
oldSerial = instrfind();
if (~isempty(oldSerial))
    disp("Warning in Use")
    delete(oldSerial)
end

distanceArray = [];
newDistanceArray=[];

% Define the serial port
serialPortName = 'COM5';  % Change this to the appropriate serial port for your Arduino
disp(serialportlist);

% Open the serial port
serialPortNew = serialport();
%set(serialPortNew,'BaudRate', 2000000);
get(serialPortNew);
fopen(serialPortNew);

timeThreshold=10; %time threshold (in seconds) for newDistance to reach randomValue
startTime=tic; % function to start a timer and assigns the current time to the variable
while true
       if ~exist('randomValue', 'var') || toc(startTime) > timeThreshold %checks if randomValue doesn't exist or if the elapsed time since startTime exceeds the specified timeThreshold
            randomValue = rand() * 30;  % Generate a new random value
            disp(['New Target: ', num2str(randomValue)]);
            startTime = tic;  % Reset the timer
       end
       if serialPortNew.NumBytesAvailable > 0
            distance = str2double(readline(serialPortNew)); %in serial port its initially in string format so to convert it to numerical this is used
            scatter(randomValue, 0, 150, "magenta", 'o', 'filled');
            xlim([0, 30]);
            ylim([-10, 10]);
            disp(randomValue);
            drawnow;
            hold on;
            if(distance > 0 && distance < 50)
                distanceArray = vertcat(distanceArray,distance);
                %fprintf('Distance: %.2f cm\n', distance);
                firstDistance= distanceArray(1);
                newDistance = abs(distance - firstDistance);
                newDistanceArray=vertcat(newDistanceArray,newDistance);
                scatter(newDistance, 0, 'green', 'filled', 'o');
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
