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

if [ ! -d /workspace/${tumorId}/annox ]; then mkdir -p -m 777 /workspace/${tumorId}/annox;fi
if [ ! -d ${params.outdir}/somatic/snpIndel ]; then mkdir -p -m 777 ${params.outdir}/somatic/snpIndel;fi
if [ ! -d ${params.outdir}/somatic/mmr ]; then mkdir -p -m 777 ${params.outdir}/somatic/mmr;fi
if [ ! -d ${params.outdir}/somatic/tmb ]; then mkdir -p -m 777 ${params.outdir}/somatic/tmb;fi
if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

exec >/workspace/logs/${params.tag}-somatic-annox.log 2>&1


#-----------annox--------
#snpIndel
#cnv
#sv

if [ `grep -Ev '^[[:space:]].*|^#' $annox_snpindel_input | wc -l` == 0 ];
then
    echo "After filter the line of somatic vcf is 0"

    /bin/bash nextflow run /gcbi/bioxFlow_code/annoxFlow/annoFlow-snv.nf \
--inputfile $annox_snpindel_raw_input \
--genome ${params.genome} \
--type vcf \
--mode somatic \
--rawvcf $annox_snpindel_raw_input \
--outpath /workspace/${tumorId}/annox \
--bedFile ${params.bedFile} \
--drugs false \
--cancertype "cancer" \
--logpath /workspace/logs/ \
-params-file ${params.annox.config} \
-c /gcbi/bioxFlow_code/annoxFlow/nextflow.config
	
else
    /bin/bash nextflow run /gcbi/bioxFlow_code/annoxFlow/annoFlow-snv.nf \
--inputfile $annox_snpindel_input \
--genome ${params.genome} \
--type vcf \
--mode somatic \
--rawvcf $annox_snpindel_raw_input \
--outpath /workspace/${tumorId}/annox \
--bedFile ${params.bedFile} \
--drugs false \
--cancertype "cancer" \
--logpath /workspace/logs/ \
-params-file ${params.annox.config} \
-c /gcbi/bioxFlow_code/annoxFlow/nextflow.config

fi

cp /workspace/${tumorId}/annox/*_annox.txt ${params.outdir}/somatic/snpIndel/seq_snpindel_${tumorId}_annox.txt
cp /workspace/${tumorId}/annox/*_vcfinfo.txt ${params.outdir}/somatic/snpIndel/seq_snpindel_${tumorId}_vcfinfo.txt
cp /workspace/${tumorId}/annox/*_mmr.txt ${params.outdir}/somatic/mmr/seq_mmr_${tumorId}_mmr.txt
cp /workspace/${tumorId}/annox/*_tmb.txt ${params.outdir}/somatic/tmb/seq_tmb_${tumorId}_tmb.txt
