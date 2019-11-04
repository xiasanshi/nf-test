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

if [ ! -d /workspace/${normalId}/annox ]; then mkdir -p -m 777 /workspace/${normalId}/annox;fi
if [ ! -d ${params.outdir}/germline/snpIndel ]; then mkdir -p -m 777 ${params.outdir}/germline/snpIndel;fi
if [ ! -d ${params.outdir}/germline/mmr ]; then mkdir -p -m 777 ${params.outdir}/germline/mmr;fi
if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

exec >/workspace/logs/${params.tag}-germline-annox.log 2>&1


#-----------annox--------
#snpIndel
#cnv
#sv

if [ `grep -Ev '^[[:space:]].*|^#' $germline_valcall_raw_vcf | wc -l` == 0 ];
then
    echo "After filter the line of germline vcf is 0"

    /bin/bash nextflow run /gcbi/bioxFlow_code/annoxFlow/annoFlow-snv.nf \
--inputfile $germline_valcall_raw_vcf \
--genome ${params.genome} \
--type vcf \
--mode germline \
--rawvcf $germline_valcall_raw_vcf \
--outpath /workspace/${normalId}/annox \
--bedFile ${params.bedFile} \
--drugs false \
--cancertype "cancer" \
--logpath /workspace/logs/ \
-params-file ${params.annox.config} \
-c /gcbi/bioxFlow_code/annoxFlow/nextflow.config
	
else
    /bin/bash nextflow run /gcbi/bioxFlow_code/annoxFlow/annoFlow-snv.nf \
--inputfile $germline_valcall_filter_vcf \
--genome ${params.genome} \
--type vcf \
--mode germline \
--rawvcf $germline_valcall_filter_vcf \
--outpath /workspace/${normalId}/annox \
--bedFile ${params.bedFile} \
--drugs false \
--cancertype "cancer" \
--logpath /workspace/logs/ \
-params-file ${params.annox.config} \
-c /gcbi/bioxFlow_code/annoxFlow/nextflow.config

fi

cp /workspace/${normalId}/annox/*_annox.txt ${params.outdir}/germline/snpIndel/seq_snpindel_${normalId}_annox.txt
cp /workspace/${normalId}/annox/*_vcfinfo.txt ${params.outdir}/germline/snpIndel/seq_snpindel_${normalId}_vcfinfo.txt
cp /workspace/${normalId}/annox/*_mmr.txt ${params.outdir}/germline/mmr/seq_mmr_${normalId}_mmr.txt
#cp /workspace/${normalId}/annox/*_tmb.txt ${params.outdir}/germline/snpIndel/seq_tmb_${normalId}_tmb.txt
