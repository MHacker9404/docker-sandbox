alias vci='code-insiders $1'
alias grep='grep --color=auto'
alias gg='git grep -ni'
alias phpunit='phpunit --colors'
alias vimpress="VIMENV=talk vim"
alias c="composer"
alias v="vagrant"
alias d="sudo docker"
alias biggest="du -h --max-depth=1 | sort -h"
alias tnn="cd ~/src/github.com/tomnomnom"
alias :q="exit"
alias norg="gron --ungron"
alias ungron="gron --ungron"
alias j="jobs"
alias follow="tail -f -n +1"
# https://techviewleo.com/install-and-use-dot-net-core-on-debian/
_dotnet_bash_complete()
{
  local word=${COMP_WORDS[COMP_CWORD]}

  local completions
  completions="$(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)"
  if [ $? -ne 0 ]; then
    completions=""
  fi

  COMPREPLY=( $(compgen -W "$completions" -- "$word") )
}
complete -f -F _dotnet_bash_complete dotnet