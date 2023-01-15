# Running fmriprep with singularity

List of fmriprep version available here:
https://hub.docker.com/r/nipreps/fmriprep/tags/

Latest (long term support) LTS version: 20.2.7

- [Running fmriprep with singularity](#running-fmriprep-with-singularity)
  - [Example on how to run it locally](#example-on-how-to-run-it-locally)
    - [Build singularity image](#build-singularity-image)
    - [Set up](#set-up)
    - [Run fmriprep](#run-fmriprep)
  - [Datalad + fmriprep](#datalad--fmriprep)
    - [Folder structure](#folder-structure)
      - [fMRIprep](#fmriprep)

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
cp ~/Dropbox/Software/Freesurfer/License/license.txt \
	~/my_analysis/code
```

Create a temporary dir to keep intermediate results: useful if fmriprep crashes,
it won't start from zero

```
mkdir tmp/wdir
```

Add a `bids_filter_file.json` config file to help you define what fmriprep
should consider as `bold` as `T1w`.

The one below corresponds to the fMRIprep default (also available inside this
repo).

See this part of the FAQ for more info:

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
#!/bin/bash

# to be called from the root of the YODA dataset

# subject label passed as argument
participant_label=$1

# binds the root folder of the YODA dataset on your machine
#  onto the /my_analysis inside the container

# runs the container: ~/my_images/fmriprep-${VERSION}.sing

# tweak the parameters below to your convenience

# see here for more info: https://fmriprep.org/en/stable/usage.html#usage-notes

VERSION=21.0.2
nb_dummy_scans=0
task="auditory"

# https://fmriprep.org/en/21.0.2/spaces.html
output_spaces="MNI152NLin6Asym T1w"


singularity run --cleanenv \
        --bind "$(pwd)":/my_analysis \
        ~/my_images/fmriprep-${VERSION}.simg \
        /my_analysis/inputs/raw /my_analysis/derivatives \
        participant \
        --participant-label ${participant_label} \
        --fs-license-file /my_analysis/code/license.txt \
        -w /my_analysis/tmp/wdir \
        --dummy-scans ${nb_dummy_scans} \
        --task-id ${task} \
        --bids-filter-file /my_analysis/code/bids_filter_file.json \
        --output-spaces ${output_spaces}
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

Pass argument of the participant label.

```bash
. code/singularity_run_fmriprep.sh 01
```

<!--

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
``` -->


## Datalad + fmriprep

Example on how to run it locally

### Folder structure

```
derivatives
├── env
│   ├── bin
│   ├── lib
│   └── share
├── derivatives     <-- this is where the data will go
│   ├── fmriprep
│   └── freesurfer
└── raw             <-- installed as a subdataset
    ├── code
    └── sub-01
```

#### fMRIprep

Install datalad & others in a virtual environment

```bash
virtualenv -p python3.8 env
source env/bin/activate
pip install datalad datalad-neuroimaging datalad-container
```

Get fmriprep (make sure singualrity is installed)

```bash
datalad containers-add fmriprep --url docker://nipreps/fmriprep:20.2.0
```

Run fmriprep

```bash
input_dir=`pwd`/raw
output_dir=`pwd`/derivatives
participant_label=01

# the following will depend on where you keep your freesurfer license
freesurfer_licence=~/Dropbox/Software/Freesurfer/License/license_1.txt

datalad containers-run -m "fmriprep 01" \
	--container-name fmriprep \
	--input ${input_dir} \
	--output ${output_dir} \
    fmriprep $input_dir ${output_dir} participant \
	--participant-label ${participant_label} \
	-w /tmp --fs-license-file ${freesurfer_licence} \
    --output-spaces T1w:res-native MNI152NLin2009cAsym:res-native
```
