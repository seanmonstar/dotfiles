# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

TERM="screen-256color"

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# jj-vcs

JJ_OPTS=(--ignore-working-copy --at-op=@ --no-pager)

_jj_last_op=""
_jj_cached_segment=""

__jj_prompt() {
  jj root "${JJ_OPTS[@]}" >/dev/null 2>&1 || return 0

  local red=$'\e[31m';
  local green=$'\e[32m';
  local yellow=$'\e[33m';
  local blue=$'\e[34m';
  local magenta=$'\e[35m';
  local grey=$'\e[90m';
  local reset=$'\e[0m';

  # Cache check
  local op
  op=$(jj op log "${JJ_OPTS[@]}" --limit 1 -T 'id.short()' 2>/dev/null) || return 0
  if [ "$op" = "$_jj_last_op" ]; then
    printf "%s" "$_jj_cached_segment"
    return 0
  fi
  _jj_last_op="$op"

  # --- Call 1: ids, flags, diff summary ---
  local IFS='#'
  read -r change flags diffsum < <(
    jj log "${JJ_OPTS[@]}" -r @ -T \
      "separate('#',
        change_id.shortest(),
        concat(
          if(conflict,'💥'),
          if(divergent,'🚧'),
          if(hidden,'👻'),
          if(immutable,'🔒'),
          if(!description,'✏ ')
        ),
        diff.summary()
      )" 2>/dev/null
  )

  # Parse diff summary counts
  local a d m
  a=$(grep -c '^A ' <<<"$diffsum"); d=$(grep -c '^D ' <<<"$diffsum")
  m=$(grep -Ec '^(M|R) ' <<<"$diffsum")

  # --- Branch resolution ---
  local branch
  branch=$(jj log "${JJ_OPTS[@]}" --no-graph --limit 1 \
    -r "coalesce(
          heads(::@ & bookmarks()),
          heads(::@ & remote_bookmarks()),
          heads(::@ & tags()),
          heads(@:: & bookmarks()),
          heads(@:: & remote_bookmarks()),
          heads(@:: & tags()),
          trunk()
        )" \
    -T "separate(' ', bookmarks, tags)" 2>/dev/null | cut -d' ' -f1)

  # --- Call 2: before/after counts ---
  local before after
  before=$(jj log "${JJ_OPTS[@]}" -r "@..$branch" -T '"x"' 2>/dev/null | wc -c)
  after=$(jj log "${JJ_OPTS[@]}" -r "$branch..@" -T '"x"' 2>/dev/null | wc -c)

  # --- Call 3: remote tracking ---
  local ahead behind ahead_plus behind_plus
  read -r _ ahead behind ahead_plus behind_plus < <(
    jj bookmark list "${JJ_OPTS[@]}" -r "$branch" -T \
      "if(remote,
         separate(' ',
           name ++ '@' ++ remote,
           coalesce(tracking_ahead_count.exact(),tracking_ahead_count.lower()),
           coalesce(tracking_behind_count.exact(),tracking_behind_count.lower()),
           if(tracking_ahead_count.exact(),'0','+'),
           if(tracking_behind_count.exact(),'0','+')
         ) ++ '\n'
       )" 2>/dev/null
  )

  # --- Assemble segment ---
  local seg=""
  [ -n "$branch" ] && seg+="${green}${branch}${reset}"
  [ "$before" -gt 0 ] && seg+=" ‹$before"
  [ "$after"  -gt 0 ] && seg+=" ›$after"

  [ -n "$behind" ] && [ "$behind" != "0" ] && seg+=" ⇣${behind}${behind_plus}"
  [ -n "$ahead"  ] && [ "$ahead"  != "0" ] && seg+=" ⇡${ahead}${ahead_plus}"

  seg+=" ${magenta}${change}${reset}${flags:+ $red$flags$reset}"
  [ "$a" -gt 0 ] && seg+=" ${green}+${a}${reset}"
  [ "$d" -gt 0 ] && seg+=" ${red}-${d}${reset}"
  [ "$m" -gt 0 ] && seg+=" ${yellow}^${m}${reset}"

  _jj_cached_segment="$seg"
  printf "%s" "$seg"
}

#PS1=' \[\033[34m\]\w\[\033[00m\] ($(__jj_prompt)) \[\033[00m\]\$ '

# /jj

# Show an asterisk or symbol when working tree has uncommited changes
GIT_PS1_SHOWDIRTYSTATE=true

if [ "$color_prompt" = yes ]; then
	PS1=' \[\033[34m\]\w\[\033[33m\]$(__git_ps1 " (%s)") \[\033[00m\]\$ '
else
	PS1='\w$(__git_ps1 " [%s] ")\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias tmux='TERM=screen-256color tmux -2'
alias ta='tmux attach -d || tmux'
alias t='cargo test'

alias rg='rg --sort-files'
alias ddu='du -d 2 -h -t 100M'
alias dutree='dutree -d 2 -a 100M'

export RUSTUP_USE_REQWEST=1
export CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

# nodejs/npm/nvm/fnm
if command -v fnm &> /dev/null; then
    eval "$(fnm env)"
    alias nvm=fnm
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
#source ~/.virtualenvwrapper.sh

source <(COMPLETE=bash jj)

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# added by travis gem
[ -f /home/sean/.travis/travis.sh ] && source /home/sean/.travis/travis.sh

export PATH="$HOME/.yarn/bin:$PATH"
