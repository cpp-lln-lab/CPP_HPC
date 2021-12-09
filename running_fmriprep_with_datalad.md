# Datalad + fmriprep

Example on how to run it locally

## Folder structure

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

### fMRIprep

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
freesurfer_licence=~/Dropbox/Softwares/Freesurfer/License/license_1.txt

datalad containers-run -m "fmriprep 01" \
	--container-name fmriprep \
	--input ${input_dir} \
	--output ${output_dir} \
    fmriprep $input_dir ${output_dir} participant \
	--participant-label ${participant_label} \
	-w /tmp --fs-license-file ${freesurfer_licence} \
    --output-spaces T1w:res-native MNI152NLin2009cAsym:res-native
```
