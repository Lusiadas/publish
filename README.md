[![GPL License](https://img.shields.io/badge/license-GPL-blue.svg?longCache=true&style=flat-square)](/LICENSE)
[![Fish Shell Version](https://img.shields.io/badge/fish-v2.7.1-blue.svg?style=flat-square)](https://fishshell.com)
[![Oh My Fish Framework](https://img.shields.io/badge/Oh%20My%20Fish-Framework-007EC7.svg?style=flat-square)](https://www.github.com/oh-my-fish/oh-my-fish)

# publish

> A plugin for [Oh My Fish](https://www.github.com/oh-my-fish/oh-my-fish)

A wrapper function for [pastebinit](https://launchpad.net/pastebinit), allowing it to publish multiple files in sequece while also choosing which lines of those to send. By not specifying a target file, or passing content through a pipe, the contents of the clipboard are uploaded instead. This function is fully compatible with [termux](termux.com) as well.

## Example usage
[![asciicast](https://asciinema.org/a/chd0kvdSdtw33CWMzn5vsM3tS.png)](https://asciinema.org/a/chd0kvdSdtw33CWMzn5vsM3tS)

## Options
```
-l/--lines [0-7,8,9]
For each file, set the line range to be published

-a/--author [author]
Set author name. Default is $USER

-b/--pastebin [url]]
Set pastebin url. Default is distro specific with fallback to pastebin.

-e/--echo
Print content to stdout too

-f/--format [format]
Choose a highlighting format (check pastebin's website for complete list, example: python). Default is "text".

-h/--help
Display these instructions

-i/--filename
Use filename for input

-L/--list
List supported pastebins

-j/--jabberid [id]
Set Jabber ID

-m/--permatag [permatag]
Set permatag

-t/--title [title]
For each file, set a title

-P/--private [0/1]
Make paste(s) private

-u/--username [username]
Set a username

-p/--password [password]
Set a password

-v/--version
Print pastebinit version
```

## Install

```fish
omf repositories add https://gitlab.com/argonautica/argonautica 
omf install publish
```

### Dependencies

If you don't have these dependencies already installed, you'll be prompted to do so upon installaling `publish`:

`pastebinit feedback contains_opts [xclip/termux-api]`

To properly install `termux-api`, see its [installation instructions](https://wiki.termux.com/wiki/Termux:API).
