## Installing Datalad on the CECI cluster for your user

To contribute see [here](https://cpp-lln-lab.github.io/CPP_HPC/contributing/)

- First of all access one the clusters (this has been tried on _Lemaitre4_)
- Upgrade `pip`.

```bash
# upgrade pip
pip3 install --user --upgrade pip
```

- Follow the
  [datalad handbook](http://handbook.datalad.org/en/latest/intro/installation.html#norootinstall)
  installation for HPC (no root access) or copy-paster the code below.

```bash
# get anaconda and install it
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
conda install -c conda-forge datalad
```

If this outputs that `conda` is command not found, try:

```bash
export PATH="/home/ucl/irsp/YOUR-USER-NAME/miniconda3/bin:$PATH"
```

Check that conda is installed with `conda --version` and try again.

```bash
conda install -c conda-forge datalad
```

- Now let's try to clone from gin a repo on the cluster space using datalad:

```BASH
# clone using the ssh path from a gin repo
datalad install git@gin.g-node.org:/USERNAME/REPONAME.git

# get the data
cd YOUR-CLONED-REPO
datalad get .
```

- If you need to create an ssh key follow this on
  [github website](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

  or just type:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"

# print the ssh key to copy
cat ~/.ssh/id_ed25519.pub
```

and add it in your gin settings, "ssh key" section.
