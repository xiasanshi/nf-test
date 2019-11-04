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

if [ ! -d /workspace/${normalId}/variant_calling/ ]; then mkdir -p -m 777 /workspace/${normalId}/variant_calling/;fi
if [ ! -d  ${params.outdir}/germline/snpIndel/ ]; then mkdir -p -m 777  ${params.outdir}/germline/snpIndel/;fi

if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

if [ ! -d /workspace/${params.tag}/germline/variant_calling ]; then mkdir -p -m 777 /workspace/${params.tag}/germline/variant_calling ;fi

exec >/workspace/logs/${params.tag}-germline-variant-calling.log 2>&1




echo "PYTHONPATH=\"/gcbi/analyze/variation_calling\" python3 -m task.vc_workflow run file:/workspace/${params.tag}/germline/variant_calling/1  --workDir=/workspace/${params.tag}/germline/variant_calling/ --maxCores ${params.germline_variant_calling.maxCores} --message {\"accession\":\"${normalId}\",\"baseRecalibration\":${params.germline_variant_calling.germline_baseRecalibration},\"bedTarget\":\"file://${params.bedFile}\",\"callingToolArguFile\":\"file://${params.germline_variant_calling.germline_callingToolArguFile}\",\"genomeVersion\":\"${params.genome}\",\"includeDuplication\":${params.germline_variant_calling.germline_includeDuplication},\"inputFileList\":[{\"resultType\":\"seq_sorted_bam_file\",\"storeId\":\"file://${seq_sorted_germline_bam_file}\"},{\"resultType\":\"seq_bam_index_file\",\"storeId\":\"file://${seq_germline_bam_index_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"variationCalling\",\"resultPath\":\"file:///workspace/${normalId}/variant_calling/\",\"variantCallingTool\":\"${params.germline_variant_calling.germline_variantCallingTool}\"}"	
########### variant calling #############
PYTHONPATH="/gcbi/analyze/variation_calling" python3 -m task.vc_workflow run file:/workspace/${params.tag}/germline/variant_calling/1  --workDir=/workspace/${params.tag}/germline/variant_calling/ --maxCores ${params.germline_variant_calling.maxCores} --message "{\"accession\":\"${normalId}\",\"baseRecalibration\":${params.germline_variant_calling.germline_baseRecalibration},\"bedTarget\":\"file://${params.bedFile}\",\"callingToolArguFile\":\"file://${params.germline_variant_calling.germline_callingToolArguFile}\",\"genomeVersion\":\"${params.genome}\",\"includeDuplication\":${params.germline_variant_calling.germline_includeDuplication},\"inputFileList\":[{\"resultType\":\"seq_sorted_bam_file\",\"storeId\":\"file://${seq_sorted_germline_bam_file}\"},{\"resultType\":\"seq_bam_index_file\",\"storeId\":\"file://${seq_germline_bam_index_file}\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"variationCalling\",\"resultPath\":\"file:///workspace/${normalId}/variant_calling/\",\"variantCallingTool\":\"${params.germline_variant_calling.germline_variantCallingTool}\"}"
  
cp /workspace/${normalId}/variant_calling/seq_raw_vcf_file* ${params.outdir}/germline/snpIndel/seq_snpindel_${normalId}_${params.germline_variant_calling.germline_variantCallingTool}.raw.vcf