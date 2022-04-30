# Running fmriprep with singularity

List of fmriprep version available here:
https://hub.docker.com/r/nipreps/fmriprep/tags/

Latest (long term support) LTS version: 20.2.7

## Example on how to run it locally

REQUIREMENTS: datalad for data source control and installing data

### Build singularity image

```bash
VERSION=21.0.2
singularity build   ~/my_images/fmriprep-${VERSION}.simg \
                    docker://nipreps/fmriprep:${VERSION}
```

### Set up

```bash
datalad create --force -c yoda ~/my_analysis
cd ~/my_analysis
tree
```

**Folder structure**

```
├── CHANGELOG.md
├── code
│   └── README.md
└── README.md
```

Adding `derivatives` folder for output and cloning a raw BIDS dataset into the
input folder. Using the MoAE SPM BIDS dataset from GIN:

``git@gin.g-node.org:/SPM_datasets/spm_moae_raw.git`

```bash
mkdir derivatives
mkdir inputs
datalad install -d . --get-data -s git@gin.g-node.org:/SPM_datasets/spm_moae_raw.git inputs/raw
tree
```

**Folder structure**

```text
├── CHANGELOG.md
├── code
│   └── README.md
├── derivatives                        <-- this is where the output data will go
├── inputs
│   └── raw                            <-- installed as a subdataset
│       ├── CHANGES
│       ├── dataset_description.json
│       ├── participants.tsv
│       ├── README
│       ├── sub-01
│       │   ├── anat
│       │   │   └── sub-01_T1w.nii
│       │   └── func
│       │       ├── sub-01_task-auditory_bold.nii
│       │       └── sub-01_task-auditory_events.tsv
│       └── task-auditory_bold.json
└── README.md
```

Copy the freesurfer license into the code folder:

```bash
cp ~/Dropbox/Softwares/Freesurfer/License/license.txt \
	~/my_analysis/code
```

Create a temporary dir to keep intermediate results: useful if fmriprep crashes,
it won't start from zero

```
mkdir tmp/wdir
```

Add a `bids_filter_file.json` config file to help you define what fmriprep
should consider as `bold` as `T1w`.

The one below corresponds to the fMRIprep default (also available inside this repo).

See this part of the FAQ for
more info:

https://fmriprep.org/en/21.0.2/faq.html#how-do-I-select-only-certain-files-to-be-input-to-fMRIPrep

```JSON
{
  "fmap": {
    "datatype": "fmap"
  },
  "bold": {
    "datatype": "func",
    "suffix": "bold"
  },
  "sbref": {
    "datatype": "func",
    "suffix": "sbref"
  },
  "flair": {
    "datatype": "anat",
    "suffix": "FLAIR"
  },
  "t2w": {
    "datatype": "anat",
    "suffix": "T2w"
  },
  "t1w": {
    "datatype": "anat",
    "suffix": "T1w"
  },
  "roi": {
    "datatype": "anat",
    "suffix": "roi"
  }
}
```

Create a `singularity_run_fmriprep.sh` script in the code folder with following
content:

```bash
FIXME
```

**Folder structure**

```text
├── CHANGELOG.md
├── code
│   ├── bids_filter_file.json
│   ├── license.txt
│   ├── README.md
│   └── singularity_run_fmriprep.sh
├── derivatives
├── inputs
│   └── raw
│       ├── CHANGES
│       ├── dataset_description.json
│       ├── participants.tsv
│       ├── README
│       ├── sub-01
│       │   ├── anat
│       │   │   └── sub-01_T1w.nii
│       │   └── func
│       │       ├── sub-01_task-auditory_bold.nii
│       │       └── sub-01_task-auditory_events.tsv
│       └── task-auditory_bold.json
└── README.md
```

### Run fmriprep

. code/singularity_run_fmriprep.sh 01


---

```bash
#!/bin/bash
#-------------------------------------------
#SBATCH -J fmriprep
#SBATCH --account=def-flepore
#SBATCH --time=3:00:00
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
# run the fmriprep job with singularity
singularity run --cleanenv /home/mmaclean/projects/def-flepore/mmaclean/parallel_analysis/containers/images/bids/bids-fmriprep--21.0.1.sing /home/mmaclean/projects/def-flepore/mmaclean/CVI-raw /home/mmaclean/projects/def-flepore/mmaclean/preprocessing participant --participant-label CTL17 --fs-license-file /home/mmaclean/projects/def-flepore/mmaclean/license/freesurfer.txt --skip_bids_validation --notrack
```
