# Bare\* Load Balancer

Proof-of-Concept work on various types of cluster load balancers
for bare{metal,VM,whatever} k8s deployments.


# Development Guide


> IMPORTANT: Make sure you do all of the following in the first load balancer
>            because that's how I did it and I don't have time to figure out how
>            to do parameterization so that it's smart enough to know that it's
>            not running on the first load balancer. OK??! OK. Just gonna walk it
>            off now. Have a nice day.


## Prerequisites

1. GNU Make


## Prepare Your Development Environment

1. Install pyenv so that you can test with different versions of Python

```
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
```

2. Append the following to your ~/.bashrc then log out and log back in

```
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

3. Install development packages

```
sudo apt install build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git
```

4. Install Python 3.7

```
pyenv install 3.7.7
```

NOTE: For more available versions, run `pyenv install --list`

5. Create a virtualenv for this project

```
pyenv virtualenv 3.7.7 bare-asterisk-load-baalancer
pyenv local bare-asterisk-load-baalancer 3.7.7
```

Your newly created virtualenv should now be activated if your prompt changed
to something like the following:

```
(bare-asterisk-load-baalancer) ubuntu@dev-18-04-2:/path/to/your/charm$
```

or, should you happen to be using [my dotfiles](https://dotfiles.relaxdiego.com),
if the prompt includes the following:

```
... via 🐍 v3.7.7 (bare-asterisk-load-balancer)
```

## Set Up The keepalived + IPVS LBs

Copy the sample inventory file

```
cp inventory.yml.example inventory.yml
```

Modify the values of each entry under the `all->vars` stanza in that file as needed.
Once you have the variables just right, run:

```
make keepalived
```

# Other Handy Commands

## Install Dependencies (It Will Know If It Needs to or Not)

```
make dependencies
```


## Start Over (Removes dependencies)

```
make clean
```


## Really Start Over (Remove Ansible Roles too!)

```
make clean all=t
```
