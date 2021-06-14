# CPP_HPC

## Installing Datalad on the CECI cluster

upgrade pip

```
pip3 install --user --upgrade pip
```

install datalad
```
pip3 install --user datalad
```
```
pip3 install --user datalad-installer
```

```
datalad-installer git-annex
```

above code did not work, `datalad --version` gave no result

instead:

```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

```
bash Miniconda3-latest-Linux-x86_64.sh
```

```
conda install -c conda-forge datalad
```

this would ooutput that `conda` is command not found, if this is the case try:

```
export PATH="/home/ucl/irsp/YOUR-USER-NAME/miniconda3/bin:$PATH"
```

check that conda is installed

```
conda --version
```

try again
```
conda install -c conda-forge datalad
```
