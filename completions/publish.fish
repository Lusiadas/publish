set -l cmd (status filename | command xargs basename | command cut -f 1 -d '.')

# Load dependencies
source (status filename | command xargs dirname)/../dependency.fish

# Add options completions
complete -xc $cmd -s l -l line \
-d 'For each file, set the line range to be published'
complete -xc $cmd -s b -l pastebin \
-a "($cmd -L | string match -r \"(?<=^- ).+\")" -d 'Set pastebin url'
complete -c $cmd -s e -l echo \
-d 'Print content to stdout too'
complete -xc $cmd -s f -l format \
-d 'Choose a highlighting format'
complete -c $cmd -s i -l filename \
-d 'Use filename for input'
complete -fc $cmd -n 'not contains_opts' -s L -l list \
-d 'List supported pastebins'
complete -xc $cmd -s j -l jabberid \
-d 'Set Jabber ID'
complete -xc $cmd -s m -l permatag \
-d 'Set permatag'
complete -rc $cmd -s t -l title \
-d 'For each file, set a title'
complete -c $cmd -s P -l private \
-d 'Make paste(s) private'
complete -xc $cmd -s u -l username \
-d 'Set a username'
complete -xc $cmd -s p -l password \
-d 'Set a password'
complete -fc $cmd -n 'not contains_opts' -s v -l version \
-d 'Print pastebin version'
complete -fc $cmd -n 'not contains_opts' -s h -l help \
-d 'Display instructions'
