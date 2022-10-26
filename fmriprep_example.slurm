#!/bin/bash
# Submission script for Lemaitre3
#SBATCH --job-name=fmriprep_trial
#SBATCH --time=42:00:00 # hh:mm:ss
#
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=9
#SBATCH --mem-per-cpu=10000 # megabytes
#SBATCH --partition=batch,debug
#
#SBATCH --mail-user=name.surname@uclouvain.be
#SBATCH --mail-type=ALL
#sbatch --output=fmriprep-slurm_{}-job-%j.txt
#
#SBATCH --comment=cpp_cluster_hackaton

module purge

export OMP_NUM_THREADS=9
export MKL_NUM_THREADS=9

subjID=$1

singularity run --cleanenv \
    -B /scratch/users/m/a/marcobar:/scratch \ # set your personal scratch space
    -B ~/sing_temp:/sing_temp \ 
    ~/sing_temp/containers/images/bids/bids-fmriprep--21.0.1.sing \
    /sing_temp/raw /sing_temp/fmriprep \
    participant --participant-label ${subjID} \
    --work-dir /scratch/work-fmriprep \
    --fs-license-file /sing_temp/license.txt \
    --output-spaces MNI152NLin2009cAsym T1w \
    --notrack --stop-on-first-crash