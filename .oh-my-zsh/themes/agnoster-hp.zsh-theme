# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](https://iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# If using with "light" variant of the Solarized color schema, set
# SOLARIZED_THEME variable to "light". If you don't specify, we'll assume
# you're using the "dark" variant.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'

case ${SOLARIZED_THEME:-dark} in
    light) CURRENT_FG='white';;
    *)     CURRENT_FG='black';;
esac

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  # Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
  SEGMENT_SEPARATOR=$'\ue0b0'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
  
  #Adds the new line and ➜ as the start character.
  printf "\n ➜";
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)%n@%m"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue $CURRENT_FG '%~'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -z $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "(`basename $virtualenv_path`)"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local -a symbols

  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}:("
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}!!⚡!!"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

# Stolen from bash
# PS1=( `sed -n 's/MemFree:[\t ]\+\([0-9]\+\) kB/\1/p' /proc/meminfo`/1024))'\033[38;5;22m/'$((`sed -n 's/MemTotal:[\t ]\+\([0-9]\+\) kB/\1/Ip' /proc/meminfo`/1024 ))MB"\t\033[m\033[38;5;55m$(< /proc/loadavg)\033[m"
prompt_sysinfo() {
  #local uptime=$((`uptime | awk '{print "Uptime: "$3" "substr($4, 0, length($4))}'`))
  if [[ "OSTYPE" == "darwin" ]]; then
    local mem_total=$((`sysctl hw.memsize | awk -F" " '{print $2}'`))
	local phys_mem=$((`sysctl hw.physmem | awk -F" " '{print $2}'`))
	local user_mem=$((`sysctl hw.usermem | awk -F" " '{print $2}'`))
	local mem_free="$mem_total" - ("$phys_mem" + "$user_mem")
	#local cores=$((`sysctl -n hw.ncpu`))
	local info="$mem_free" + "/" + "$mem_total"
	prompt_segment green white "$info"
  else
	local mem_total=$((`awk '/MemTotal/ { printf "%.f \n", $2/1024 }' /proc/meminfo`))
    local mem_free=$((`awk '/MemFree/ { printf "%.f \n", $2/1024 }' /proc/meminfo`))
	local cores=$((`cat /proc/cpuinfo | grep -c "cpu cores"`))
	local avg_load=$((`uptime | awk -F'[a-z]: ' '{print $2}' | awk -F", " '{gsub(",", ".",$1); print $1"/"cores " " $2"/"cores " " $3"/"cores}' cores="$cores"`))
  fi
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_sysinfo
  prompt_dir
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
