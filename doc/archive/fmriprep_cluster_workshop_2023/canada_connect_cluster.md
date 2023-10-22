# Running fmriprep or mriqc on a cluster

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

See
[here for more details](https://cbs-discourse.uwo.ca/t/installing-datalad-on-compute-canada/23?fbclid=IwAR0cCi1HeA5uU0eHGmR9tdwlbtElpDAcdONRK5cPtPVo5g8RKAg_Iv37Kxo).

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

Have your freesurfer license ready.

Here is an example script

```bash
{% include "archive/fmriprep_cluster_workshop_2023/canada_fmriprep_on_cluster.sh" %}
```

Extra reference:

- [andysbrainbook](https://andysbrainbook.readthedocs.io/en/latest/OpenScience/OS/fMRIPrep_Demo_2_RunningAnalysis.html?fbclid=IwAR01abjWmu5c3I19maqWTYUeu8rhR7S1RqJ7VZKliWUfEYOc6kK9ijwkXLk#running-singularity-on-a-supercomputing-cluster)
