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

if [ ! -d /workspace/${tumorId}/msi/ ]; then mkdir -p -m 777 /workspace/${tumorId}/msi/;fi
if [ ! -d  ${params.outdir}/somatic/msi/ ]; then mkdir -p -m 777  ${params.outdir}/somatic/msi/;fi

if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

if [ ! -d /workspace/${params.tag}/somatic/msi ]; then mkdir -p -m 777 /workspace/${params.tag}/somatic/msi ;fi

exec >/workspace/logs/${params.tag}-msi_paired.log 2>&1




echo "############ msi ############" 
echo "PYTHONPATH=\"/gcbi/analyze/microsatellite_instability\" python3 -m task.msi_workflow run file:/workspace/${params.tag}/somatic/msi/1  --workDir=/workspace/${params.tag}/somatic/msi/ --maxCores ${params.msisensor.maxCores} --message {\"processId\":\"${params.tag}\",\"processType\":\"microsatellite_instability\",\"tumorAccession\":\"tumor\",\"controlAccession\":\"control\",\"msiTool\":\"${params.msisensor.msiTool}\",\"inputFileList\":[{\"storeId\": \"file://${seq_sorted_somatic_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"tumor\"}, {\"storeId\": \"file://${seq_somatic_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"tumor\"},{\"storeId\": \"file://${seq_sorted_germline_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"control\"}, {\"storeId\": \"file://${seq_germline_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"control\"}],\"toolArguFile\":\"file://${params.msisensor.msi_toolArguFile}\",\"genomeVersion\":\"${params.genome}\",\"bedTarget\":\"file://${params.bedFile}\",\"resultPath\":\"file:///workspace/${tumorId}/msi/\"}"



########## microsatellite instability ##############
PYTHONPATH="/gcbi/analyze/microsatellite_instability" python3 -m task.msi_workflow run file:/workspace/${params.tag}/somatic/msi/1  --workDir=/workspace/${params.tag}/somatic/msi/ --maxCores ${params.msisensor.maxCores} --message "{\"processId\":\"${params.tag}\",\"processType\":\"microsatellite_instability\",\"tumorAccession\":\"tumor\",\"controlAccession\":\"control\",\"msiTool\":\"${params.msisensor.msiTool}\",\"inputFileList\":[{\"storeId\": \"file://${seq_sorted_somatic_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"tumor\"}, {\"storeId\": \"file://${seq_somatic_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"tumor\"},{\"storeId\": \"file://${seq_sorted_germline_bam_file}\", \"resultType\": \"seq_sorted_bam_file\", \"tag\":\"control\"}, {\"storeId\": \"file://${seq_germline_bam_index_file}\", \"resultType\": \"seq_bam_index_file\", \"tag\":\"control\"}],\"toolArguFile\":\"file://${params.msisensor.msi_toolArguFile}\",\"genomeVersion\":\"${params.genome}\",\"bedTarget\":\"file://${params.bedFile}\",\"resultPath\":\"file:///workspace/${tumorId}/msi/\"}"

cp /workspace/${tumorId}/msi/seq_msi_tab-tumor  ${params.outdir}/somatic/msi/seq_msi_${tumorId}_msisensor_tab.txt
cp /workspace/${tumorId}/msi/seq_msi_summary-tumor  ${params.outdir}/somatic/msi/seq_msi_${tumorId}_msisensor_summary.txt
cp /workspace/${tumorId}/msi/seq_msi_somatic-tumor  ${params.outdir}/somatic/msi/seq_msi_${tumorId}_msisensor_diff.txt
