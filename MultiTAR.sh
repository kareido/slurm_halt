#!/usr/bin/bash 
# MultiTAR: Multi-Tasked Attacking Resolution

default_num_tasks=32
OPTSPEC=":Xshnpw-:"
echo

while getopts "$OPTSPEC" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                target-nodes)
                    target="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    ;;
                target-nodes=*)
                    target=${OPTARG#*=}
                    ;;
                partition)
                    partition="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    ;;
                partition=*)
                    partition=${OPTARG#*=}
                    ;;
                ntasks)
                    tasks="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    ;;
                ntasks=*)
                    tasks=${OPTARG#*=}
                    ;;
                indiscriminate)
                    indiscriminate_flag='--indiscriminate'
                    ;;
                *)
                    if [ "$OPTERR" = 1 ]; then
                        echo -e "\e[41m [ERROR] UNKNOWN ARGUMENT '-${OPTARG}' SPECIFIED \e[0m" >&2
                        exit 2
                    fi
                    ;;
            esac;;
        X)
            indiscriminate_flag='--indiscriminate'
            ;;
        h)
            echo "USAGE: $0 <OPTIONS...>" >&2
            echo "       [-h][-n, --ntasks[=]<total num of tasks>, maximum num of tasks]" >&2
            echo "       [-h][-p, --partition=<srun partition>, specify slurm partition]" >&2
            echo "       [-h][-X, --indiscriminate, suppress safely kill functionality]" >&2
            echo "       [-h][-w, --target-nodes[=]<num cpus per task>, specify victim(s)]" >&2
            echo
            exit 2
            ;;
        n)
            tasks="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
            ;;
        w)
            target="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
            ;;
        p)
            partition="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
            ;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${OPTSPEC:0:1}" = ":" ]; then
                echo -e "\e[41m [ERROR] UNKNOWN ARGUMENT '-${OPTARG}' SPECIFIED \e[0m" >&2
                exit 2
            fi
            ;;
    esac
done


if [ -z "${tasks}" ]; then
    tasks=${default_num_tasks}
fi

if [ -z "${partition}" ]; then
    echo -e "\e[41m [ERROR] PARTITION(--partition or -p) NOT SPECIFIED \e[0m"  >&2
    exit 2
fi

if [ -z "${target}" ]; then
    if [ -z "${indiscriminate_flag}" ]; then
        echo -e "\e[41m [ERROR] VICTIM(S)(--target-nodes or -w) NOT SPECIFIED \e[0m"  >&2
        exit 2
    fi
fi

if ! [ -z "${indiscriminate_flag}" ]; then
    echo -e "\e[46m [>>>>>>> WARNING <<<<<<<] INDISCRIMINATE ATTACKING MODE SPECIFIED \e[0m"
fi


echo          '___________________________________________________________________'
echo -e '\e[43m STARTING > NOTICE < DANGER: THIS PROGRAM IS EXTREMELY VIOLENT ... \e[0m'
echo -e '\e[43m YOU HAVE >>> 10 <<< SECONDS TO KILL THIS BEFORE IT ACTUALLY RUNS. \e[0m'
echo          '‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾'

sleep 10 && srun -K -J multitar -p ${partition} -w ${target} -n${tasks} \
python -u attack.py --legal-host=${target} ${indiscriminate_flag}

