# Run fmriprep and mriQC on the cluster

Written by CPP lab people

To contribute see [here](https://cpp-lln-lab.github.io/CPP_HPC/contributing/)

## General tips

- The more resources required, the faster it can be but the more waiting time

- To try things, set `--time=00:05:00` and `--partition=debug` so it starts
  right away and you can check if it at least starts without problems (eg the
  singularity images is running, data are bids compatible or data folders are
  loaded proprerly). See below in the section [Submit a fmriprep job via sbatch command](#submit-a-fmriprep-job-via-sbatch-command-without-a-script-mainly-for-debug-purposes)

## Prepare to run fmriprep on the cluster

- have your data on the cluster
- install datalad on your user (see [here](https://github.com/cpp-lln-lab/CPP_HPC/install_datalad))
- get the fmriprep singularity image as follow:

here the example is with `fmriprp version 21.0.1` but check for newer version, list of fmriprep version available [here](https://hub.docker.com/r/nipreps/fmriprep/tags/)

```bash
datalad install https://github.com/ReproNim/containers.git

datalad get containers/images/bids/bids-fmriprep--21.0.1.sing
```

Depending on the cluster “unlock” is needed or not. No need for `lemaitre3`.

```bash
datalad unlock containers/images/bids/bids-fmriprep--21.0.1.sing
```

  - get your `freesurfer` license (user specific) for free [here](https://surfer.nmr.mgh.harvard.edu/registration.html) and move it to the cluster

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
    2. All the paths and email are set afte Marco's users for demosntration. 
    3. Edit the scripts with the info you need to make it run for your user from top to buttom of the script, do not over look the first "commented" chunk cause it is not a real commented section (check the email and job report path, data paths and the `username` etc.). 

```bash
{% include "cpp_fmriprep.slurm" %}
```

On the cluster prompt, submit the jobs as:

```bash
# Submission command for Lemaitre3

# USAGE on cluster:

sbatch cpp_fmriprep.slurm <subjID> <TaskName>

# examples:
# - 1 subject 1 task

sbatch cpp_fmriprep.slurm sub-01 visMotLocalizer

# - 1 subject all task
sbatch cpp_fmriprep.slurm sub-01 ''

# - all subjects 1 task
sbatch cpp_fmriprep.slurm '' visMotLocalizer

# - multiple subjects
sbatch cpp_fmriprep.slurm 'sub-01 sub-02' visMotLocalizer

# - multiple tasks
sbatch cpp_fmriprep.slurm sub-01 'visMotLocalizer audMotLocalizer'

# submit all the subjects (1 per job) all at once
# read subj list to submit each to a job for all the tasks
# !!! to run from within `raw` folder
ls -d sub* | xargs -n1 -I{} sbatch path/to/cpp_fmriprep.slurm {} ''
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

## TIPS

### check your job

see [here](https://github.com/cpp-lln-lab/CPP_HPC/cluster_code_snippets/#check-your-running-jobs)

### crashes

- if fmriprep stops (eg timeout, error), rerunning the subject(s) might crash
  due to the fact that freesurfer is not happy that parcellation started already

### bids fiter file

Add a `bids_filter_file.json` config file to help you define what fmriprep
should consider as `bold` as `T1w`.

The one below corresponds to the fMRIprep default (also available inside this
repo).

See this part of the FAQ for more info:

https://fmriprep.org/en/21.0.2/faq.html#how-do-I-select-only-certain-files-to-be-input-to-fMRIPrep

```json
{% include "bids_filter_file.json" %}
```

you will need to add the argument `--bids-filter-file path/to/bids_filter_file.json` when running fmriprep.
