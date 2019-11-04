#! /bin/bash
# author : Zhang Limei; at 2019-03-10
#===============================================================================
# TOOL    : drugx target
# AUTHOR  : xialei
# UPDATED : 2019-10-25
#
# DESCRIPTION:
#
#
# INPUT:
# annox_snpindel_input                    : Raw vcf file
# params.annovar.dbpath      : Database path
# params.annovar.databases   : Annotation database list (comma-separated)
#
# OUTPUT:
# annovar_out*.txt           : Result after annotation
# 
#===============================================================================

if [ ! -d /workspace/${tumorId}/drugx/cnv/target ]; then mkdir -p -m 777 /workspace/${tumorId}/drugx/cnv/target;fi
if [ ! -d ${params.outdir}/somatic/cnv ]; then mkdir -p -m 777 ${params.outdir}/somatic/cnv;fi
if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

exec >/workspace/logs/${params.tag}-${tumorId}-cnv-somatic-drugx.log 2>&1


#-----------drugx target--------

/ve/bin/python3 /gcbi/bioxFlow_code/drugx/drugx.py target $annox_somatic_cnv_out -vriantType cnv -indic "$params.indic" -dbpath ${params.drugx.db} -outpath  /workspace/${tumorId}/drugx/cnv/target -logpath  /workspace/logs/

cp /workspace/${tumorId}/drugx/cnv/target/*_targeteddrugs.txt ${params.outdir}/somatic/cnv/seq_cnv_${tumorId}_targeteddrugs.txt
