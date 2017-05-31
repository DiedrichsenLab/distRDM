function minIdx = distRDM_closestVal(val, vector)

% WIll find the closest value to val in vector 
% 'vector' and return index.

%Taking difference
diff = vector - val;

%Taking min difference
[~, minIdx] = min(abs(diff));

