clc;
clear all;
randomValue = rand() * 30; %for generating a random value between 0 to 30
oldSerial = instrfind()
if (~isempty(oldSerial))
    disp("Warning in Use")
    delete(oldSerial)
end

distanceArray = [];

% Define the serial port
serialPortName = 'COM5';  % Change this to the appropriate serial port for your Arduino
disp(serialportlist)

% Open the serial port
serialPortNew = serialport();
%set(serialPortNew,'BaudRate', 2000000);
get(serialPortNew)
fopen(serialPortNew);

while true
       if serialPortNew.NumBytesAvailable > 0
            distance = str2double(readline(serialPortNew)); %in serial port its initially in string format so to convert it to numerical this is used
            scatter(randomValue, 0, 100, 'blue', 'o', 'filled');
            xlim([0, 30]);
            ylim([-10, 10]);
            %title('Random X Value Scatter Plot');
            %xlabel('X Axis');
            disp(randomValue);
            drawnow;
            hold on;
            if(distance > 0 && distance < 1000)
                distanceArray = vertcat(distanceArray,distance);
                scatter(distance, 0, 'red', 'o', 'filled');
                xlim([0,30]);
                ylim([-10,10]);
                drawnow;
                hold off;
            end
        end
        %pause(0.1);  % delay
end

delete serialPortNew;
clear serialPortNew;
