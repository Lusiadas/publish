set -l bld (set_color 00afff -o)
set -l reg (set_color normal)
set -l instructions $bld"publish

"$bld"DESCRIPTION

A wrapper function for "$bld"pastebinit"$reg" to publish the contents of the clipboard, a file or several, in its entirety or partially. By not especifying a target file, or passing text through a pipe (|), the contents of the clipboard can be uploaded instead

"$bld"SYNOPSIS

"$bld"publish"$reg" [OPTIONS] [FILE] ...

"$bld"OPTIONS
(not all options are supported by all pastebins)

"$bld"-l/--lines"$reg" [0-7,8,9]
For each file, set the line range to be published

"$bld"-a/--author"$reg" [author]
Set author name. Default is $USER

"$bld"-b/--pastebin"$reg" [url]
Set pastebin url. Default is distro specific with fallback to pastebin.

"$bld"-e/--echo
Print content to stdout too

"$bld"-f/--format"$reg" [format]
Choose a highlighting format (check pastebin's website for complete list, example: python). Default is "text".

"$bld"-h/--help
Display these instructions

"$bld"-i/--filename
Use filename for input

"$bld"-L/--list
List supported pastebins

"$bld"-j/--jabberid"$reg" [id]
Set Jabber ID

"$bld"-m/--permatag"$reg" [permatag]
Set permatag

"$bld"-t/--title"$reg" [title]
For each file, set a title

"$bld"-P/--private"$reg" [0/1]
Make paste(s) private

"$bld"-u/--username"$reg" [username]
Set a username

"$bld"-p/--password"$reg" [password]
Set a password

"$bld"-v/--version"$reg"
Print pastebinit version

"$bld"EXAMPLE USES

"$bld"publish"$reg"
# Upload the contents of the clipboard

"$bld"publish"$reg" -l 1-3,5,7-9 file1.txt -l 11-13,15 file2.txt
# Paste listed line ranges from each file
"
test "$argv"
and echo $instructions | grep -A 1 -E $argv 1>&2
or echo $instructions | less -R
