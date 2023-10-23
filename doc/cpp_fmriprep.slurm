#!/bin/bash

#SBATCH --job-name=fMRIprep
#SBATCH --time=9:00:00 # hh:mm:ss

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=9
#SBATCH --mem-per-cpu=10000 # megabytes
#SBATCH --partition=batch,debug

#SBATCH --mail-user=marco.barilari@uclouvain.be
#SBATCH --mail-type=ALL
#SBATCH --output=/home/ucl/irsp/marcobar/jobs_report/fmriprep_job-%j.txt

#SBATCH --comment=project-name

#export OMP_NUM_THREADS=1
#export MKL_NUM_THREADS=1

## CPP frmiprep script for CECI cluster
#
# writtent by CPP people
#
# Submission script for Lemaitre3
#
# USAGE on cluster:
#
#   sbatch cpp_fmriprep.sh <subjID> <TaskName>
#
# examples:
#
# - 1 subject 1 task
# sbatch cpp_fmriprep.sh sub-01 visMotLocalizer
#
# - multiple subjects
# sbatch cpp_fmriprep.sh 'sub-01 sub-02` visMotLocalizer
#
# - multipple tasks
# sbatch cpp_fmriprep.sh sub-01 'visMotLocalizer audMotLocalizer'

# create jobs_report and output folders in case they don't exist
mkdir -p $HOME/jobs_report/
mkdir -p "${output_dir}"

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
FMRIPREP_VERSION="23.1.4"

# set username to locate scratch folder
ceci_username="marcobar"

# set fmriprep arguments
nb_dummy_scans=0

path_to_singularity_image="$HOME/tools/containers/images/bids/bids-fmriprep--${FMRIPREP_VERSION}.sing"
scratch_dir="/scratch/users/m/a/${ceci_username}"
bids_dir="$HOME/fmriprep_trial/raw"
output_dir="$HOME/fmriprep_trial/derivatives/fmriprep"
freesurfer_license_folder="$HOME/tools/freesurfer_license"

# make the scratch folder, here there is no limit space and fmriprep can store stuff in case of crash and do not start from zero again
mkdir -p "${scratch_dir}"/work-fmriprep

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
            --work-dir /scratch_dir/work-fmriprep \
            --fs-license-file /freesurfer_license/license.txt \
            --output-spaces MNI152NLin2009cAsym T1w \
            --dummy-scans ${nb_dummy_scans} \
            --notrack \
            --skip_bids_validation \
            --stop-on-first-crash
