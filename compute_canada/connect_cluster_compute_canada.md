# Running fmriprep or mriqc on a cluster

- [Running fmriprep or mriqc on a cluster](#running-fmriprep-or-mriqc-on-a-cluster)
   - [Connect to the cluster](#connect-to-the-cluster)
      - [Add your ssh key](#add-your-ssh-key)
   - [Modules](#modules)
   - [Transfer files](#transfer-files)
      - [Use scp to copy individual files and directories](#use-scp-to-copy-individual-files-and-directories)
      - [Use rsync to sync files or directories](#use-rsync-to-sync-files-or-directories)
      - [Use datalad](#use-datalad)
   - [Running jobs](#running-jobs)
      - [Create job script](#create-job-script)
      - [Submit job](#submit-job)
      - [Check job status](#check-job-status)
      - [Cancel job](#cancel-job)
      - [Where does the output go](#where-does-the-output-go)
   - [Tip](#tip)
   - [Running singularity on a cluster](#running-singularity-on-a-cluster)
      - [Run fmriprep on cluster](#run-fmriprep-on-cluster)
      - [Run mriqc on cluster](#run-mriqc-on-cluster)

## Connect to the cluster

Open your terminal and type:

```bash
ssh <username>@graham.computecanada.ca # Graham login node
```

### Add your ssh key

SSH key pairs are very useful to avoid typing passwords

## Modules

There are pre-installed modules that you’ll need to load in order to use. To see
all modules available: `module avail`

To load module (you can put this in your .bashrc if you need the module all the
time): `module load <module_name>`

Example: Check if git is available and load it

```bash
module avail git
module load apps/git/2.13.0
```

## Transfer files

### Use scp to copy individual files and directories

```bash
scp <filename> <username>@graham.computecanada.ca:<PATH/TO/FILE>
scp <username>@graham.computecanada.ca:<PATH/TO/FILE> <LocalPath>
```

### Use rsync to sync files or directories

```bash
rsync <LocalPath/filename> <username>@graham.computecanada.ca:<PATH/TO/FILE>
rsync <username>@graham.computecanada.ca:<PATH/TO/FILE> <LocalPath>
```

### Use datalad

Install Datalad on your cluster :

```bash
module load git-annex python/3
virtualenv ~/venv_datalad
source ~/venv_datalad/bin/activate
pip install datalad
```

https://cbs-discourse.uwo.ca/t/installing-datalad-on-compute-canada/23?fbclid=IwAR0cCi1HeA5uU0eHGmR9tdwlbtElpDAcdONRK5cPtPVo5g8RKAg_Iv37Kxo

## Running jobs

### Create job script

Here is an example of a simple bash script:

```bash
#!/bin/bash
#SBATCH --time=00:05:00
#SBATCH --account=def-flepore
echo 'Hello, world!'
sleep 20
```

### Submit job

In the cluster terminal

```bash
sbatch <name of the file>
```

Example:

```bash
sbatch simple.sh
Submitted batch job 65869853
```

### Check job status

Use squeue or sq to list jobs

```bash
sq

JOBID     USER              ACCOUNT           NAME  ST  TIME_LEFT NODES CPUS TRES_PER_N MIN_MEM NODELIST (REASON)
65869853 mmaclean      def-flepore_cpu      simple.sh  PD       5:00     1    1        N/A    256M  (Priority)
```

Use email notification to learn when your job starts and ends by adding the
following at the top of your script:

```bash
#SBATCH --mail-user=michele.maclean@umontreal.ca
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-type=ALL
```

### Cancel job

```bash
scancel <jobid>
scancel 65869853
```

### Where does the output go

By default the output is placed in a file named "slurm-", suffixed with the job
ID number and ".out", e.g. slurm-65869853.out, in the directory from which the
job was submitted. Having the job ID as part of the file name is convenient for
troubleshooting Files will be output according to where you specified in your
bash script

## Tip

1. Use `$SCRATCH` disk to run your scripts, because `$SCRATCH` is much faster
   than $HOME`.
1. Keep a working directory, if things crash you don't have to start from the
   beginning
1. check usage/space left on cluster: `diskusage_report`
1. See if you need to delete files from scratch once jobs are complete- fmriprep
   output is quite heavy

## Running singularity on a cluster

Download the containers for fmriprep and mriqc here:

Repro nim containers: https://github.com/ReproNim/containers

1. create directory

```bash
mkdir parallel_analysis
```

2. install containers from repronim

```bash
cd parallel_analysis
datalad install https://github.com/ReproNim/containers.git
```

3. retrieve the container you want, e.g., fmriprep

```bash
datalad get containers/images/bids/bids-fmriprep--21.0.1.sing
```

you might need to unlock the container to be able to use it

```bash
datalad unlock containers/images/bids/bids-fmriprep--21.0.1.sing
```

### Run fmriprep on cluster

Have your freesurfer license

Here is an example script

```bash
#!/bin/bash
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

cd

singularity run --cleanenv \
   -B /home/mmaclean/scratch:/scratch \
   -B /home/mmaclean/projects/def-flepore/mmaclean:/mmaclean \
   /home/mmaclean/projects/def-flepore/mmaclean/parallel_analysis/containers/images/bids/bids-fmriprep--21.0.1.sing \
   /mmaclean/raw /mmaclean/fmriprep-output \
   participant --participant-label CTL01 \
   --work-dir /scratch/work-fmriprep \
   --fs-license-file /mmaclean/license/freesurfer.txt \
   --output-spaces MNI152NLin2009cAsym T1w \
   --skip_bids_validation --notrack --stop-on-first-crash
```

### Run mriqc on cluster

Here is an example script

```bash
#!/bin/bash
#-------------------------------------------
#SBATCH -J mriqc
#SBATCH --account=def-flepore
#SBATCH --time=5:00:00
#SBATCH -n 1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=10G
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

cd

singularity run --cleanenv \
      -B /home/mmaclean/scratch:/scratch \
      -B /home/mmaclean/projects/def-flepore/mmaclean:/mmaclean \
      /home/mmaclean/projects/def-flepore/mmaclean/parallel_analysis/containers/images/bids/bids-mriqc--0.16.1.sing \
      /mmaclean/raw /mmaclean/mriqc \
      participant --participant-label CTL01 CTL02 CTL03 \
      -w /scratch/work-mriqc \
      --no-sub
```

Extra ref:
https://andysbrainbook.readthedocs.io/en/latest/OpenScience/OS/fMRIPrep_Demo_2_RunningAnalysis.html?fbclid=IwAR01abjWmu5c3I19maqWTYUeu8rhR7S1RqJ7VZKliWUfEYOc6kK9ijwkXLk#running-singularity-on-a-supercomputing-cluster
