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

if this outputs that `conda` is command not found, try:

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

Now let's try to clone a repo on the cluster space using datalad:


use the ssh path from a gin repo 
```
datalad clone git@gin.g-node.org:/marcobarilari/remi-gau_high-res.git
```

get the data
```
cd YOUR CLONED REPO

datalad get .
```

if you need to create an ssh key follow this on (github website)[https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent]

```
$ ssh-keygen -t ed25519-sk -C "your_email@example.com"
```

copy the output of 

```
cat ~/.ssh/id_ed25519.pub
```

and add in your gin seeting, "ssh key" section 
