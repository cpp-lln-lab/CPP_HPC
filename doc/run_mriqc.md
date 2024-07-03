# WIP# Run MRIqc on the cluster

Written by CPP lab people

To contribute see [here](https://cpp-lln-lab.github.io/CPP_HPC/contributing/)


## General tips

- The more resources required, the faster it can be but the more waiting time

- To try things, set `--time=00:05:00` and `--partition=debug` so it starts
  right away and you can check if it at least starts without problems (eg the
  singularity images is running, data are bids compatible or data folders are
  loaded proprerly). See below in the section [Submit a MRIqc job via sbatch command](#submit-a-MRIqc-job-via-sbatch-command-without-a-script-mainly-for-debug-purposes)

## Prepare to run MRIqc on the cluster

- have your data on the cluster
- install datalad on your user (see [here](https://github.com/cpp-lln-lab/CPP_HPC/install_datalad))
- get the fmriprep singularity image as follow:

here the example is with `MRIqc version 24.0.0` but check for newer version, list of fmriprep version available [here](https://hub.docker.com/r/nipreps/fmriprep/tags/)

```bash
datalad install https://github.com/ReproNim/containers.git

cd containers

datalad get images/bids/bids-mriqc--24.0.0.sing
```

In case you have installe the repo a while a ago and you want to use a new version of fmriprep., update the `containers` repo via:

```bash
# go to the repo folder
cd path/to/containers

datald update --merge
``````

Depending on the cluster “unlock” is needed or not. No need for `lemaitre4`.

```bash
datalad unlock containers/images/bids/bids-mriqc--24.0.0.sing
```

## Submit a MRIqc job via a `slurm` script

- pros:
    - easy to run for multiple subject
- cons:
    - the `slurm` script can be hard to edit from within the cluster in case of error or a change of mind with fmriprep
    options. You can edit via `vim` or locally and then
    uploading a newversion.

### Participants level

Content of the `cpp_mriqc.slurm` file (download and edit from [here](cpp_mriqc.slurm))

!!! Warning

    1. Read the MRIqc documentation to know what you are doing and how the arguments of the run call effects the results
    2. All the paths and email are set afte Marco's users for demosntration. Change them for your user.
    3. Edit the scripts with the info you need to make it run for your user from top to buttom of the script, do not over look the first "commented" chunk cause it is not a real commented section (check the email and job report path, data paths and the `username` etc.).

```bash
{% include "cpp_mriqc.slurm" %}
```

On the cluster prompt, submit the jobs as:

```bash
# Submission command for Lemaitre4

# USAGE on cluster:

sbatch cpp_mriqc.slurm <subjID>

# examples:
# - 1 subject

sbatch cpp_mriqc.slurm sub-01

# submit all the subjects (1 per job) all at once
# read subj list to submit each to a job for all the tasks
# !!! to run from within `raw` folder
ls -d sub* | xargs -n1 -I{} sbatch path/to/cpp_mriqc.slurm {}
```

### Group level

Content of the `cpp_mriqc_group.slurm` file (download and edit from [here](cpp_mriqc_group.slurm))

!!! Warning

    1. Read the MRIqc documentation to know what you are doing and how the arguments of the run call effects the results
    2. All the paths and email are set afte Marco's users for demosntration. Change them for your user.
    3. Edit the scripts with the info you need to make it run for your user from top to buttom of the script, do not over look the first "commented" chunk cause it is not a real commented section (check the email and job report path, data paths and the `username` etc.).

```bash
{% include "cpp_mriqc_group.slurm" %}
```

On the cluster prompt, submit the jobs as:

```bash
# Submission command for Lemaitre4

# USAGE on cluster:

# no need to priovide any input

sbatch cpp_mriqc_group.slurm
```

## TIPS

### check your job

see [here](https://github.com/cpp-lln-lab.github.io/CPP_HPC/cluster_code_snippets/#check-your-running-jobs)

To contribute see [here](https://cpp-lln-lab.github.io/CPP_HPC/contributing/)
