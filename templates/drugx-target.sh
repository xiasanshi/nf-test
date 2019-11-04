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

if [ ! -d /workspace/${tumorId}/drugx/snpindel/target ]; then mkdir -p -m 777 /workspace/${tumorId}/drugx/snpindel/target;fi
if [ ! -d ${params.outdir}/somatic/snpIndel ]; then mkdir -p -m 777 ${params.outdir}/somatic/snpIndel;fi
if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

exec >/workspace/logs/${params.tag}-${tumorId}-snpindel-somatic-drugx.log 2>&1


#-----------drugx target--------

/ve/bin/python3 /gcbi/bioxFlow_code/drugx/drugx.py target $annox_somatic_snpindel_out -vriantType snpindel -indic "$params.indic" -dbpath ${params.drugx.db} -outpath  /workspace/${tumorId}/drugx/snpindel/target -logpath  /workspace/logs/

cp /workspace/${tumorId}/drugx/snpindel/target/*_targeteddrugs.txt ${params.outdir}/somatic/snpIndel/seq_snpindel_${tumorId}_targeteddrugs.txt
