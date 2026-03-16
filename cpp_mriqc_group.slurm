#!/bin/bash

#SBATCH --job-name=MRIqc
#SBATCH --time=4:00:00 # hh:mm:ss

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=10000 # megabytes
#SBATCH --partition=batch

#SBATCH --mail-user=marco.barilari@uclouvain.be
#SBATCH --mail-type=ALL
#SBATCH --output=/home/ucl/cosy/marcobar/jobs_report/mriqc_job-%j.txt

#SBATCH --comment=project-name

#export OMP_NUM_THREADS=4
#export MKL_NUM_THREADS=4

## CPP MRIqc script for CECI cluster v0.3.0
#
# writtent by CPP people
#
# Submission command for Lemaitre4 after running mriqc for each participant
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
MRIQC_VERSION="24.0.0"

# cluster paths
path_to_singularity_image="$HOME/tools/containers/images/bids/bids-mriqc--${MRIQC_VERSION}.sing"
scratch_dir=$GLOBALSCRATCH

# data paths
root_dir="$HOME/path-to-project-yoda-fodler"
bids_dir="$root_dir/inputs/raw"
output_dir="$root_dir/outputs/derivatives/mriqc"

# make the scratch folder, here there is no limit space and fmriprep can store stuff in case of crash and do not start from zero again
mkdir -p "${scratch_dir}"/work-mriqc

# create mriqc output folder in case they don't exist
mkdir -p "${output_dir}"

singularity run --cleanenv \
    -B "${scratch_dir}":/scratch_dir \
    -B "${bids_dir}":/bids_dir \
    -B "${output_dir}":/output \
    "${path_to_singularity_image}" \
    /bids_dir \
    /output \
    --work-dir /scratch_dir/work-mriqc/"${subjID}" \
    --verbose-reports \
    group
