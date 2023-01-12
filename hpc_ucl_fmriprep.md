# Run fmriprep and mriQC on the cluster

Alice Van Audenhaege
Marco Barilari
Michèle MacLean

## General tips

- The more resources required, the faster it can be but the more waiting time
- To try things, set `--time=00:05:00` and `--partition=debug` so it starts right away and you can check if it at least starts without problems (eg the singularity images is running, data are bids compatible or data folders are loaded proprerly)

## to do

- if fmriprep stops (eg timeout, error), rerunning the subject(s) might crash due to the fact that freesurfer is not happy that parcellation started already

## submit a job via `foo.slurm` script

pros: 
- easy to run for multiple subject
  
cons:
- the `foo.slurm` can be hard to edit (you can edit via eg vim or locally upload a newversion) in case of error or a change of mind with fmriprep options

content of the `foo.slurm` file (as in the script `fmriprep_example.slurm`)

```bash
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
#sbatch --output=fmriprep_job-%j.txt
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
```

on the cluster prompt, submit the job as

```bash
sbatch foo.slurm 'sub-099' 
sbatch foo.slurm 'sub-001 sub-003' 
sbatch foo.slurm 'sub-004 sub-005 sub-006'
sbatch foo.slurm 'sub-007 sub-008 sub-009 sub-010' 
sbatch foo.slurm 'sub-011 sub-012 sub-013 sub-014 sub-015' 
```

## submit a job via sbatch command

pros:
- fast to edit and debug
cons:
- if copy pasted in the terminal looses the lines structure so hard to edit (use vscode ;) )
- at the moment it only submit one subject per job

```bash
 ls -d inputs/raw/sub* | xargs -n1 -I{} \ # read subj list to submit each to a job
 sbatch --job-name=fmriprep_trial \ # slurm job set up
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
 “singularity run --cleanenv \ # fmriprep call
    -B /scratch/users/m/a/marcobar:/scratch \
    -B ~/sing_temp:/sing_temp \
    ~/sing_temp/containers/images/bids/bids-fmriprep--21.0.1.sing \
    /sing_temp/raw /sing_temp/fmriprep \
    participant --participant-label {} \
    --work-dir /scratch/work-fmriprep \
    --fs-license-file /sing_temp/license.txt \
    --output-spaces MNI152NLin2009cAsym T1w \
    --notrack --stop-on-first-crash”
```

## Utilia

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
