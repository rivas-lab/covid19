#!/bin/bash
set -beEuo pipefail

SRCNAME=$(readlink -f $0)
SRCDIR=$(dirname ${SRCNAME})
PROGNAME=$(basename $SRCNAME)
VERSION="0.0.1"
NUM_POS_ARGS="1"

ml load snpnet_yt/dev
# ml load snpnet

############################################################
# functions
############################################################

show_default_helper () {
    cat ${SRCNAME} | grep -n Default | tail -n+3 | awk -v FS=':' '{print $1}' | tr "\n" "\t" 
}

show_default () {
    cat ${SRCNAME} \
        | tail -n+$(show_default_helper | awk -v FS='\t' '{print $1+1}') \
        | head  -n$(show_default_helper | awk -v FS='\t' '{print $2-$1-1}')
}

usage () {
cat <<- EOF
	$PROGNAME (version $VERSION)
	Export intermediate results from snpnet
	
	Usage: $PROGNAME [options] results_dir
	  results_dir      The output directory for the snpnet
	
	Options:
	  --nCores     (-t)  Number of CPU cores
	  --memory     (-m)  The memory amount
	
	Default configurations:
	  snpnet_dir=${snpnet_dir}
EOF
    show_default | awk -v spacer="  " '{print spacer $0}'
}

############################################################
# tmp dir
############################################################
tmp_dir_root="$LOCAL_SCRATCH"
if [ ! -d ${tmp_dir_root} ] ; then mkdir -p $tmp_dir_root ; fi
tmp_dir="$(mktemp -p ${tmp_dir_root} -d tmp-$(basename $0)-$(date +%Y%m%d-%H%M%S)-XXXXXXXXXX)"
# echo "tmp_dir = $tmp_dir" >&2
handler_exit () { rm -rf $tmp_dir ; }
trap handler_exit EXIT

############################################################
# parser start
############################################################
## == Default parameters (start) == ##
nCores=4
memory=30000
genotype_pfile="@@@@@@@@@@@@@@@@@@@"
phenotype_name="_AUTO_"
## == Default parameters (end) == ##

declare -a params=()
for OPT in "$@" ; do
    case "$OPT" in 
        '-h' | '--help' )
            usage >&2 ; exit 0 ; 
            ;;
        '-v' | '--version' )
            echo $VERSION ; exit 0 ;
            ;;
        '-t' | '--nCores' )
            nCores=$2 ; shift 2 ;
            ;;
        '-m' | '--memory' )
            memory=$2 ; shift 2 ;
            ;;
        '--genotype_pfile' )
            genotype_pfile=$2 ; shift 2 ;
            ;;
        '--phenotype_name' )
            phenotype_name=$2 ; shift 2 ;
            ;;
        '--'|'-' )
            shift 1 ; params+=( "$@" ) ; break
            ;;
        -*)
            echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2 ; exit 1
            ;;
        *)
            if [[ $# -gt 0 ]] && [[ ! "$1" =~ ^-+ ]]; then
                params+=( "$1" ) ; shift 1
            fi
            ;;
    esac
done

if [ ${#params[@]} -lt ${NUM_POS_ARGS} ]; then
    echo "${PROGNAME}: ${NUM_POS_ARGS} positional arguments are required" >&2
    usage >&2 ; exit 1 ; 
fi

results_dir="${params[0]}"

############################################################
source "${snpnet_dir}/helpers/snpnet_misc.sh"
############################################################

if [ "${phenotype_name}" == "_AUTO_" ] ; then
    phenotype_name=$(basename ${results_dir})
fi

if [ ! -f "${results_dir}/snpnet.RData" ] ; then
    prevIter="$(find_prevIter ${results_dir})"
    RData_f="${results_dir}/results/output_iter_${prevIter}.RData"
    
    if [ ! -f "${RData_f%.RData}.tsv" ] ; then
        Rscript ${snpnet_dir}/helpers/export_betas.R ${RData_f} ${genotype_pfile}    
    fi
    for ext in covars.tsv tsv ; do         
        if [ -f "${RData_f%.RData}.${ext}" ] ; then
            ln -sf ${RData_f%.RData}.${ext} ${results_dir}/snpnet.${ext}
        fi
    done
    
    plink_score ${results_dir} ${phenotype_name} ${genotype_pfile} ${nCores} ${memory}
fi
