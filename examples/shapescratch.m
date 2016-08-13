cd ~/Documents/BLAM/Psychoobox
addpath classes

testrect = Rectangle();
properties(testrect)

tmp = struct;
[tmp(1:5).fill_color] = deal([33 4 55; 66 77 88; 10 21 1; 66 55 23]');
size(tmp(1).fill_color)
for ii = 1:4
    tmp(ii).test2 = tmp(1).fill_color(:, ii);
end
[tmp.test2]

% dealing one row per
[tmp(1:4).test3] = deal([1 3]);
tmp.test3

%testrect.Add(1:4, 'fill_color', [33 44 55]')
ss.test(2,:) = nan(2,1)
aa([1,3,5], 1:2) = nan(1,2)
