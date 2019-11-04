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

echo "########### variant calling ########" 

if [ ! -d /workspace/${tumorId}/sv/ ]; then mkdir -p -m 777 /workspace/${tumorId}/sv/;fi
if [ ! -d  ${params.outdir}/somatic/sv/ ]; then mkdir -p -m 777  ${params.outdir}/somatic/sv/;fi

if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

if [ ! -d /workspace/${params.tag}/somatic/sv ]; then mkdir -p -m 777 /workspace/${params.tag}/somatic/sv ;fi

if [ -d /workspace/${params.tag}/somatic/sv/1  ]; then rm -f /workspace/${params.tag}/somatic/sv/1 ;fi

exec >/workspace/logs/${params.tag}-sv_paired.log 2>&1


echo "########## structural variation analysis ##############" 


echo "PYTHONPATH=\"/gcbi/analyze/structural_variation\" python3 -m task.sv_workflow run file:/workspace/${params.tag}/somatic/sv/1  --workDir=/workspace/${params.tag}/somatic/sv/ --maxCores ${params.sv.maxCores} --message {\"processId\":\"${params.tag}\",\"processType\":\"structural_variation\",\"accession\":\"${tumorId}\",\"tumorAccession\":\"${tumorId}\",\"controlAccession\":\"${normalId}\",\"svTool\":\"${params.sv.svTool}\",\"inputFileList\":[{\"storeId\": \"file://${seq_sorted_somatic_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"tumor\"}, {\"storeId\": \"file://${seq_somatic_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"tumor\"},{\"storeId\": \"file://${seq_sorted_germline_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"control\"}, {\"storeId\": \"file://${seq_germline_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"control\"}],\"toolArguFile\":\"file://${params.sv.sv_toolArguFile}\",\"genomeVersion\":\"${params.genome}\",\"bedTarget\":\"file://${params.bedFile}\",\"resultPath\":\"file:///workspace/${tumorId}/sv/\"}"

PYTHONPATH="/gcbi/analyze/structural_variation" python3 -m task.sv_workflow run file:/workspace/${params.tag}/somatic/sv/1  --workDir=/workspace/${params.tag}/somatic/sv/ --maxCores ${params.sv.maxCores} --message "{\"processId\":\"${params.tag}\",\"processType\":\"structural_variation\",\"accession\":\"${tumorId}\",\"tumorAccession\":\"${tumorId}\",\"controlAccession\":\"${normalId}\",\"svTool\":\"${params.sv.svTool}\",\"inputFileList\":[{\"storeId\": \"file://${seq_sorted_somatic_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"tumor\"}, {\"storeId\": \"file://${seq_somatic_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"tumor\"},{\"storeId\": \"file://${seq_sorted_germline_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"control\"}, {\"storeId\": \"file://${seq_germline_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"control\"}],\"toolArguFile\":\"file://${params.sv.sv_toolArguFile}\",\"genomeVersion\":\"${params.genome}\",\"bedTarget\":\"file://${params.bedFile}\",\"resultPath\":\"file:///workspace/${tumorId}/sv/\"}"

cp /workspace/${tumorId}/sv/seq_sv_vcf-* ${params.outdir}/somatic/sv/seq_sv_${tumorId}_${params.sv.svTool}.vcf





