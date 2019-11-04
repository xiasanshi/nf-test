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


if [ ! -d /workspace/${tumorId}/interx/cnv/somatic ]; then mkdir -p -m 777 /workspace/${tumorId}/interx/cnv/somatic;fi
if [ ! -d ${params.outdir}/somatic/cnv ]; then mkdir -p -m 777 ${params.outdir}/somatic/cnv;fi
if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

exec >/workspace/logs/${params.tag}-${tumorId}-cnv-somatic-interx.log 2>&1


#-----------drugx target--------

/ve/bin/python3 /gcbi/bioxFlow_code/interx/interx.py -g hg19 -indic "$params.indic" -db ${params.interx.db} cnv ${drugx_targeteddrugs_cnv_out}
