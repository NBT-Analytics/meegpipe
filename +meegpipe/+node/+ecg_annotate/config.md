`config` for node `ecg_annotate`
===


This class is a helper class that implements consistency checks
necessary for building a valid [ecg_annotate][ecg_annotate] node.

[ecg_annotate]: ./README.md

## Usage synopsis

Enforce the ECG annotation to be performed at a Virtual Machine (VM) with a 
fixed URL, instead of attempting to start a new VM locally:

````matlab
import meegpipe.node.*;
myConfig = ecg_annotate.config('VMUrl', '192.87.10.186');
myNode   = ecg_annotate.new(myConfig);
````

Altenatively, the following syntax is equivalent, and preferable for being
more concise:

````matlab
import meegpipe.node.*;
myNode = ecg_annotate.new('VMUrl', '192.87.10.186');
````

## Configuration properties


The following construction options are accepted by the constructor of
this config class, and thus by the constructor of the `ecg_annotate` node
class:

### `EventSelector`

__Class__: `cell` array of `physioset.event.selector`

__Default__: `[]`


This object will be used to group the events in the input physioset into 
various experimental groups or conditions. Set `EventSelector` to `[]` if
no grouping is to be performed. 

Consider the case that there are three types of experimental blocks:

* __Dark__ condition: identified with events of types `dark-pre`, `dark`, 
  `dark-post`
* __Red__ condition: identified with events of type `red`
* __Blue__ condtion: identified with evetns of type `blue`

If we wanted to estimate heart rate variability (HRV) features for the 
three conditions above, we should build the following `ecg_annotate` node:

````matlab
import physioset.event.class_selector;
import meegpipe.node.*; 

% Will select all events corresponding to the dark condition
selDark = class_selector('Type', 'dark', 'Name', 'dark');

% Selectors for the blue and red conditions:
selBlue = class_selector('Type', '^blue$', 'Name', 'blue');
selRed  = class_selector('Type', '^red$', 'Name', 'red');

myNode = ecg_annotate.new('EventSelector', {selDark, selBlue, selRed});
````

Note that we used property `Name` of each selector to provide a meaningful 
name for each experimental condition. This name will be used to identify 
the condition in the generated features table (see the data processing
report).


### `VMUrl`

__Class__: `string`

__Default__: `''`

The IP address of the VM that will be used to run `ecgpuwave`. If this 
option is not provided, the node will attempt to start a new VM locally.