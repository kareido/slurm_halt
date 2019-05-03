# slurm_halt
a magic to slow down nodes on slurm clusters

#### example case:
```bash
git clone https://github.com/kareido/slurm_halt.git

cd slurm_halt

sh MultiTAR.sh -h

# USAGE: MultiTAR.sh <OPTIONS...>
#        [-h][-n, --ntasks[=]<total num of tasks>, maximum num of tasks]
#        [-h][-p, --partition=<srun partition>, specify slurm partition]
#        [-h][-X, --indiscriminate, suppress safely kill functionality]
#        [-h][-w, --target-nodes[=]<num cpus per task>, specify victim(s)]

sh MultiTAR.sh --partition Test --indiscriminate
...
...
```  
