# Practical info-Contact {#practical-info-contact}

## CÉCI, the "Consortium des Équipements de Calcul Intensif"

- Account gives access to the **clusters** in French Speaking Belgium (Liege,
  Namur, Brussels, Louvain La Neuve)

Important: CECI has a “Big data” survey on their website (first thing in their
home page). They’re going to install a new cluster in Brussels and they’re
asking for people needs. If people don’t need to process big data, a regular
cluster will be installed. If people report that they will need to manage huge
amounts of data, a **Big-data friendly** cluster will be installed. Spread this
information.

### CISM: “CISM” stand for “Calcul Intensif et Stockage de Masse” [Center for High Performance Computing and Mass Storage]

- CISM is part of the CECI
- [https://uclouvain.be/en/research/cism](https://uclouvain.be/en/research/cism)
- Mail: egs-cism@listes.uclouvain.be
- Contacts:
  - thomas.keutgen@uclouvain.be (Responsible CISM- meeting guy)
  - damien.francois@uclouvain.be (other meeting guy)
- Account gives access to the **interactive servers + Mannebeck cluster** (not
  run by the CECI)

## Interactive Servers (one node)

[https://uclouvain.be/en/research/cism/interactive-servers.html](https://uclouvain.be/en/research/cism/interactive-servers.html)

One node, but more powerful than a personal computer.

### SMCS3&4 {#smcs3&4}

- 256 GB RAM
- Those 2 servers are dedicated to **statistical applications**. They are
  managed in collaboration with SMCS (support methodologie et calcul
  statistique)

### Brufence et CeSAM (Lagrange shut down) 

- 256 GB RAM
- These interactive machines are dedicated to **Matlab** use.

### Pellican

- 256 GB RAM
- Has installed **Matlab** 2017

## High Performance Computing (cluster)

Cluster, various nodes to work in parallel.

Each cluster has a specific function/characteristic (big acceleration, big
memory capacity, large parallel jobs, very large number of small jobs…you have
to choose the cluster that best meets your necessities)

### **CECI**:[ http://www.ceci-hpc.be/clusters.html](http://www.ceci-hpc.be/clusters.html)


### **CISM**:[ https://uclouvain.be/en/research/cism/high-performance-computing.html](https://uclouvain.be/en/research/cism/high-performance-computing.html)

Three clusters with different characteristics (2 of which are part of the CECI
cluster):

#### Lemaitre3

- Louvain-la-Neuve
- Nodes 96 GB RAM
- dedicated to **large parallel jobs** (HPC), with a fast interconnect and a
  fast storage system
- Access CISM+CECI users
- They will install Freesurfer and PyMVPA here

#### Manneback

- Nodes 4 GB RAM
- Access CISM users only
- dedicated to High-Throughput Computing (HTC), suited for running a **very
  large number of small jobs**

## Problems

- To use matlab in the cluster: Only have license for 4 tokens (=licenses) of
  Matlab and each node uses a license (UCL has 100 Matlab token but CECI? is
  only allowed to use 4 tokens). The 4 tokens to use Matlab are now in the
  interactive serves (none is on the cluster)

## Possible Solutions

- Compile
  - Informatics department student to change the language of our script
- Octave (free)
- Buy more licenses:
  - Maybe (probably according to Damian) it’s **not possible to restrict the
    access only to us**. We have to hope that no one else accesses by hiding
    this information)
  - The price of Matlab license varies depending on the number of tokens you
    buy. Actually not in UCLouvain, Olivier called 78282 in december 2018 and
    the price of 1 licence is 100e/year, independent of the number you buy.
  - Personal license and Site license exist. The cluster uses Site license.
    (Students have personal license at a reduced price: they are not allowed to
    install it if they’re not the only user)
  - Olivier called 78282 in december 2018 and the price of 1 licence is
    100e/year.
  - Lots of people before us have tried to convince UCL to buy more licenses,
    does not work
- Use pelican interactive server (Very short term solution)

## Rookie experience with the cluster

Here the [CECI documentation](https://support.ceci-hpc.be/doc/) for creating an
account and accessing the cluster. But please do check in the folder where this
google doc is saved for quick tips for creating an account.

1.  Access the cluster: things have changed after august 2020, if you had an
    account before this date you need to follow all the steps explained
    [here](https://support.ceci-hpc.be/doc/_contents/QuickStart/ConnectingToTheClusters/FromAUnixComputer.html)
    again. It is very important that you follow all the steps in this link (e.g.
    get a private ceci key, configure ssh, …) They also provide troubleshooting
    tips.
2.  Avoiding providing password/passphrase all the time you access to the
    cluster:

Doing `ssh clustername` does not work in a vanilla way as before, you may need
to insert the pss every time or try this:

```bash
ssh-add -k ~/.ssh/id_rsa.ceci ssh-add -l ssh clustername
```

`clutername` should be replaced by the cluster you want to join, e.g. lemaitre3

Finally, if everything is working, the next time one logs in, the following
should be fine:

```bash
ssh lemaitre3
```

2.a. Troubleshooting: (26/04/2021 onwards)

Issues with connecting with the cluster.(even after following steps 1 and 2.)

![alt_text](images/image1.png "image_tooltip")

**Solution:** Since CISM changed the server gwceci.cism.ucl.ac.be .

Go to: **/Users/your_local_username/.ssh/known_hosts **

**Warning:**

In your local machine, you need to go to the folder where you keep the .ssh
folder. And in that folder you need to navigate to known_hosts. You can type as
follow in the terminal

```bash
atom ~/.ssh/known_hosts
```

Remove or comment _line 4_ as shown below. According to your known_hosts file,
the line number can vary. ![alt_text](images/image2.png "image_tooltip")

**Tip#1**: Used Atom, as evident from above, easy to edit, and save.

**Tip#2:** While using OpenConnectVPN from home, set preferences to IPV4 (and
not IPV6).

Then repeat the step2. You should log in. And if you can log in, that’s all!
This action will add another line in known*hosts document, starting with
gwceci.cism.ucl.ac.be as can be seen in above \_line 6*.

1.  Although one ssh to the cluster, the main folder is the root (cd ~). One can
    also find which folder you have access to, e.g. if you are under IPSY like
    most CPP-members, by navigating to:

```bash
cd /home/ucl/irsp/ cd $HOME cd $GLOBALSCRATCH
```

4.  You can check where you are - which folder is your home in the cluster- with
    below command

```bash
pwd
```

5. Move file to the cluster and back:

```bash
scp -r mydir/ clustername:cluster/dir/
```

```bash
scp -r clustername:cluster/dir/ mydir/
```

Note: The commands above need to be entered in a terminal that is logged into
the local machine not in the cluster-logged terminal.

Example to load a file:

```bash
scp sub-x001_ses-001_T1w.nii
lemaitre3:/home/ucl/cosy/battal/RhythmCateg/RhythmCateg_Anat
```

**Running FreeSurfer recon all stuff**

First one would need to create scripts, which should be under this
[format](https://support.ceci-hpc.be/doc/_contents/SubmittingJobs/SlurmFAQ.html).

Then follow the above examples for carrying your folder of input into the
cluster folder.

Copy from your local to the cluster:

```bash
scp -r MovieBlind_Anatomicals lemaitre3:/home/ucl/irsp/morezk/MovieBlind
```

Copy from the cluster to the local

```bash
scp -r
lemaitre3:/home/ucl/irsp/morezk/MovieBlind/MovieBlind_Anatomicals/fs_output
~/Desktop/
```

Copy scripts

```bash
scp -r run_reconall.slurm lemaitre3:/home/ucl/irsp/morezk/MovieBlind $ scp -r
run_reconall_batch.slurm lemaitre3:/home/ucl/irsp/morezk/MovieBlind
```

Lastly, when running scripts use sbatch instead of sh

This is wrong:

```bash
sh ./
```

Try:

```bash
sbatch submit.slurm
```

**How to check if the job is working/submitted successfully?**

For more general information please see this
[link](https://support.ceci-hpc.be/doc/_contents/QuickStart/SubmittingJobs/SlurmTutorial.html).

Some quick and helpful guides:
[ slurm workload manager](https://slurm.schedmd.com/documentation.html)

One can type to check if their job is R: RUNNING, PD:PENDING

```bash
squeue
```

If one uses [this](http://www.ceci-hpc.be/scriptgen.html) website to generate
their bash script, they will also get a notification email when the job is
started and done including the `job-id`.

**How to read the _slurm&lt;jobID>.out_ files?**

**.out **are error /log files.

```bash
cat slurm $jobID>.out
```

Ex: ![alt_text](images/image3.png "image_tooltip")

**Running docker stuff, example with mriQC**

To create the singularity image:

```bash
singularity pull --name ~/sing_images/mriqc_0.15.2.sif
docker://poldracklab/mriqc:0.15.2
```

To run the docker container through singularity:

```bash
    singularity run --cleanenv \
    --bind ~/data/V5_high-res_pilot-1/raw:/data \
    --bind ~/data/V5_high-res_pilot-1/derivatives/mriqc:/out \
    ~/sing_images/mriqc_0.15.2.sif \
    /data /out participant \
    --participant_label pilot001
```

### Resources

Lecture slides on singularity :
[Packaging software in portable containers with Singularity](https://indico.cism.ucl.ac.be/event/74/)

Recorded Event(lecture) :
[on Teams](https://teams.microsoft.com/l/meetup-join/19%3ameeting_MmZkOWM0YTQtN2FhOS00NGJhLWI0MWEtNmRmZWNiOWQyNDJl%40thread.v2/0?context=%7b%22Tid%22%3a%227ab090d4-fa2e-4ecf-bc7c-4127b4d582ec%22%2c%22Oid%22%3a%226677b3f8-ce21-40ac-a3f2-4440ec78487e%22%2c%22IsBroadcastMeeting%22%3atrue%7d)

### Tips

Command to navigate the folders and open text files in a terminal “gui”

```bash
mc
```

## Other

- There is **Cloud computing** (what Remi was suggesting, virtual machines) and
  **Cluster computing**. UCL only supports cluster computing for the moment.

- **To install new software:**

- They can install it
- They can be installed in the home directory of the user by the user. (At our
  own risk)

## CPPlab software

- Matlab
  - SPM
- Conn
- PyMVPA (Python compatible) -installed in Lemaitre 3
- Freesurfer -installed in Lemaitre 3
- FSL
- Mrtrix -installed in HMEM

## Relevant links

https://nl.mathworks.com/products/compiler/matlab-runtime.html
https://en.wikibooks.org/wiki/SPM/Standalone
