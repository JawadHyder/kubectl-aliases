#!/bin/bash

ACTION=$1
PARAM1=$2
PARAM2=$3
PARAM3=$4

function help() {
    # Display Help
    echo "# Help"
    echo
    echo "Syntax: k [action] [...params]"
    echo
    echo "Actions:"
    echo "  Help"
    echo "    help    | See this help message"
    echo
    echo "  Context"
    echo "    cg      | Context Get: Get current context"
    echo "    cs <c>  | Context Set: Set current context. Params: [c=context name]"
    echo "    cl      | Context List: List all available contexts"
    echo "    cd      | Context Describe: Show context details"
    echo
    echo "  Namespace"
    echo "    ng      | Namespace Get: Get current namespace"
    echo "    ns      | Namespace Set: Set current namespace"
    echo "    nl      | Namespace List: List all available namespaces"
    echo
    echo "  Pods"
    echo "    pl/gp   | Pods List: Get Pods in current namespace"
    echo "    sh <p>  | shell: Get shell access to pod. Params: [p=pod name]"
    echo
    echo "  Deployments"
    echo "    dl      | Deployments List: Get list of deployments in current namespace"
    echo "    ds <d> <n> | Deployment Scale: Scale a deployment. Params: [d=deployment name] [n=number of replicas]"
    echo "    dd <d>  | Deployment Describe: Describe a deployment. Params: [d=deployment name]"
    echo
    echo "  Logs"
    echo "    l  <p> | Get last logs from the pod. Params: [p=pod name]"
    echo "    lf <p> | Follow logs from the pod. Params: [p=pod name]"
    echo
    echo "  Port forwarding"
    echo "    pf <p> <l> <t> | Forward host port to pod's port. Params: [p=pod name] [l=local port] [t=pod's port]"
    echo
    echo "  Jobs (CronJobs)"
    echo "    jobs                  | List cronjobs in current namespace"
    echo "    jobs history          | List recent job runs"
    echo "    job describe <j>      | Describe a cronjob"
    echo "    job trigger <j>       | Trigger a cronjob now (creates a one-off Job)"
    echo "    job suspend <j>       | Suspend a cronjob"
    echo "    job resume <j>        | Resume a suspended cronjob"
}

function help_hint () {
	help
}

function require_params_1() {
  if [ -z "$PARAM1" ]; then
  	echo "Invalid pameters. Action requires at least 1 parameter."
  	help_hint
  	exit 1;
  fi
}

function require_params_2() {
  if [ -z "$PARAM1" ] || [ -z "$PARAM2" ]; then
  	echo "Invalid pameters. Action requires at least 2 parameters."
  	help_hint
  	exit 1;
  fi
}

function require_params_3() {
  if [ -z "$PARAM1" ] || [ -z "$PARAM2" ] || [ -z "$PARAM3" ]; then
    echo "Invalid pameters. Action requires at least 3 parameters."
    help_hint
    exit 1;
  fi
}

case $ACTION in

# Context related actions
  cg)
    kubectl config current-context
    ;;
  cs)
    require_params_1
    kubectl config use-context "$PARAM1"
    ;;
  cl)
    kubectl config get-contexts
    ;;
  cd)
    kubectl config view --minify
    ;;

# Namespace related actions
  ng)
    kubectl config view --minify | grep namespace
    ;;
  ns)
    require_params_1
    kubectl config set-context --current --namespace=$PARAM1
    ;;
  nl)
    kubectl get namespace
    ;;

# Pod related actions
  pl|gp)
    kubectl get pods
    ;;
  sh)
    require_params_1
    kubectl exec -it "$PARAM1" -- /bin/sh -c 'if [ -x /bin/bash ]; then exec /bin/bash; else exec /bin/sh; fi'
    ;;

# Deployment related actions
  dl)
    kubectl get deployments
    ;;
  ds)
    require_params_2
    kubectl scale deployment "$PARAM1" --replicas="$PARAM2"
    ;;
  dd)
    require_params_1
    kubectl describe deployments "$PARAM1"
    ;;
# Logs related actions
  l)
    require_params_1
    kubectl logs "$PARAM1"
    ;;
  lf)
    require_params_1
    kubectl logs -f "$PARAM1"
    ;;
# Port forwarding
  pf)
    require_params_3
    kubectl port-forward "$PARAM1" "$PARAM2":"$PARAM3"
    ;;

# Job (CronJob) related actions
  jobs)
    case $PARAM1 in
      "")
        kubectl get cronjobs
        ;;
      history)
        kubectl get jobs
        ;;
      *)
        echo "Unknown subcommand for 'jobs': $PARAM1"
        help_hint
        exit 1
        ;;
    esac
    ;;
  job)
    if [ -z "$PARAM1" ] || [ -z "$PARAM2" ]; then
      echo "Invalid parameters. Usage: k job <describe|trigger|suspend|resume> <name>"
      help_hint
      exit 1
    fi
    case $PARAM1 in
      describe)
        kubectl describe cronjob "$PARAM2"
        ;;
      trigger)
        kubectl create job --from=cronjob/"$PARAM2" "$PARAM2"-manual-"$(date +%s)"
        ;;
      suspend)
        kubectl patch cronjob "$PARAM2" -p '{"spec":{"suspend":true}}'
        ;;
      resume)
        kubectl patch cronjob "$PARAM2" -p '{"spec":{"suspend":false}}'
        ;;
      *)
        echo "Unknown subcommand for 'job': $PARAM1"
        help_hint
        exit 1
        ;;
    esac
    ;;

  *|help)
    help
    ;;
esac
