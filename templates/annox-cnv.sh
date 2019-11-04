#! /bin/bash
# author : Zhang Limei; at 2019-03-10
#===============================================================================
# TOOL    : annox
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

if [ ! -d /workspace/${tumorId}/cnv/annox ]; then mkdir -p -m 777 /workspace/${tumorId}/cnv/annox;fi
if [ ! -d ${params.outdir}/somatic/cnv ]; then mkdir -p -m 777 ${params.outdir}/somatic/cnv;fi
if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

exec >/workspace/logs/${params.tag}-somatic-annox-cnv.log 2>&1


#-----------annox--------
#snpIndel
#cnv
#cnv

if [ `grep -Ev '^[[:space:]].*|^#' $cnv_paired_vcf | wc -l` == 0 ];
then
    echo "After filter the line of somatic vcf is 0"
	
   cp /gcbi/bioxFlow_code/repo/seq_cnv_annox.txt /workspace/${tumorId}/cnv/annox/seq_cnv_${tumorId}_annox.txt
	
else
    /bin/bash nextflow run /gcbi/bioxFlow_code/annoxFlow/annoFlow-cnv.nf \
--inputfile $cnv_paired_vcf \
--genome ${params.genome} \
--type tsv \
--mode somatic \
--outpath /workspace/${tumorId}/cnv/annox \
--bedFile ${params.bedFile} \
--drugs false \
--cancertype "cancer" \
--logpath /workspace/logs/ \
-params-file ${params.annox.config} \
-c /gcbi/bioxFlow_code/annoxFlow/nextflow.config

fi

cp /workspace/${tumorId}/cnv/annox/*_annox.txt ${params.outdir}/somatic/cnv/seq_cnv_${tumorId}_annox.txt
