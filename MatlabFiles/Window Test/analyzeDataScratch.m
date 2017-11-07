%%
d = dir(pwd);
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

%Sort Folders by MS
s = sprintf('%s ', nameFolds{:});
foldVals = sscanf(s, '%gMS');
[sortedVals, sortIndex] = sort(foldVals);
sortedNames = nameFolds(sortIndex);

%%
%Pull 
%PLOT Filtered Data and Display Data for each trial
%   Also get stddev data and avgs data
stdDevs = zeros(numel(nameFolds),1);
avgs = zeros(numel(nameFolds),1);

figure
for i = 1:numel(nameFolds)
    name = sortedNames{i};
    [r,f,d, rmvc, fmvc] = getFilenames(name);
    data = getDataFromFiles(r, f, d, rmvc, fmvc);    
    
    %scale data to MVCs
    mvcs = getMVCValue(fmvc);
    r = data{2};
    f = data{4};
    r = r / mvcs(1,1) * 100;
    f = f / mvcs(1,1) * 100;
    %get MVC Values to scale data
    
    fTrim = f(1000:numel(f)-1000);
    stdDevs(i) = std(fTrim);
    avgs(i) = mean(fTrim);
   
    %plot raw, filt, and disp on figure
    subplot(numel(nameFolds)/2,2,i);
    %plot(data{1}, r, 'b')
    hold on
    plot(data{3}, f, 'r')
    ylim([0,60]);
    plot(data{5}, data{6}, 'g')
    plot([0 data{3}(end)], [10 10], 'k');
    hold off
    title(name);

    %plotEMGData(name, data{1}, data{2}, data{3}, data{4}, data{5}, data{6});
end


%Plot Display Avg Vs Moving Avg
figure




%Plot
stdDevs = std(fTrim, 0, 2);
avgs = mean(fTrim,0,2);
figure

plot(sortedVals, stdDevs, '-o');
title('Standard Deviation (red) and Mean (blue) by Window Size');
hold on;
plot(sortedVals, avgs, '-*');
hold off;
%title('Average EMG Value by Window Size');
%make separate figure with 
