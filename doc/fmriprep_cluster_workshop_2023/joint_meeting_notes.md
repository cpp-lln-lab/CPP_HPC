# Joint Meeting on fMRI data - St Luc to fMRIprep

Interesting slides & other stuff :

- Remi’s slides on BIDS :
  [https://remi-gau.github.io/bids_workshop/](https://remi-gau.github.io/bids_workshop/)
- CECI cluster documentation page :
  [https://support.ceci-hpc.be/doc/](https://support.ceci-hpc.be/doc/)


## fMRIprep

It is a BIDSapp so there is a classical way to use it.

See BIDSapps page :
[https://remi-gau.github.io/bids_workshop/bids_apps.html](https://remi-gau.github.io/bids_workshop/bids_apps.html)

Through docker : Everything you do on docker will be done in your terminal.

For the cluster : you will use “Singularity”, quite similar overall.

### Docker or Singularity ?

They are “virtual machines” somehow, you need to tell them a certain mapping
between your folders in your machine and inside the container.

_Careful : Docker by default :_ inside the virtual machine you are the root user
(admin), you have to change the permission so that you have write/change
permissions on the data that will be in your computer. That needs to be done
before running the conversion/analyses..

```bash
--user "$(id -u):$(id -g)"
```

### Usage

fMRIprep has extensive documentation :
[https://fmriprep.org/en/stable/](https://fmriprep.org/en/stable/)

!!! Important

    When using fMRIPrep, use the **working directory option **: it
    allows to save “temporary” analytical steps, so that if it crashes/stops, you
    will not need to re-run it again from scratch, it will start again at the point
    where it crashed/was killed/stopped. There are a lot of checkpoints where it can
    re-start.

    ```bash
    --work-dir /tmp
    ```

    If you use it : it saves all the intermediate steps : that’s a lot of data, so
    you can run out of space.

    Eg. you run participant 1, whenever participant 1 has finished, delete all the
    tmp files.

    Unless you want to try different options and don’t want to start each time from
    scratch, than you can keep it, but once you’ve finished testing options etc you
    delete it all.

Note that fmriprep runs with freesurfer.

You will not have the data from each step of preprocessing.

It will give you a .tsv file with the confounds

Specific options from fMRIPrep that are interesting other than that :

- `[--stop-on-first-crash]`

Think about using the BIDS validator on your dataset beforehand. Even though by
default, fmriprep runs a bids validation step (you can ask it to skip that step
but not recommended).

You can (should) directly copy/paste the “methods” section from the fmriprep
outputs : it writes down every single step and options (and versions) you used
for preprocessing.

Example of a script of fmriprep on container :

[https://github.com/cpp-lln-lab/CPP_brewery/blob/master/remi/containers/code/run_fmriprep.sh](https://github.com/cpp-lln-lab/CPP_brewery/blob/master/remi/containers/code/run_fmriprep.sh)

### Running fmriprep / mriqc on the cluster

What’s amazing is that you can just run it and do not worry about it.
You can ask it to send you emails when the job starts/stops/crashes…

There is no user interface, you need to get familiar
with using terminal lines only, and get used to some specific lines.

You can use it anywhere in the world.

1. Need to use Singularity
   1. [https://hackmd.io/b4nfl4ZFSSOqD6lM6salVw?both](https://hackmd.io/b4nfl4ZFSSOqD6lM6salVw?both)

We should look at our own cluster specifications but globally it should be
similar.

#### Main steps

1. From your terminal window : you want to connect with ssh name@cluster & asks
   your password (and you will need ssh keys). Now you are in your cluster

   1. For the CECI see the doc:

      [https://support.ceci-hpc.be/doc/\_contents/QuickStart/ConnectingToTheClusters/FromAUnixComputer.html](https://support.ceci-hpc.be/doc/_contents/QuickStart/ConnectingToTheClusters/FromAUnixComputer.html)

2. You need to load the things you need to use (each time). Depending on your
   cluster, there will be modules available already ,but you need to call it to
   retrieve it.

   Look at the available modules and retrieve the needed modules. Module avail :
   list the modules available // module load : loads the module you want

3. Transferring files from your computer to your cluster

4. Secure copy : `scp`. To copy individual files / directories from your computer
   to the cluster. `scp <name file>` and where you want to copy it (see the
   documentation above). This is for small files.
5. Rsync : syncing.
6. Datalad : easiest way because there is version control. You can pull the data
   from there to the cluster. You need to have datalad on the cluster or install
   it. (we should check that) Here how to install it on the CECI cluster
   https://github.com/cpp-lln-lab/CPP_HPC

7. Submitting jobs
8. A job is a batchscript that you will submit to the cluster.
9. The CECI has a wizard to help you create those script:
   [https://www.ceci-hpc.be/scriptgen.html](https://www.ceci-hpc.be/scriptgen.html)
10. Depending on who is using the cluster in the moment, how many people, what
    you have used before, you will be scheduled at a certain moment. For
    instance, if you haven’t used the cluster in a long time they give you
    priority.
11. You need to decide how much time the analysis is going to need. For fmriprep
    & mriqc there are online some examples of how long it should take. After
    tests you can check how much time it took, how much memory etc… and then
    adjust (stats from your analysis). If the time you allocated is not enough,
    you get kicked out, it stops. That’s when the work directory is super
    important. For the kind of analyses we are doing we can ask a bit more time
    than what you actually need to be sure, as long as you don’t need the
    cluster super often.

Submitting jobs with slurm on the CECI Cluster :

[https://support.ceci-hpc.be/doc/\_contents/QuickStart/SubmittingJobs/SlurmTutorial.html](https://support.ceci-hpc.be/doc/_contents/QuickStart/SubmittingJobs/SlurmTutorial.html)

If you want to write a script you can use a line that opens an editor within the
terminal.

Example : `nano sbatch simplejob.sh`

Example below from Michele’s HackMD

```bash

#!/bin/bash That’s a general line you have to put

#SBATCH --time=00:05:00  Specify the time

#SBATCH --account=def-flepore Specify the account

echo 'Hello, world!' And your script…

sleep 20

```

`sq` gives you the information on the jobs that you have asked to run.

But instead of that you just ask for emails because `sq` is computationally
greedy

For this you put the following lines at the very top of your script

```bash
    #SBATCH --mail-user=michele.maclean@umontreal.ca
    #SBATCH --mail-type=BEGIN
    #SBATCH --mail-type=END
    #SBATCH --mail-type=FAIL
    #SBATCH --mail-type=REQUEUE
    #SBATCH --mail-type=ALL
```

How to cancel a job :

`scancel <jobid>`

##### Output files

By default, the outputs go to output files called slurm- with the job ID.

**Scratch directory **

After a certain timeline, all the files will be automatically deleted. This
allows you to have more space and don’t need to worry about deleting your files.
You will get an email before that.

The scratch directory will be in the cluster, maybe in the team directory or
yours depending on the cluster.

For fmriprep you need to download the singularity image of fmriprep : one that
works is the reproname container. It has datalad containers for fmriprep/mriqc
etc..

[https://github.com/ReproNim/containers](https://github.com/ReproNim/containers)

You have a container of everything that’s needed to run fmriprep/mriqc on your
cluster.

You create a directory with mkdir (make directory), and install the containers
from repronim. Online they have everything that you need, and you pull the
images you need. You need datalad installed on the cluster for that.

You can also use an image for fmriprep that you already have on your computer
(if you have done that previously, but not recommended if you are beginning this
process).

```bash
datalad install https://github.com/ReproNim/containers.git

datalad get containers/images/bids/bids-fmriprep--21.0.1.sing

datalad unlock containers/images/bids/bids-fmriprep--21.0.1.sing
```

Depending on the cluster “unlock” is needed or not.

For fmriprep & mriqc you need a freesurfer license: user specific (free). It is
a .txt file.

[https://surfer.nmr.mgh.harvard.edu/registration.html](https://surfer.nmr.mgh.harvard.edu/registration.html)

You copy paste it from your computer to the cluster with the secure copy (scp
command).

**Writing a script**

Idea : have a basic script on github that we modify

-J : job you want to run

-account : account you want to use

-time : time you want

-n :

-cpus per task : how much cpus you want to allocate

In the script have the things you want to load so that you don’t forget and have
to run it before. You need to load each module each time.

Singularity run : that’s the main line of the script

`\` : tells it that the script continues but on another line

The lines of code for fmriprep are the same, except that you use singularity.

**What’s important :**

you need to mount the files you want to analyze into the
container. `-B` : mount what’s in my user into the container. If you don’t do
that it won’t know where the files are because it would be “stuck” in the image.

- For instance you want to mount the `scratch` directory, all the folders in the
  user, and you need to say which image of fmriprep you will use.
- Then you specify where you take the data from, because you mounted your user
  directory, you can start from that (eg. `/maclean/`).
- Then the name of your output.
- You specify the participants label.
- Working directory
- License file
- Output space you want (MNI152…)
- Options like skipping bids validation or stop on first scratch etc…

**Launch it :** sbatch fmriprep.sh

_Running mriqc : same but the image you need will be mriqc_

Options are different but the lines are similar

CECI Cluster

Main webpage : [https://www.ceci-hpc.be/](https://www.ceci-hpc.be/)

Documentation :
[https://support.ceci-hpc.be/doc/](https://support.ceci-hpc.be/doc/)

Make a script:
[https://www.ceci-hpc.be/scriptgen.html](https://www.ceci-hpc.be/scriptgen.html)

The cluster we will use is most likely **Lemaître3**

To connect to the cluster :

[https://support.ceci-hpc.be/doc/\_contents/QuickStart/ConnectingToTheClusters/FromAUnixComputer.html#get-the-private-ceci-key](https://support.ceci-hpc.be/doc/_contents/QuickStart/ConnectingToTheClusters/FromAUnixComputer.html#get-the-private-ceci-key)
