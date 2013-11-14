function obj = sliding_window(period, dur, varargin)
% SLIDING_WINDOW - Reject sliding windows with large variance

import meegpipe.node.bad_epochs.criterion.stat.stat;
import meegpipe.node.pipeline.pipeline;
import meegpipe.node.*;
import physioset.event.periodic_generator;
import datahash.DataHash;

if nargin < 1 || isempty(period),
    period = 1;
end

if nargin < 2 || isempty(dur),
    dur = 0.5*period;
end

crit = stat(...
    'ChannelStat',  @(x) var(x), ...
    'EpochStat',    @(chanVars) mean(chanVars), ...
    'Max',          @(meanVar) prctile(meanVar, 95), ...
    varargin{:});

randomEvType = ['__' DataHash(rand(1,100))];

evGen = periodic_generator(...
    'Period',   period, ...
    'Duration', dur, ...
    'Type',     randomEvType);

node1 = ev_gen.new('EventGenerator', evGen);


evSel = physioset.event.class_selector('Type', randomEvType);

node2 = bad_epochs.new(...
    'Criterion',        crit, ...
    'DeleteEvents',     true, ...
    'EventSelector',    evSel);

obj = pipeline('NodeList', {node1, node2}, ...
    'Name', 'bad_epochs.sliding_window_var');

end