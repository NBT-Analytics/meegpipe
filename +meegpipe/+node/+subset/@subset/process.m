function [dataOut, dataNew] = process(obj, dataIn, varargin)
% PROCESS - Select data subset
%
% See also: subset


import mperl.file.spec.catfile;
import goo.globals;

dataNew = [];

subsetSelector  = get_config(obj, 'SubsetSelector');

verbose          = is_verbose(obj);
verboseLabel     = get_verbose_label(obj);
origVerboseLabel = globals.get.VerboseLabel;
globals.set('VerboseLabel', verboseLabel);

fileName = catfile(get_full_dir(obj), get_name(dataIn)); 

if verbose,
   fprintf([verboseLabel 'Extracting subset from %s ...\n\n'], ...
       get_name(dataIn)); 
end

dataOut  = subset(dataIn, subsetSelector, ...
    'FileName', fileName, ...
    'Temporary', true);


%% Undo stuff
globals.set('VerboseLabel', origVerboseLabel);


end