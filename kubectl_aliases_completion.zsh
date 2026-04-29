#compdef k
# Native zsh completion for the `k` alias from kubectl-aliases.
#
# Setup: add to ~/.zshrc:
#   autoload -Uz compinit && compinit
#   fpath=(/path/to/kubectl-aliases $fpath)
# Then place this file in that directory named `_k`, OR source it directly:
#   source /path/to/kubectl_aliases_completion.zsh

_k() {
    local -a actions job_subs jobs_subs
    actions=(
        'help:Show help message'
        'cg:Context Get'
        'cs:Context Set'
        'cl:Context List'
        'cd:Context Describe'
        'ng:Namespace Get'
        'ns:Namespace Set'
        'nl:Namespace List'
        'pl:Pods List'
        'gp:Pods List'
        'sh:Shell into pod'
        'dl:Deployments List'
        'ds:Deployment Scale'
        'dd:Deployment Describe'
        'l:Get last logs from pod'
        'lf:Follow logs from pod'
        'pf:Port forward to pod'
        'jobs:List cronjobs'
        'job:Manage a cronjob'
    )
    job_subs=(
        'describe:Describe a cronjob'
        'trigger:Trigger a cronjob now'
        'suspend:Suspend a cronjob'
        'resume:Resume a suspended cronjob'
    )
    jobs_subs=(
        'history:List recent job runs'
    )

    case $CURRENT in
        2)
            _describe -t actions 'k action' actions
            ;;
        3)
            case "${words[2]}" in
                job)  _describe -t job-subs  'job subcommand'  job_subs ;;
                jobs) _describe -t jobs-subs 'jobs subcommand' jobs_subs ;;
            esac
            ;;
    esac
}

compdef _k k
