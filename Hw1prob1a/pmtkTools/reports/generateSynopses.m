function generateSynopses(wikiFile)
%% Generate the synopses listing files and one line desriptions
% PMTKneedsMatlab

% This file is from pmtk3.googlecode.com

if nargin < 1
    wikiFile = fullfile(getConfigValue('PMTKlocalWikiPath'), 'synopsisPages.wiki');
end
dest = fullfile(pmtk3Root(), 'docs', 'synopsis');
googleRoot = 'http://pmtk3.googlecode.com/svn/trunk/docs/synopsis';
rootDirs = dirs(fullfile(pmtk3Root(), 'toolbox'));
ndx = cellfind(rootDirs, 'Algorithms');
if ~isempty(ndx)
   rootDirs(ndx) = [];
   rootDirs = [rootDirs; {'Algorithms'}];
end
nroot = numel(rootDirs);
wikiText = {};
for r = 1:nroot
    rd = fullfile(dest, rootDirs{r});
    if ~exist(rd, 'dir'), mkdir(rd); end
    subDirs = dirs(fullfile(pmtk3Root(), 'toolbox', rootDirs{r}));
    nsub = numel(subDirs);
    Wsub = cell(nsub, 1);
    for i = 1:nsub
        srcDir = fullfile(pmtk3Root(), 'toolbox', rootDirs{r}, subDirs{i});
        outputFile = fullfile(rd, sprintf('%s.html', subDirs{i}));
        generateSynopsisTable(srcDir, outputFile, pmtk3Root());
        if exist(outputFile, 'file') % directory might have been empty
            Wsub{i} = sprintf(' * [%s/%s/%s.html %s]', googleRoot, rootDirs{r}, subDirs{i}, subDirs{i});
        end
    end
    wikiText = [wikiText; {
        ''
        ''
        sprintf('=== {{{%s/}}} ===', rootDirs{r});
        ''
        ''
        }; Wsub];  %#ok
end
wikiText =  [{
    '#summary Synopses of all PMTK3 functions'
    sprintf('This page is auto-generated by %s.m', mfilename());
    ''
    ''
    ''
    ''
    'This page lists the folders within PMTK/toolbox and PMTK/matlabTools. Click on the link to see the list of files in that folder, with a brief description. Click on the file to see its'
    'source code, including comments on how to use it.'
    ''
    '== toolbox/ =='
    ''
    }
    wikiText
    ];

%% matlabTools
wikiText = [wikiText; {
           ''
           ''
           '== matlabTools/ =='
           ''
           }];
d = {'graph', 'graphics', 'metaTools', 'oop', 'stats', 'util'}; 
for i=1:numel(d)
   directory = fullfile(matlabToolsRoot(), d{i});
   outputFile = fullfile(dest, sprintf('%s.html', d{i}));
   generateSynopsisTable(directory, outputFile, matlabToolsRoot());
   wikiText = [wikiText; ''; {sprintf(' * [%s/%s.html %s]', googleRoot, d{i}, d{i})}]; %#ok
       
end



writeText(wikiText, wikiFile);
end
