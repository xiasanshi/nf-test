#!/bin/bash
#===============================================================================
# TOOL    : interx v3.9
# AUTHOR  : danny zhou
# UPDATED : 2019-10-08
#
# DESCRIPTION:
#
#
# INPUT:
# raw_vcf                    : Raw vcf file
# params.interx.dbpath       : Database path
#
# OUTPUT:
# **_interx.txt              : Result after annotation
# 
#===============================================================================


if [ ! -d /workspace/${tumorId}/interx/snpindel/somatic ]; then mkdir -p -m 777 /workspace/${tumorId}/interx/snpindel/somatic;fi
if [ ! -d ${params.outdir}/somatic/snpIndel ]; then mkdir -p -m 777 ${params.outdir}/somatic/snpIndel;fi
if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

exec >/workspace/logs/${params.tag}-${tumorId}-snpindel-somatic-interx.log 2>&1


#-----------drugx target--------

/ve/bin/python3 /gcbi/bioxFlow_code/interx/interx.py -g hg19 -indic "$params.indic" -db ${params.interx.db} somatic ${drugx_targeteddrugs_snpindel_out}
