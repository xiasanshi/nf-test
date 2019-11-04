#!/bin/bash
# 
#===============================================================================
# TOOL    : gcasa model
# AUTHOR  : xialei
# UPDATED : 2019-10-17
#
# DESCRIPTION:
#
#
# INPUT:
# variant_calling_somatic_raw_vcf
# sampleId == ${params.tag}          : processId
# genomeVersion == ${params.genome}          : processId
# baseQualityTrimming == ${params.preproc.baseQualityTrimming}
# fileType == ${params.preproc.fileType}
# paired == true
# filterMethod = ${params.hard_filter.filterMethod}
# filterToolArguFile == ${params.hard_filter.filterToolArguFile}
# maxCores == ${params.hard_filter.maxCores}
# umiFlag == ${params.umiFlag}
# logFile
# workdir
#
# OUTPUT:
# annovar_out*.txt           : Result after annotation
# preprocessDir           : preprocessDir
# 
#===============================================================================
if [ ! -d ${params.outdir}/somatic/snpIndel ]; then mkdir -p -m 777 ${params.outdir}/somatic/snpIndel;fi

if [ ! -d /workspace/${tumorId}/filter ]; then mkdir -p -m 777 /workspace/${tumorId}/filter;fi

if [ ! -d /workspace/${params.tag}/filter ]; then mkdir -p -m 777 /workspace/${params.tag}/filter;fi

if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi


exec >/workspace/logs/${params.tag}-variant-filter.log 2>&1

echo "############# filter############"
echo "PYTHONPATH=\"/gcbi/analyze/variant_filter\" python3 -m task.filter_workflow run file:/workspace/${params.tag}/filter/1  --workDir=/workspace/${params.tag}/filter/ --maxCores ${params.hard_filter.maxCores} --message {\"processId\":\"${params.tag}\",\"processType\":\"variantFilter\",\"accession\":\"${params.tag}\",\"toolVendor\":\"${params.toolVendor}\",\"filterMethod\":\"${params.hard_filter.filterMethod}\",\"inputFileList\":[{\"storeId\":\"file://${variant_calling_somatic_raw_vcf}\",\"resultType\":\"seq_raw_vcf_file\"}],\"filterToolArguFile\":\"file://${params.hard_filter.filterToolArguFile}\",\"genomeVersion\":\"${params.genome}\",\"bedTarget\":\"file://${params.bedFile}\",\"resultPath\":\"file://${params.outdir}/somatic/snpIndel\",\"hotspots\":\"${params.variant_calling.hotspots}\"}"


########## variant filter ##############
PYTHONPATH="/gcbi/analyze/variant_filter" python3 -m task.filter_workflow run file:/workspace/${params.tag}/filter/1  --workDir=/workspace/${params.tag}/filter/ --maxCores ${params.hard_filter.maxCores} --message "{\"processId\":\"${params.tag}\",\"processType\":\"variantFilter\",\"accession\":\"${params.tag}\",\"toolVendor\":\"${params.toolVendor}\",\"filterMethod\":\"${params.hard_filter.filterMethod}\",\"inputFileList\":[{\"storeId\":\"file://${variant_calling_somatic_raw_vcf}\",\"resultType\":\"seq_raw_vcf_file\"}],\"filterToolArguFile\":\"file://${params.hard_filter.filterToolArguFile}\",\"genomeVersion\":\"${params.genome}\",\"bedTarget\":\"file://${params.bedFile}\",\"resultPath\":\"file://${params.outdir}/somatic/snpIndel\",\"hotspots\":\"${params.variant_calling.hotspots}\"}"

cp ${params.outdir}/somatic/snpIndel/seq_filter_vcf_file-* ${params.outdir}/somatic/snpIndel/seq_snpindel_${tumorId}_${params.toolVendor}.raw.filtered.vcf
