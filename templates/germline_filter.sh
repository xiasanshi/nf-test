#!/bin/bash
#===============================================================================
# TOOL    : gcasa model
# AUTHOR  : xialei
# UPDATED : 2019-10-23
#
# DESCRIPTION:
#
#
# INPUT:
# seq_sorted_somatic_bam_file
# seq_somatic_bam_index_file
# seq_sorted_germline_bam_file
# seq_germline_bam_index_file
# sampleId == ${params.tag}          : processId
# genomeVersion == ${params.genome}          : processId
# hotspots == ${params.variant_calling.hotspots}
# includeDuplication == ${params.variant_calling.includeDuplication}
# variantCallingTool == ${params.variant_calling.variantCallingTool}
# paired == ${params.paired}
# callingToolArguFile == ${params.variant_calling.callingToolArguFile}
# baseRecalibration == ${params.variant_calling.baseRecalibration}
# maxCores == ${params.variant_calling.maxCores}
# umiFlag == ${params.umiFlag}
# logFile
# workdir
#
# OUTPUT:
# annovar_out*.txt           : Result after annotation
# preprocessDir           : preprocessDir
# 
#===============================================================================
if [ ! -d /workspace/${normalId}/filter/ ]; then mkdir -p -m 777 /workspace/${normalId}/filter/;fi
if [ ! -d  ${params.outdir}/germline/snpIndel/ ]; then mkdir -p -m 777  ${params.outdir}/germline/snpIndel/;fi

if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

if [ ! -d /workspace/${params.tag}/germline/filter ]; then mkdir -p -m 777 /workspace/${params.tag}/germline/filter ;fi

exec >/workspace/logs/${params.tag}-germline-variant-filter.log 2>&1

echo "########## variant filter ##############" 
echo "PYTHONPATH=\"/gcbi/analyze/variant_filter\" python3 -m task.filter_workflow run file:/workspace/${params.tag}/germline/filter/1  --workDir=/workspace/${params.tag}/germline/filter/ --maxCores ${params.germline_hard_filter.maxCores} --message {\"processId\":\"${params.tag}\",\"processType\":\"variantFilter\",\"accession\":\"${normalId}\",\"toolVendor\":\"${params.toolVendor}\",\"filterMethod\":\"${params.germline_hard_filter.germline_filterMethod}\",\"inputFileList\":[{\"storeId\":\"file://${germline_valcall_raw_vcf}\",\"resultType\":\"seq_raw_vcf_file\"}],\"filterToolArguFile\":\"file://${params.germline_hard_filter.germline_filterToolArguFile}\",\"genomeVersion\":\"${params.genome}\",\"bedTarget\":\"file://${params.bedFile}\",\"resultPath\":\"file:///workspace/${normalId}/filter/\",\"hotspots\":\"${params.germline_hard_filter.hotspots}\"}"

PYTHONPATH="/gcbi/analyze/variant_filter" python3 -m task.filter_workflow run file:/workspace/${params.tag}/germline/filter/1  --workDir=/workspace/${params.tag}/germline/filter/ --maxCores ${params.germline_hard_filter.maxCores} --message "{\"processId\":\"${params.tag}\",\"processType\":\"variantFilter\",\"accession\":\"${normalId}\",\"toolVendor\":\"${params.toolVendor}\",\"filterMethod\":\"${params.germline_hard_filter.germline_filterMethod}\",\"inputFileList\":[{\"storeId\":\"file://${germline_valcall_raw_vcf}\",\"resultType\":\"seq_raw_vcf_file\"}],\"filterToolArguFile\":\"file://${params.germline_hard_filter.germline_filterToolArguFile}\",\"genomeVersion\":\"${params.genome}\",\"bedTarget\":\"file://${params.bedFile}\",\"resultPath\":\"file:///workspace/${normalId}/filter/\",\"hotspots\":\"${params.germline_hard_filter.hotspots}\"}"

cp /workspace/${normalId}/filter/seq_filter_vcf_file-*filtered.vcf ${params.outdir}/germline/snpIndel/seq_snpindel_${normalId}_${params.toolVendor}.raw.filtered.vcf
