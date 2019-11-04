#!/bin/bash
#===============================================================================
# TOOL    : annovar 2018-04-16 00:43:31 -0400 (Mon, 16 Apr 2018)
# AUTHOR  : danny zhou
# UPDATED : 2019-10-08
#
# DESCRIPTION:
#
#
# INPUT:
# variant_calling_somatic_filter_vcf                    : Raw vcf file
# params.annovar.dbpath      : Database path
# params.annovar.databases   : Annotation database list (comma-separated)
#
# OUTPUT:
# annovar_out*.txt           : Result after annotation
# 
#===============================================================================

if [ ! -d /workspace/${tumorId}/annovar ]; then mkdir -p -m 777 /workspace/${tumorId}/annovar;fi
if [ ! -d ${params.outdir}/somatic/snpIndel ]; then mkdir -p -m 777 ${params.outdir}/somatic/snpIndel;fi
if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

exec >/workspace/logs/${params.tag}-somatic-annovar.log 2>&1

# convert vcf4 to avinput
perl /gcbi/bioxFlow_code/annoxFlow/annovar/convert2annovar.pl -format vcf4 --keepindelref $variant_calling_somatic_filter_vcf > /workspace/${tumorId}/annovar/${tumorId}.avinput

# annotation using annovar
perl /gcbi/bioxFlow_code/annoxFlow/annovar/table_annovar.pl \
    /workspace/${tumorId}/annovar/${tumorId}.avinput \
    $params.annovar.dbpath \
    -buildver hg19 \
    --outfile /workspace/${tumorId}/annovar/${tumorId} \
    --thread 1 -remove \
    -protocol $params.annovar.databases \
    -operation $params.annovar.operates \
    -nastring ''

cp /workspace/${tumorId}/annovar/${tumorId}*_multianno.txt ${params.outdir}/somatic/snpIndel/seq_snpindel_${tumorId}_annovar.txt