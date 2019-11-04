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

if [ ! -d /workspace/${tumorId}/sv/annox ]; then mkdir -p -m 777 /workspace/${tumorId}/sv/annox;fi
if [ ! -d ${params.outdir}/somatic/sv ]; then mkdir -p -m 777 ${params.outdir}/somatic/sv;fi
if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

exec >/workspace/logs/${params.tag}-somatic-annox-sv.log 2>&1


#-----------annox--------
#snpIndel
#cnv
#sv

if [ `grep -Ev '^[[:space:]].*|^#' $sv_paired_vcf | wc -l` == 0 ];
then
    echo "After filter the line of somatic vcf is 0"

    /bin/bash nextflow run /gcbi/bioxFlow_code/annoxFlow/annoFlow-sv.nf \
--inputfile $sv_paired_vcf \
--genome ${params.genome} \
--type vcf \
--mode somatic \
--rawvcf $sv_paired_vcf \
--outpath /workspace/${tumorId}/sv/annox \
--bedFile ${params.bedFile} \
--drugs false \
--cancertype "cancer" \
--logpath /workspace/logs/ \
-params-file ${params.annox.config} \
-c /gcbi/bioxFlow_code/annoxFlow/nextflow.config
	
else
    /bin/bash nextflow run /gcbi/bioxFlow_code/annoxFlow/annoFlow-sv.nf \
--inputfile $sv_paired_vcf \
--genome ${params.genome} \
--type vcf \
--mode somatic \
--rawvcf $sv_paired_vcf \
--outpath /workspace/${tumorId}/sv/annox \
--bedFile ${params.bedFile} \
--drugs false \
--cancertype "cancer" \
--logpath /workspace/logs/ \
-params-file ${params.annox.config} \
-c /gcbi/bioxFlow_code/annoxFlow/nextflow.config

fi

cp /workspace/${tumorId}/sv/annox/*_annox.txt ${params.outdir}/somatic/sv/seq_sv_${tumorId}_annox.txt
