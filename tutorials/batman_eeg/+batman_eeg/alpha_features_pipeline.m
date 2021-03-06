function myPipe = alpha_features_pipeline(varargin)

import meegpipe.*;

import pset.selector.sensor_class;
import pset.selector.cascade;
import pset.selector.good_data;

USE_OGE = true;
DO_REPORT = true;
QUEUE = 'short.q';

nodeList = {};

%% Import
myImporter = physioset.import.physioset;
myNode = node.physioset_import.new('Importer', myImporter);
nodeList = [nodeList {myNode}];

%% copy data
% We create a temporary on the LOCAL temp dir. This should speed up
% processing considerably when the job is running at a node other than
% somerenserver (where the raw data is located).
myNode = node.copy.new('Path', @() tempdir);
nodeList = [nodeList {myNode}];

%% A BSS node that picks alpha components and extracts features from them
myFeat = spt.feature.psd_peak('TargetBand', [7 12]);
    
myCrit = spt.criterion.threshold(myFeat, ...
    'Max', @(feat) median(feat)+mad(feat), 'MaxCard', 10);
mySel = pset.selector.cascade(...
    pset.selector.sensor_class('Class', 'EEG'), ...
    pset.selector.good_data);

myPCA = spt.pca(...
    'RetainedVar',  99.75, ...
    'MaxCard',      35);

myPSDRatioFeat = spt.feature.psd_ratio(...
    'TargetBand',       [7 12], ...
    'RefBand',          [1 6; 15 35], ...
    'TargetBandStat',   @(power) max(power), ...
    'RefBandStat',      @(power) mean(power) ...
    );

myFeat = {spt.feature.brainloc, spt.feature.topo_full,...
    spt.feature.psd_peak('TargetBand', [7 12]), ...
    myPSDRatioFeat, ...
    spt.feature.thilbert('Filter', @(sr) filter.bpfilt('Fp', [7 13]/(sr/2)))};
myNode = node.bss.new(...
    'PCA',          myPCA, ...
    'DataSelector', mySel, ...
    'Criterion',    myCrit, ...
    'Feature',      myFeat, ...
    'FeatureTarget', 'selected', ...
    'Reject',       false, ...
    'IOReport',     report.plotter.io);
nodeList = [nodeList {myNode}];

%% Pipeline
myPipe = node.pipeline.new(...
    'NodeList',         nodeList, ...
    'Save',             true, ...
    'Parallelize',      USE_OGE, ...
    'GenerateReport',   DO_REPORT, ...
    'Name',             'alpha_features_pipe', ...
    'Queue',            QUEUE, ...
    'TempDir',          @() tempdir, ... 
    varargin{:} ...
    );

end