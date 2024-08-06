# data_lake_example
A simplified example of the data-lake for training/prototyping purposes.

# Cloning project:
After cloning the project, don't forget to initialize and update the submodules
$ git submodule init
$ git submodule update

# Git Submodules
## Add a submodule
$ git submodule add https://github.com/open-dis/open-dis-python

## Cloning the project and adding the submodules
## 1.) Clone the project
$ cd instrumentation-stack-docker
$ git submodule init
$ git submodule update

## Ignore changes to the log files
$ git update-index --assume-unchanged nifi/logs/
