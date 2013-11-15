function featVal = extract_feature(obj, ~, tSeries, raw, varargin)

import misc.peakdet;
import misc.eta;
import goo.pkgisa;

if nargin < 4 || isempty(raw),
    sr = tSeries.SamplingRate;
else
    sr = raw.SamplingRate;
end

verbose      = is_verbose(obj);
verboseLabel = get_verbose_label(obj);

hpsd  = cell(size(tSeries, 1), 1);
tinit = tic;
if verbose,
    fprintf([verboseLabel 'Computing PSDs ...']);
end

for sigIter = 1:size(tSeries,1)
    [hpsd{sigIter}, freqs] = obj.Estimator(tSeries(sigIter,:), sr);
    if verbose,
        eta(tinit, size(tSeries, 1), sigIter, 'remaintime', false);
    end
end

if verbose, fprintf('\n\n'); end

if verbose,
    fprintf([verboseLabel 'Computing spectral ratios...']);
end

featVal = zeros(1, size(tSeries,1));

for sigIter = 1:size(tSeries, 1)
    % Normalized PSD  
    pf  = hpsd{sigIter};
    pf  = pf./sum(pf);
    
    % Calculate power in band of interest
    narrowBandPower = 0;
    for bandItr = 1:size(obj.Band1, 1)
        f0  = obj.Band1(bandItr, 1);
        f1  = obj.Band1(bandItr, 2);
        isInBand        = freqs>= f0 & freqs<=f1;      
        narrowBandPower = narrowBandPower + obj.Band1Stat(pf(isInBand));
    end
    
    % Calculate power in the "other" band
    otherPower = 0;
    for bandItr = 1:size(obj.Band2, 1)
        f02  = obj.Band2(bandItr, 1);
        f12  = obj.Band2(bandItr, 2);
        isOtherBand = freqs>= f02 & freqs<=f12;    
        otherPower  = otherPower + obj.Band2Stat(pf(isOtherBand));
    end
    
    featVal(sigIter) = narrowBandPower/otherPower;
    
    if verbose,
        eta(tinit, size(tSeries, 1), sigIter, 'remaintime', false);
    end   
end

if verbose, fprintf('\n\n'); end

end