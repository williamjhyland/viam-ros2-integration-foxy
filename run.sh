#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Create virtual Python environment
cd `dirname $0`

# Create a virtual environment to run our code
VENV_NAME="venv"
PYTHON="$VENV_NAME/bin/python"
ENV_ERROR="This module requires Python >=3.8, pip, and virtualenv to be installed."

#if ! python3 -m venv --system-site-packages $VENV_NAME >/dev/null 2>&1; then
#    echo "Failed to create virtualenv."
#    if command -v apt-get >/dev/null; then
#        echo "Detected Debian/Ubuntu, attempting to install python3-venv automatically."
#        SUDO="sudo"
#        if ! command -v $SUDO >/dev/null; then
#            SUDO=""
#        fi
#		if ! apt info python3-venv >/dev/null 2>&1; then
#			echo "Package info not found, trying apt update"
#			$SUDO apt -qq update >/dev/null
#		fi
#        $SUDO apt install -qqy python3-venv >/dev/null 2>&1
#        if ! python3 -m venv $VENV_NAME >/dev/null 2>&1; then
#            echo $ENV_ERROR >&2
#            exit 1
#        fi
#    else
#        echo $ENV_ERROR >&2
#        exit 1
#    fi
#fi

# python3 -m venv --system-site-packages venv

# remove -U if viam-sdk should not be upgraded whenever possible
# -qq suppresses extraneous output from pip
echo "Virtualenv found/created. Installing/upgrading Python packages..."
#if ! $PYTHON -m pip install -r requirements.txt -Uqq; then
#    exit 1
#fi

export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1
# export underlay & add overlays as needed
. /etc/turtlebot4/setup.bash
# . /opt/ros/humble/setup.bash
#. /opt/ros/foxy/setup.bash

# setup LD_LIBRARY_PATH for viam
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${SCRIPT_DIR}/venv/lib/python3.8/site-packages/viam/rpc/
echo ${LID_LIBRARY_PATH}

# Be sure to use `exec` so that termination signals reach the python process,
# or handle forwarding termination signals manually
echo "Starting module..."
exec ${SCRIPT_DIR}/venv/bin/python3 ${SCRIPT_DIR}/src/main.py $@
