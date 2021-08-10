set -l cmd (command basename (status -f) | command cut -f 1 -d '.')
function $cmd -V cmd -d "Publish the contents of the clipboard, a file or several, in its entirety or partially, in a pastebin"

  # Load dependencies
  source (dirname (status -f))/../dependency.fish -n publish grep pastebinit \
  (type -qf termux-info; or echo xclip)
  or return 1
  set -l clipboard_in 'xclip -selection "clipboard"'
  set -l clipboard_out 'xclip -selection "clipboard" -o'
  if type -qf termux-info
    if not dpkg -s termux-api >/dev/null 2>&1
      err "$cmd: |termux-api| is required to manage clipboard content."
      reg "See installation instructions for it at https://wiki.termux.com/wiki/Termux:API"
      return 1
    end
    set clipboard_in 'termux-clipboard-set'
    set clipboard_out 'termux-clipboard-get'
  end

  # Parse flags
  set -l flags
  if argparse -n $cmd -x (string join -- ' -x ' L,v,h {L,v,h},{l,b,e,f,i,j,m,t,P,u,p} | string split ' ') 'l/lines=+' 'a/author=' 'b/pastebin=' 'e/echo' 'f/format=' 'h/help' 'i/filename' 'L/list' 'j/jabberid=' 'm/permatag=' 't/title=+' 'P/private' 'u/username=' 'p/password=' 'v/version' -- $argv 2>&1 | read err
    err $err
    reg "Use |$cmd -h| to see examples of valid syntaxes"
    return 1
  end
  if set flags (set --names | string match -r '(?<=^_flag_)[hvL]$')
    contains h $flags
    and source (dirname (status -f))/../instructions.fish
    or command pastebinit -(string lower $flags) 2>/dev/null
    test -z "$argv"
    return $status
  else if set --names | string match -qr '^_flag_.+'
    set --query _flag_author
    and set _flag_a -a $_flag_a
    set --query _flag_pastebin
    and set _flag_b -b $_flag_b
    set --query _flag_echo
    and set _flag_e -E
    set --query _flag_format
    and set _flag_f -f $_flag_f
    set --query _flag_jabberid
    and set _flag_j -j $_flag_j
    set --query _flag_permatag
    and set _flag_m -m $_flag_m
    set --query _flag_title
    and set -l titles -t\ {(string join , $_flag_title)}
    set --query _flag_username
    and set _flag_u -u $_flag_u
    set --query _flag_password
    and set _flag_p -p $_flag_p
    set flags $_flag_a $_flag_b $_flag_e $_flag_f $_flag_i \
    $_flag_j $_flag_m $_flag_P $_flag_u $_flag_p
  end

  # Add content passed through the stdin or clipboard as a temp file argument
  set -l tmp (command mktemp)
  if not isatty
    while read -l line
      echo $line >> $tmp
    end
    set -a argv $tmp
  end
  if test -z "$argv" -o (count $_flag_lines) -gt (count $argv)
    if eval $clipboard_out | not string length -q
      test (count $_flag_lines) -gt (count $argv)
      and  err "$cmd: $_flag_lines: No file specified for line range"
      or err "$cmd: No file specified nor clipboard content available to publish"
      return 1
    end
    read -n 1 -p 'wrn -n "Clipboard content available. Publish it? [y/n]: "' \
    | string match -qir y
    or return 1
    eval $clipboard_out > $tmp
    set argv $tmp
  end

  # Check line range validity
  if set -l invalid (string match -er '[^0-9,-]' $_flag_lines)
    test (count $invalid) -gt 1
    and set invalid "s |"(string join '|, |' $invalid)"|"
    or set invalid " |$invalid|"
    err "$cmd: Invalid line description$invalid"
    source (dirname (status -f))/../instructions.fish "$cmd -l/--lines"
    return 1
  else
    for i in (command seq (count $_flag_lines))
      set _flag_lines[$i] (string replace -a '-' '..' $_flag_lines[$i] \
      | string replace -a ',' ' ')
    end
  end

  # Upload content
  set -l failed
  for i in (command seq (count $argv))

    # Load file
    if not test -e "$argv[$i]"
      err "$cmd: file |$argv[$i]| not found"
      set failed true
      continue
    end
    set -l content (command cat "$argv[$i]")
    test -n "$_flag_lines[$i]"
    and set content $content[$_flag_lines[$i]]

    # Check connection
    set -l url
    if not printf '%s\n' $content \
    | command pastebinit $flags $titles[$i] 2>"$PREFIX"/tmp/{$cmd}_err \
    | read url
      set -l message (sed -n \$p "$PREFIX"/tmp/{$cmd}_err)
      string match -qr -- "/tmp/.+" "$argv[$i]"
      and err "$cmd: Failed to send content"
      or err "$cmd: Failed to send file |"(basename $argv[$i])"|"
      reg $message
      command rm "$PREFIX"/tmp/{$cmd}_err
      set failed true
      continue
    end

    # Check if content was refused
    if string match -qr '\.\w+/?$' $url
      string match -qr -- "^$PREFIX/tmp/" "$argv[$i]"
      and err "$cmd: Content flagged as spam."
      or err "$cmd: Contents of file |"(basename $argv[$i])"| flagged as spam."
      test (printf '%s\n' $content | wc -l) -lt 3
      and reg "Try to have at least tree lines of content for eash paste"
      set failed true
      continue
    end

    # Present content URL
    if string match -qr -- "^$PREFIX/tmp/" "$argv[$i]"
      test -n "$title[$i]"
      and reg "Content pasted at |$url| with title |$title[$i]|" 2>&1
      or reg "Content pasted at |$url|" 2>&1
    else
      test -n "$title[$i]"
      and reg "File |"(basename $argv[$i])"| pasted at |$url| with title |$title[$i]|" 2>&1
      or reg "File |"(basename $argv[$i])"| pasted at |$url|" 2>&1
    end
    test (count $argv) -eq 1
    or continue
    echo $url | eval $clipboard_in
    win "URL copied to clipboard"
  end
  command rm $tmp
  test -z "$failed"
end
