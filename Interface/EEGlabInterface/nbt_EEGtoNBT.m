%  [Signal, SignalInfo]=nbt_EEGtoNBT(EEG, filename, FileExt)
%  convert EEG struct into NBT Signal (in workspace)
%
%  Usage:
%  [Signal, SignalInfo]=nbt_EEGtoNBT(EEG, filename, FileExt)
%
% Inputs:
%   EEG
%   filename
%   FileExt
%
% Output:
%   Signal
%   SignalInfo
%
% See also:
%   nbt_NBTtoEEG

%--------------------------------------------------------------------------
% Copyright (C) 2008  Neuronal Oscillations and Cognition group, 
% Department of Integrative Neurophysiology, Center for Neurogenomics and 
% Cognitive Research, Neuroscience Campus Amsterdam, VU University Amsterdam.
%
% Part of the Neurophysiological Biomarker Toolbox (NBT)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
% See Readme.txt for additional copyright information.
%--------------------------------------------------------------------------


function [Signal, SignalInfo]=nbt_EEGtoNBT(EEG, filename, FileExt)

EEG = eeg_checkset(EEG(1));
EEG.history = [];

Signal = double(EEG.data');
EEG.data =[];
EEG.icaact = [];

if isfield(EEG,'NBTinfo')
    SignalInfo=EEG.NBTinfo;
    EEG=rmfield(EEG,'NBTinfo');
else
    SignalInfo=nbt_CreateInfoObject(filename, FileExt, EEG.srate);
end

SignalInfo.interface.EEG = EEG;
end