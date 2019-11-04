#!/bin/bash
# 
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

echo "########### variant calling ########" 

if [ ! -d /workdir/${tumorId}/variant_calling/ ]; then mkdir -p -m 777 /workdir/${tumorId}/variant_calling/;fi
if [ ! -d  ${params.outdir}/somatic/snpIndel/ ]; then mkdir -p -m 777  ${params.outdir}/somatic/snpIndel/;fi

if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

if [ ! -d /workspace/${params.tag}/variant_calling/somatic ]; then mkdir -p -m 777 /workspace/${params.tag}/variant_calling/somatic ;fi

if [ -d /workspace/${params.tag}/variant_calling/somatic/1  ]; then rm -f /workspace/${params.tag}/variant_calling/somatic/1 ;fi

exec >/workspace/logs/${params.tag}-variant_calling_somatic.log 2>&1

echo  "PYTHONPATH=\"/gcbi/analyze/somatic_variant\" python3 -m task.svc_workflow run file:/workspace/${params.tag}/variant_calling/somatic/1  --workDir=/workspace/${params.tag}/variant_calling/somatic/ --maxCores ${params.variant_calling.maxCores} --message {\"processId\":\"${params.tag}\",\"processType\":\"somaticVariant\",\"tumorAccession\":\"${tumorId}\",\"controlAccession\":\"${normalId}\",\"inputFileList\":[{\"storeId\": \"file://${seq_sorted_somatic_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"tumor\"}, {\"storeId\": \"file://${seq_somatic_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"tumor\"},{\"storeId\": \"file://${seq_sorted_germline_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"control\"}, {\"storeId\": \"file://${seq_germline_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"control\"}],\"includeDuplication\":${params.variant_calling.includeDuplication},\"variantCallingTool\":\"${params.variant_calling.variantCallingTool}\",\"callingToolArguFile\":\"file://${params.variant_calling.callingToolArguFile}\",\"genomeVersion\":\"${params.genome}\",\"bedTarget\":\"file://${params.bedFile}\",\"resultPath\":\"file:///workdir/${tumorId}/variant_calling/\",\"hotspots\":\"${params.variant_calling.hotspots}\"}"


PYTHONPATH="/gcbi/analyze/somatic_variant" python3 -m task.svc_workflow run file:/workspace/${params.tag}/variant_calling/somatic/1  --workDir=/workspace/${params.tag}/variant_calling/somatic/ --maxCores ${params.variant_calling.maxCores} --message "{\"processId\":\"${params.tag}\",\"processType\":\"somaticVariant\",\"tumorAccession\":\"${tumorId}\",\"controlAccession\":\"${normalId}\",\"inputFileList\":[{\"storeId\": \"file://${seq_sorted_somatic_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"tumor\"}, {\"storeId\": \"file://${seq_somatic_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"tumor\"},{\"storeId\": \"file://${seq_sorted_germline_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"control\"}, {\"storeId\": \"file://${seq_germline_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"control\"}],\"includeDuplication\":${params.variant_calling.includeDuplication},\"variantCallingTool\":\"${params.variant_calling.variantCallingTool}\",\"callingToolArguFile\":\"file://${params.variant_calling.callingToolArguFile}\",\"genomeVersion\":\"${params.genome}\",\"bedTarget\":\"file://${params.bedFile}\",\"resultPath\":\"file:///workdir/${tumorId}/variant_calling/\",\"hotspots\":\"${params.variant_calling.hotspots}\"}"

cp /workdir/${tumorId}/variant_calling/*.vcf ${params.outdir}/somatic/snpIndel/seq_snpindel_${params.tag}_${params.toolVendor}.raw.vcf
