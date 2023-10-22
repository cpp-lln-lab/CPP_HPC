# Overview

To contribute see [here](https://github.com/cpp-lln-lab/CPP_HPC/contributing) 

!!! Warning

    Some of the information on this page may be outdated.

## Practical info-Contact

### CÉCI

the "Consortium des Équipements de Calcul Intensif"

- Account gives access to the clusters in French Speaking Belgium (Liege, Namur,
  Brussels, Louvain La Neuve)
- [http://www.ceci-hpc.be/clusters.html](http://www.ceci-hpc.be/clusters.html)

!!! Important

    CECI has a “Big data” survey on their website (first thing in their
    home page). They’re going to install a new cluster in Brussels and they’re
    asking for people needs. If people don’t need to process big data, a regular
    cluster will be installed. If people report that they will need to manage huge
    amounts of data, a Big-data friendly cluster will be installed. Spread this
    information.

#### CISM

“CISM” stand for “Calcul Intensif et Stockage de Masse” [Center for High
Performance Computing and Mass Storage]

- CISM is part of the CECI
- https://uclouvain.be/en/research/cism/high-performance-computing.html
- [https://uclouvain.be/en/research/cism](https://uclouvain.be/en/research/cism)
- Mail: egs-cism@listes.uclouvain.be
- Contacts:
  - thomas.keutgen@uclouvain.be (Responsible CISM- meeting guy)
  - damien.francois@uclouvain.be (other meeting guy)
- Account gives access to the interactive servers + Mannebeck cluster (not run
  by the CECI)

### Interactive Servers (one node)

[https://uclouvain.be/en/research/cism/interactive-servers.html](https://uclouvain.be/en/research/cism/interactive-servers.html)

One node, but more powerful than a personal computer and apparently there is matlab installed.

#### SMCS3&4

- 256 GB RAM
- Those 2 servers are dedicated to statistical applications. They are managed in
  collaboration with SMCS (support methodologie et calcul statistique)

#### Brufence et CeSAM (Lagrange shut down)

- 256 GB RAM
- These interactive machines are dedicated to Matlab use.

#### Pellican

- 256 GB RAM
- Has installed Matlab 2017

### High Performance Computing (cluster)

Cluster, various nodes to work in parallel.

Each cluster has a specific function/characteristic (big acceleration, big
memory capacity, large parallel jobs, very large number of small jobs…you have
to choose the cluster that best meets your necessities)

ThrFor example two clusters with different characteristics (part of the CECI cluster):

##### Lemaitre3

- Louvain-la-Neuve
- Nodes 96 GB RAM
- dedicated to large parallel jobs (HPC), with a fast interconnect and a fast
  storage system
- Access CISM+CECI users
- It has installed Freesurfer, PyMVPA and singularity (to use fmriprep, mriqc etc.)

##### Manneback

- Nodes 4 GB RAM
- Access CISM users only
- dedicated to High-Throughput Computing (HTC), suited for running a very large
  number of small jobs

### Problems

!!! note

    To use matlab in the cluster: Only have license for 4 tokens (=licenses) of
    Matlab and each node uses a license (UCL has 100 Matlab token but CECI? is
    only allowed to use 4 tokens). The 4 tokens to use Matlab are now in the
    interactive serves (none is on the cluster)

    ### Possible Solutions

    - Compile
      - Informatics department student to change the language of our script
    - Octave (free) (eg bidspm via docker/singularity)
    - Buy more licenses:
      - Maybe (probably according to Damian) it’s not possible to restrict the
        access only to us. We have to hope that no one else accesses by hiding
        this information)
      - The price of Matlab license varies depending on the number of tokens you
        buy. Actually not in UCLouvain, Olivier called 78282 in december 2018 and
        the price of 1 licence is 100e/year, independent of the number you buy.
      - Personal license and Site license exist. The cluster uses Site license.
        (Students have personal license at a reduced price: they are not allowed to
        install it if they’re not the only user)
      - Lots of people before us have tried to convince UCL to buy more licenses,
        does not work
    - Use pelican interactive server (Very short term solution)
