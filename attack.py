import os
import multiprocessing as mp
import numpy as np
import numpy.linalg as LA
import argparse
from multiprocessing import Process



def SVD(mat, rank, proc_id):
    print('[rank {} -> process {}] >>> invoked <<<'.format(rank, proc_id))
    while True: LA.svd(mat)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='get allowed hostname')
    parser.add_argument('-H', '--legal-host', type=str, required=True, 
                        help='get allowed hostname')
    parser.add_argument('-I', '--indiscriminate', action='store_true', required=False, 
                        help='get indiscriminate flag')
    args = parser.parse_args()
    host, indisc_flag = args.legal_host, args.indiscriminate
    
    curr_host = os.environ.get('SLURMD_NODENAME', 'non-slurm')
    rank = os.environ.get('SLURM_PROCID', 'non-slurm')
    
    if curr_host != 'non-slurm' and curr_host != host:
        if indisc_flag:
            print('[rank {}] runs on {}, keep running'.format(rank, curr_host))
        else:
            print('[rank {}] runs on {}, safely killed'.format(rank, curr_host))
            exit()

    mp.set_start_method('fork')
    print('[rank {}] using start method >>> {} <<<'.format(rank, mp.get_start_method()))

    mat = np.random.randn(252, 125, 62, 31) + \
            1j * np.random.randn(252, 125, 62, 31)

    procs = []
    print('[rank {}] >>>>>>>>>> starting <<<<<<<<<<'.format(rank))
    for idx in range(999):
        proc = Process(target=SVD, args=(mat, rank, idx))
        proc.start()
        procs.append(proc)

    print('[rank {}] >>>>>>>>>> joining <<<<<<<<<<'.format(rank))
    for proc in procs:
        proc.join()


