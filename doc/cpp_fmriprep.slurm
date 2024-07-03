#!/bin/bash

#SBATCH --job-name=fMRIprep
#SBATCH --time=9:00:00 # hh:mm:ss

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=20000 # megabytes
#SBATCH --partition=batch,debug

#SBATCH --mail-user=marco.barilari@uclouvain.be
#SBATCH --mail-type=ALL
#SBATCH --output=/home/ucl/cosy/marcobar/jobs_report/fmriprep_job-%j.txt

#SBATCH --comment=project-name

#export OMP_NUM_THREADS=4
#export MKL_NUM_THREADS=4

## CPP frmiprep script for CECI cluster v0.3.0
#
# writtent by CPP people
#
# Submission command for Lemaitre4
#
# sbatch cpp_fmriprep.slurm <subjID> <TaskName>
#
# examples:
# - 1 subject 1 task
# sbatch cpp_fmriprep.slurm sub-01 visMotLocalizer
#
# - 1 subject all task
# sbatch cpp_fmriprep.slurm sub-01 ''
#
# - all subjects 1 task
# sbatch cpp_fmriprep.slurm '' visMotLocalizer
#
# - multiple subjects
# sbatch cpp_fmriprep.slurm 'sub-01 sub-02' visMotLocalizer
#
# - multiple tasks
# sbatch cpp_fmriprep.slurm sub-01 'visMotLocalizer audMotLocalizer'
#
# - submit all the subjects (1 per job) all at once
# read subj list to submit each to a job for all the tasks
# !!! to run from within `raw` folder
# ls -d sub* | xargs -n1 -I{} sbatch path/to/cpp_fmriprep.slurm {} ''

# create jobs_report folder in case they don't exist
mkdir -p $HOME/jobs_report/

# fail whenever something is fishy
# -e exit immediately
# -x to get verbose logfiles
# -u to fail when using undefined variables
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -e -x -u -o pipefail

module --force purge

subjID=$1
TaskName=$2

# "latest" or procide specific version number
FMRIPREP_VERSION="24.0.0"

# set username to locate scratch folder
ceci_username="marcobar"

# set fmriprep arguments
nb_dummy_scans=0

# cluster paths
path_to_singularity_image="$HOME/tools/containers/images/bids/bids-fmriprep--${FMRIPREP_VERSION}.sing"
scratch_dir=$GLOBALSCRATCH
freesurfer_license_folder="$HOME/tools"

# data paths
root_dir="$HOME/path-to-project-yoda-fodler"
bids_dir="$root_dir/inputs/raw"
output_dir="$root_dir/outputs/derivatives/fmriprep"

# make the scratch folder, here there is no limit space and fmriprep can store stuff in case of crash and do not start from zero again
mkdir -p "${scratch_dir}"/work-fmriprep

# create output folder in case it does not exists
mkdir -p "${output_dir}"

singularity run --cleanenv \
    -B "${scratch_dir}":/scratch_dir \
    -B "${bids_dir}":/bids_dir \
    -B "${output_dir}":/output \
    -B "${freesurfer_license_folder}":/freesurfer_license \
    "${path_to_singularity_image}" \
    /bids_dir \
    /output \
    participant --participant-label "${subjID}" \
    --task "${TaskName}" \
    --work-dir /scratch_dir/work-fmriprep/"${subjID}" \
    --fs-license-file /freesurfer_license/license.txt \
    --output-spaces MNI152NLin2009cAsym T1w \
    --dummy-scans ${nb_dummy_scans} \
    --notrack \
    --skip_bids_validation \
    --stop-on-first-crash


# more useful options to keep in mind:
# 
# --fs-no-reconall # skip freesurfer segmentation