# CLI Tools Summary

I use the following tools on my workstation in this repository:

  - asdf
    - runtime version manager
    - swaps out binaries based on `.tool-versions` file
    - why? easy to install binaries cross-platform, quick to update, asdf users will use same version
  - direnv
    - runs all commands in `./envrc` when i navigate to this directory
      - exports a dedicated kubeconfig file
        - no need to merge kubeconfig files across multiple accounts
        - requires me to navigate into this folder for running k8s commands against cluster
          - less change for fat-fingering commands on other clusters
      - outputs current azure subscriptions
        - makes me confirm that i am in the correct repository
  - zsh
    - a ton of aliases for k8s
      - https://github.com/frealmyr/dotfiles/blob/macos/.config/zsh/aliases/k8s.zsh

---

I also keep all of my workstation configuration as code, available here:

  - https://github.com/frealmyr/workstation/
  - https://github.com/frealmyr/dotfiles/
