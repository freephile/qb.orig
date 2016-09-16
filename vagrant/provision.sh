#!/bin/sh


## A simple useradd invocation to create
## the local user on the guest plus options
## It turns out that $USER is 'root' when this executes
#    useradd -m            -s /bin/bash      -U           -G            kevin
sudo useradd --create-home --shell /bin/bash --user-group --groups sudo $USER

