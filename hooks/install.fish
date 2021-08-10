command wget -qO $path/dependency.fish \
https://gitlab.com/argonautica/dependency/raw/master/dependency.fish
source $path/dependency.fish -n $package sed grep pastebinit \
(type -qf termux-info; or echo xclip)