function obj = initialize(obj)


import misc.get_username;
import misc.get_hostname;
import misc.get_matlabver;
import report.object.object;
import mperl.file.spec.abs2rel;
import datahash.DataHash;

% Cleanup the destination directory
[remPath remFilesPath] = def_rootpath(obj);
if exist(remPath, 'dir')
    
    % This is a re-run
    oldPath = remPath;
    if exist([oldPath '.zip'], 'file'),
        % Just in case, but should not be necessary
        delete([oldPath '.zip']);
    end
    if numel(dir(oldPath)) > 2,
        zip([oldPath '.zip'], oldPath);
        rmdir(oldPath, 's');
    end
    
end
if exist(remFilesPath, 'dir')
    
    % This is a re-run
    oldPath = remFilesPath;
    if exist([oldPath '.zip'], 'file'),
        % Just in case, but should not be necessary
        delete([oldPath '.zip']);
    end
    if numel(dir(oldPath)) > 2,
        zip([oldPath '.zip'], oldPath);
        rmdir(oldPath, 's');
    end
    
end

obj = initialize@report.generic.generic(obj);

gitMaster = meegpipe.version;

print_paragraph(obj, ...
    ['Data processing ran by user _%s_, at host %s (%s), on %s, ' ...
    'using [meegpipe][meegpipe]''s snapshot [%s][%s] on MATLAB %s.'], ...
    get_username, get_hostname, computer, ...
    datestr(now, 'dd-mm-yy HH:MM:SS'), ...
    [gitMaster(1:10) '...'], gitMaster, get_matlabver);

target = 'https://github.com/meegpipe/meegpipe';
name   = 'meegpipe';
print_link(obj, target, name);

target = sprintf(...
    'https://github.com/meegpipe/meegpipe/commit/%s', gitMaster);
name   = gitMaster;
print_link(obj, target, name);

if isempty(get_parent(obj)),
    %% Specific to top-level nodes
    
    savedNode  = abs2rel(saved_node(obj.Node_), get_save_dir(obj.Node_));
    savedInput = abs2rel(saved_input(obj.Node_), get_save_dir(obj.Node_));
    
    print_paragraph(obj, ...
        'To reproduce this analysis run:');
    
    code = {...
        'clear all;', ...
        'currDir = pwd;';
        };
    
    % Installation
    installDir = DataHash(randn(1,100));
    installDir = ['meegpipe_' installDir(1:6)];
    
    meegpipeVersion = get_meegpipe_version(obj.Node_);
    
    code = [code ...
        {...
        sprintf('mkdir %s;', installDir), ...
        sprintf('cd %s;', installDir), ...
        'system(''git clone git://github.com/meegpipe/meegpipe'');', ...
        'cd meegpipe;', ...     
        sprintf('system(''git checkout %s'');', meegpipeVersion), ...        
        sprintf('cd(''%s'');', get_save_dir(obj.Node_)), ...
        sprintf('node = load(''%s'', ''obj'');', savedNode), ...
        sprintf('input = load(''%s'', ''data'');', savedInput), ...
        'cd(currDir)', ...
        'meegpipe.initialize;', ...
        'output = run(node.obj, input.data);' ...
        } ...
        ];
    
    print_code(obj, code{:});
    
    print_paragraph(obj, ...
        ['__Note:__ You may need to change the absolute path above if ' ...
        'this report has been moved from its original location']);
    
end

% Print sub-report with the node properties

subReport = object(obj.Node_, 'Title', 'Node properties');
subReport = childof(subReport, obj);

generate(subReport);

print_paragraph(obj, whatfor(obj.Node_));

end