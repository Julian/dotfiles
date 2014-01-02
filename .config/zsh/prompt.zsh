#--- Prompt ------------------------------------------------------------------

setopt PROMPT_SUBST

autoload -U colors && colors
autoload -Uz vcs_info

vcs_basic_info='is a %F{yellow}%s%f repository on %F{green}%b%f'
vcs_action_info='%F{yellow}|%f%F{red}%a%f'

zstyle ':vcs_info:*' enable git bzr hg
zstyle ':vcs_info:*' actionformats "$vcs_basic_info$vcs_action_info "
zstyle ':vcs_info:*' formats "$vcs_basic_info "
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

prompt_jobs() {
    PROMPT_JOBS=''

    running_job_count=`jobs -r | wc -l`
    stopped_job_count=`jobs -s | wc -l`

    if (( running_job_count > 0 )) ; then
        PROMPT_JOBS=" %{$fg[green]%}●%{$reset_color%}"
    fi
    if (( stopped_job_count > 0 )) ; then
        PROMPT_JOBS="$PROMPT_JOBS %{$fg[yellow]%}●%{$reset_color%}"
    fi
}

precmd () {
    prompt_jobs
    vcs_info
}

prompt_char='⊙'

if [[ -z $USE_MINI_PROMPT ]]; then
PS1='
%15<...<%~ ${vcs_info_msg_0_}
%(!.%{$fg[red]%}$prompt_char%{$reset_color%}.%{$fg[cyan]%}$prompt_char%{$reset_color%})  '
else
    PS1='%15<...<%~ $prompt_char '
fi

RPS1='%B%n%b@%m$PROMPT_JOBS'
