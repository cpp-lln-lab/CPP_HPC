#!/bin/bash

# to be called from the root of the YODA dataset

# subject label passed as argument
participant_label=$1

# binds the root folder of the YODA dataset on your machine
#  onto the /my_analysis inside the container

# runs the container: ~/my_images/fmriprep-${VERSION}.sing

# tweak the parameters below to your convenience

# see here for more info: https://fmriprep.org/en/stable/usage.html#usage-notes

VERSION=21.0.2
nb_dummy_scans=0
task="auditory"

# https://fmriprep.org/en/21.0.2/spaces.html
output_spaces="MNI152NLin6Asym T1w"


singularity run --cleanenv \
        --bind "$(pwd)":/my_analysis \
        ~/my_images/fmriprep-${VERSION}.simg \
        /my_analysis/inputs/raw /my_analysis/derivatives \
        participant \
        --participant-label ${participant_label} \
        --fs-license-file /my_analysis/code/license.txt \
        -w /my_analysis/tmp/wdir \
        --dummy-scans ${nb_dummy_scans} \
        --task-id ${task} \
        --bids-filter-file /my_analysis/code/bids_filter_file.json \
        --output-spaces ${output_spaces}
