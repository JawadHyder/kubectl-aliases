# kubectl-aliases
Easy to remember aliases for kubectl commands

# Setup
### Bash
```sh
echo "alias k=$(pwd)/kubectl_aliases.sh" >> ~/.bashrc && source ~/.bashrc
```

### Zsh
```sh
echo "alias k=$(pwd)/kubectl_aliases.sh" >> ~/.zshrc && source ~/.zshrc
```

# Usage
```sh
k [action] [...params]
```
### Help: 
```sh
k help
```
### Actions:
```
  Help
    help    | See this help message

  Context
    cg      | Context Get: Get current context
    cs <c>  | Context Set: Set current context. Params: [c=context name]
    cl      | Context List: List all available contexts
    cd      | Context Describe: Show context details

  Namespace
    ng      | Namespace Get: Get current namespace
    ns      | Namespace Set: Set current namespace
    nl      | Namespace List: List all available namespaces

  Pods
    pl/gp   | Pods List: Get Pods in current namespace
    sh <p>  | shell: Get shell access to pod. Params: [p=pod name]

  Deployments
    dl      | Deployments List: Get list of deployments in current namespace
    ds <d> <n> | Deployment Scale: Scale a deployment. Params: [d=deployment name] [n=number of replicas]
    dd <d>  | Deployment Describe: Describe a deployment. Params: [d=deployment name]
```