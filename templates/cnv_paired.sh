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

if [ ! -d /workspace/${tumorId}/cnv/ ]; then mkdir -p -m 777 /workspace/${tumorId}/cnv/;fi
if [ ! -d  ${params.outdir}/somatic/cnv/ ]; then mkdir -p -m 777  ${params.outdir}/somatic/cnv/;fi

if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

if [ ! -d /workspace/${params.tag}/somatic/cnv ]; then mkdir -p -m 777 /workspace/${params.tag}/somatic/cnv ;fi

exec >/workspace/logs/${params.tag}-cnv_paired.log 2>&1



echo "########## copy number analysis ##############" 
echo "PYTHONPATH=\"/gcbi/analyze/copy_number_analysis\" python3 -m task.cnv_workflow run file:/workspace/${params.tag}/somatic/cnv/1  --workDir=/workspace/${params.tag}/somatic/cnv/ --maxCores ${params.cnv.maxCores} --message  {\"processId\":\"${params.tag}\",\"processType\":\"copyNumberAnalysis\",\"tumorAccession\":\"${tumorId}\",\"controlAccession\":\"${normalId}\",\"analyzingTool\":\"${params.cnv.analyzingTool}\",\"analysisType\":\"${params.cnv.analysisType}\",\"inputFileList\":[{\"storeId\": \"file://${seq_sorted_somatic_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"tumor\"}, {\"storeId\": \"file://${seq_somatic_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"tumor\"},{\"storeId\": \"file://${seq_sorted_germline_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"control\"}, {\"storeId\": \"file://${seq_germline_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"control\"}],\"controlPoolPath\":\"file://${params.cnv.controlPoolPath}\",\"genomeVersion\":\"${params.genome}\",\"bedTarget\":\"file://${params.cnv.cnv_bedTarget}\",\"resultPath\":\"file:///workspace/${tumorId}/cnv/\"}"

PYTHONPATH="/gcbi/analyze/copy_number_analysis" python3 -m task.cnv_workflow run file:/workspace/${params.tag}/somatic/cnv/1  --workDir=/workspace/${params.tag}/somatic/cnv/ --maxCores ${params.cnv.maxCores} --message "{\"processId\":\"${params.tag}\",\"processType\":\"copyNumberAnalysis\",\"tumorAccession\":\"${tumorId}\",\"controlAccession\":\"${normalId}\",\"analyzingTool\":\"${params.cnv.analyzingTool}\",\"analysisType\":\"${params.cnv.analysisType}\",\"inputFileList\":[{\"storeId\": \"file://${seq_sorted_somatic_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"tumor\"}, {\"storeId\": \"file://${seq_somatic_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"tumor\"},{\"storeId\": \"file://${seq_sorted_germline_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"control\"}, {\"storeId\": \"file://${seq_germline_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"control\"}],\"controlPoolPath\":\"file://${params.cnv.controlPoolPath}\",\"genomeVersion\":\"${params.genome}\",\"bedTarget\":\"file://${params.cnv.cnv_bedTarget}\",\"resultPath\":\"file:///workspace/${tumorId}/cnv/\"}"

cp /workspace/${tumorId}/cnv/seq_cnv_result-* ${params.outdir}/somatic/cnv/seq_cnv_${tumorId}_${params.cnv.analyzingTool}.tsv

