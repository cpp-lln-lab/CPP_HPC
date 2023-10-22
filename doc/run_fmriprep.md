# Run fmriprep and mriQC on the cluster

- Alice Van Audenhaege
- Marco Barilari
- Michèle MacLean

## General tips

- The more resources required, the faster it can be but the more waiting time
  
- To try things, set `--time=00:05:00` and `--partition=debug` so it starts
  right away and you can check if it at least starts without problems (eg the
  singularity images is running, data are bids compatible or data folders are
  loaded proprerly). See below in the section [Submit a fmriprep job via sbatch command](#submit-a-fmriprep-job-via-sbatch-command-without-a-script-mainly-for-debug-purposes)

## Submit a fmriprep job via a `slurm` script

- pros:
    - easy to run for multiple subject
- cons:
    - the `slurm` script can be hard to edit from within the cluster in case of error or a change of mind with fmriprep
    options. You can edit via `vim` or locally and then 
    uploading a newversion.

Content of the `cpp_fmriprep.slurm` file (download and edit from [here](cpp_fmriprep.slurm))

!!! Warning

    1. Read the fmriprep documentation to know what you are doing and how the arguments of the run call effects the results
    2. Edit the scripts with the info you need to make it run for your user (check the paths and the `username` etc.)

```bash
{% include "cpp_fmriprep.slurm" %}
```

On the cluster prompt, submit the jobs as:

```bash
# Submission command for Lemaitre3
 
# USAGE on cluster:

sbatch cpp_fmriprep.sh <subjID> <TaskName>

# examples:
# - 1 subject 1 task

sbatch cpp_fmriprep.sh sub-01 visMotLocalizer

# - multiple subjects

sbatch cpp_fmriprep.sh 'sub-01 sub-02' visMotLocalizer
 
# - multiple tasks

sbatch cpp_fmriprep.sh sub-01 'visMotLocalizer audMotLocalizer'

# submit all the subjects (1 per job) all at once

# read subj list to submit each to a job
ls -d inputs/raw/sub* | xargs -n1 -I{} \
  sbatch cpp_fmriprep.sh {}
```

## Submit a fmriprep job via sbatch command without a script (mainly for DEBUG purposes)

- pros:
    - fast to edit and debug 
- cons:
    - if copy pasted in the terminal looses the lines structure so hard to edit
    (use vscode ;) )
    - at the moment it only submit one subject per job

```bash
# slurm job set up
sbatch --job-name=fmriprep_trial \
  --comment=cpp_cluster_hackaton \
  --time=42:00:00 \
  --ntasks=1 \
  --cpus-per-task=9 \
  --mem-per-cpu=10000 \
  --partition=batch,debug \
  --mail-user=marco.barilari@uclouvain.be \
  --mail-type=ALL \
  --output=fmriprep-slurm_{}-job-%j.txt
  --wrap \
    “singularity run --cleanenv \
        -B /scratch/users/m/a/marcobar:/scratch \
        -B ~/sing_temp:/sing_temp \
        ~/sing_temp/containers/images/bids/bids-fmriprep--21.0.1.sing \
        /sing_temp/raw \
        /sing_temp/fmriprep \
        participant \
        --participant-label sub-01 \
        --work-dir /scratch/work-fmriprep \
        --fs-license-file /sing_temp/license.txt \
        --output-spaces MNI152NLin2009cAsym T1w \
        --notrack \
        --stop-on-first-crash”
```

## Utilities

- Check cluster resources

`sinfo`

- Check how my job are doing

`squeue --me`

- Check when my jobs will start (not very reliable though)

`squeue --me --start`

- To cancel the job

`scancel YOURJOBID`

- Check how the job performed using (or not) the resources requested

`sacct --format Jobid,ReqMem,MaxRSS,TimeLimit,AllocCPU,CPUTime,TotalCPU -j YOURJOBID`


## TODO

- if fmriprep stops (eg timeout, error), rerunning the subject(s) might crash
  due to the fact that freesurfer is not happy that parcellation started already
