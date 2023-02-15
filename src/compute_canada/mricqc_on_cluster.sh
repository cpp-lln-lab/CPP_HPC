#!/bin/bash

# fail whenever something is fishy
# -e exit immediately
# -x to get verbose logfiles
# -u to fail when using undefined variables
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -e -x -u -o pipefail

#-------------------------------------------
#SBATCH -J fmriprep
#SBATCH --account=def-flepore
#SBATCH --time=15:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=michele.maclean@umontreal.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL
# ------------------------------------------

source ~/venv_datalad/bin/activate

module load git-annex/8.20200810
module load freesurfer/5.3.0
module load singularity/3.8

cd $HOME || exit

singularity run \
    --cleanenv \
    -B $HOME/scratch:/scratch \
    -B $HOME/projects/def-flepore/mmaclean:/mmaclean \
        $HOME/projects/def-flepore/mmaclean/parallel_analysis/containers/images/bids/bids-fmriprep--21.0.1.sing \
            /mmaclean/raw \
            /mmaclean/fmriprep-output \
            participant \
            --participant-label CTL01 \
            --work-dir /scratch/work-fmriprep \
            --fs-license-file /mmaclean/license/freesurfer.txt \
            --output-spaces MNI152NLin2009cAsym T1w \
            --skip_bids_validation \
            --notrack \
            --stop-on-first-crash
