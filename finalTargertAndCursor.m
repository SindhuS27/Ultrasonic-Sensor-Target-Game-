clc;
clear all;
close all;
oldSerial = instrfind();
if (~isempty(oldSerial))
    delete(oldSerial);
    clear ("randomValue");
end

% Define the serial port
serialPortName = 'COM5';  %Serial port for Arduino
disp(serialportlist); %Serial port properties are displayed in command window

% Open the serial port
serialPortNew = serialport();
get(serialPortNew); %to get serialport
fopen(serialPortNew); %then opens the serial port

timeThreshold = 10; % Time threshold (in seconds) for newDistance to reach randomValue
numAttempts = 5;    % Number of attempts to reach the target
l_min = 5; %min range for generating random value
l_max = 25; %max range for generating random value

while numAttempts > 0 %this loop with run until the attempts becomes zero
    clear newDistance; %this clears the newDistance variable when till the loop runs
    randomValue = l_min + rand() * (l_max - l_min);  % Generate a new random value
    disp(['New Target: ', num2str(randomValue)]); %this displays the new target assigned in command window
    
    startTime = tic;  % Reset the timer
    isFirstTime = true; %assigns the first element value as true boolean
    targetReached = false;  % Flag to track if target is reached within time

    while true
        if toc(startTime) > timeThreshold %Elapsed time is greater than the timeThreshold, the code will be executed
            break; %statement is used to exit a loop
        end

        if serialPortNew.NumBytesAvailable > 0 % Check if there are bytes available in the serial port
            distance = str2double(readline(serialPortNew)); % Convert the distance from string to numeric
            scatter(randomValue, 0, 150, "red", 'o', 'filled'); % scatter plot with a red filled circle with a size of 150
            xlim([0, 30]); % Set the x-axis limits to the range [0, 30]
            ylim([-10, 10]); % Set the y-axis limits to the range [-10, 10]
            drawnow; % Update the figure window immediately to display the plot
            hold on; 

            if (distance > 0 && distance < 50) %executes only if the distance is greater then 0 and less than 50
                if isFirstTime %if the boolean is true this loop executes
                    firstDistance = distance; %the first distance is taken as ditance 
                    isFirstTime = false; %then the boolen is turned false 
                end

                newDistance = abs(distance - firstDistance); % new variable created to calculate diff between the current distance and the first distance
                scatter(newDistance, 0, 'blue', 'filled', 'o'); %scatter plot with blue filled circle
                xlim([0, 30]); % x-axes limits
                ylim([-10, 10]); % y-axes limit
                drawnow; %update figure window immediately to display plot
                hold off;

                if abs(newDistance - randomValue) <= 0.5 % Target range
                    disp('TARGET REACHED'); %this displays the comment in comment window
                    clear newDistance; %clears the variable
                    isFirstTime=true; %sets boolean to true
                    targetReached = true;  % Set the flag to indicate target reached
                    numAttempts = numAttempts - 1;  % Decrement the attempts counter
                    pause(3); %pauses for 3 seconds
                    break;  % Exit the inner loop to generate a new target
                end
            end
        end
    end
    if (targetReached==false) %executes when the cursor doesn't reach the target 
        disp('Target not reached within given time. Stopping the program.'); %displays target end in command window
        break;  % Exit the main loop and stop the program
    end
end

delete(serialPortNew);
clear serialPortNew;
