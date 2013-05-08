# /etc/csh.login: This file contains login defaults used by csh and tcsh.

# Set up some environment variables:
umask 022
set cdpath = ( /var/spool )
set notify
set history = 100
setenv MANPATH /usr/local/man:/usr/man/preformat:/usr/man:/usr/X11R6/man
setenv MINICOM "-c on"
setenv HOSTNAME "`cat /etc/HOSTNAME`"
setenv LESS "-M"
setenv LESSOPEN "|lesspipe.sh %s"
setenv MOZILLA_HOME /usr/lib/netscape
set path = ( $path /usr/X11R6/bin /usr/games . )

# I had problems with the backspace key installed by 'tset', but you might want
# to try it anyway, instead to the 'setenv term.....' below it.
# eval `tset -sQ "$term"`
# setenv term linux
# if ! $?TERM setenv TERM linux
# Set to "linux" for unknown term type:
if ( $TERM  == "" &&  $TERM == "unknown" && $TERM == "vt100" ) setenv TERM linux

# Set the default shell prompt:
if ( $USER == "root" ) then
	set prompt = '[\!] %/% '
else
	set prompt = '[\!] %/~> '
endif

# Set up the LS_COLORS environment variable for color ls output:
eval `dircolors -t`

# Notify user of incoming mail.  This can be overridden in the user's
# local startup file (~/.login)
biff n

# Print a fortune cookie for login shells:
# if ( { tty --silent } ) then >& /dev/null
#  echo "" ; fortune /usr/games/lib/fortunes/fortunes /usr/games/lib/fortunes/fortunes2 ; echo ""
# endif

# A mail shell valtozo beallitasa
set mail = /var/spool/mail/$user

# Eroforras hatarertekek beallitasa 
limit -h cputime 2h
limit -h memoryuse 32m
limit -h coredumpsize 512m
limit cputime 1h
limit memoryuse 32m
limit coredumpsize 256m
setenv TERM linux
