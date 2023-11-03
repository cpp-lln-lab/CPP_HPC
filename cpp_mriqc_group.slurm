#!/bin/bash

#SBATCH --job-name=MRIqc
#SBATCH --time=9:00:00 # hh:mm:ss

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=9
#SBATCH --mem-per-cpu=10000 # megabytes
#SBATCH --partition=batch,debug

#SBATCH --mail-user=marco.barilari@uclouvain.be
#SBATCH --mail-type=ALL
#SBATCH --output=/home/ucl/irsp/marcobar/jobs_report/mriqc_job-%j.txt

#SBATCH --comment=project-name

#export OMP_NUM_THREADS=9
#export MKL_NUM_THREADS=9

## CPP MRIqc script for CECI cluster
#
# writtent by CPP people
#
# Submission command for Lemaitre3 after running mriqc for each participant
#
# sbatch cpp_mriqc_group.slurm

# create jobs_report folder in case they don't exist
mkdir -p $HOME/jobs_report/

# fail whenever something is fishy
# -e exit immediately
# -x to get verbose logfiles
# -u to fail when using undefined variables
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -e -x -u -o pipefail

module --force purge

# "latest" or procide specific version number
MRIQC_VERSION="23.1.0"

# set username to locate scratch folder
ceci_username="marcobar"

path_to_singularity_image="$HOME/tools/containers/images/bids/bids-mriqc--${MRIQC_VERSION}.sing"
bids_dir="$HOME/mriqc_trial/raw"
output_dir="$HOME/mriqc_trial/derivatives/mriqc"

# create mriqc output folder in case they don't exist
mkdir -p "${output_dir}"

singularity run --cleanenv \
    -B "${bids_dir}":/data \
    -B "${output_dir}":/out \
        "${path_to_singularity_image}" \
            /data \
            /out \
            group
