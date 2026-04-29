#!/usr/bin/env bash
# Tab completion for the `k` alias from kubectl-aliases.
#
# Setup (bash): add to ~/.bashrc:
#   source /path/to/kubectl_aliases_completion.sh
#
# Setup (zsh): add to ~/.zshrc:
#   autoload -U +X bashcompinit && bashcompinit
#   source /path/to/kubectl_aliases_completion.sh

_k_complete() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    local actions="help cg cs cl cd ng ns nl pl gp sh dl ds dd l lf pf jobs job"
    local job_subs="describe trigger suspend resume"
    local jobs_subs="history"

    case ${COMP_CWORD} in
        1)
            COMPREPLY=( $(compgen -W "$actions" -- "$cur") )
            ;;
        2)
            case "$prev" in
                job)  COMPREPLY=( $(compgen -W "$job_subs"  -- "$cur") );;
                jobs) COMPREPLY=( $(compgen -W "$jobs_subs" -- "$cur") );;
            esac
            ;;
    esac
}

complete -F _k_complete k
