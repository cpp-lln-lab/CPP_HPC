# Cluster code snippets

## General

- Check cluster resources

`sinfo`

## Check your running jobs

- Check how my jobs are doing

`squeue --me`

- Estimate when my jobs will start (not very reliable though)

`squeue --me --start`

- To cancel the job

`scancel YOURJOBID`

- Check how the job performed using (or not) the resources requested

`sacct --format Jobid,ReqMem,MaxRSS,TimeLimit,AllocCPU,CPUTime,TotalCPU -j YOURJOBID`