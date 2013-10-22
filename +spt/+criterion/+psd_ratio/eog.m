function obj = eog(varargin)


import spt.criterion.psd_ratio.psd_ratio;

obj = psd_ratio( ...
    'Band1',        [0.25 6], ...
    'Band2',        [6 13;20 40], ...
    'Max',          25, ...
    'MinCard',      2, ...
    'MaxCard',      @(d) ceil(0.25*d), ...
    varargin{:}     ...
    );


end