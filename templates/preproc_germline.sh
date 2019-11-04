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
# R1=R1T                    : paired-end sequencing R1
# R2=R2T                      : paired-end sequencing R2
# sampleId == ${params.tag}          : processId
# genomeVersion == ${params.genome}          : processId
# baseQualityTrimming == ${params.preproc.baseQualityTrimming}
# fileType == ${params.preproc.fileType}
# paired == true
# qualityThreshold = ${params.preproc.qualityThreshold}
# removingAdapter == ${params.preproc.removingAdapter}
# otherFilterParameter == ${params.preproc.otherFilterParameter}
# mate1AdapterSequence == ${params.preproc.mate1AdapterSequence}
# mate2AdapterSequence == ${params.preproc.mate2AdapterSequence}
# maxCores == ${params.preproc.maxCores}
# logFile
# workdir
#
# OUTPUT:
# annovar_out*.txt           : Result after annotation
# preprocessDir           : preprocessDir
# 
#===============================================================================

if [ ! -d /workspace/${normalId}/preproc/ ]; then mkdir -p -m 777 /workspace/${normalId}/preproc/;fi

if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

if [ ! -d /workspace/${params.tag}/ ]; then mkdir -p -m 777 /workspace/${params.tag}/;fi

exec > /workspace/logs/${params.tag}-germline-preproc.log 2>&1


	
echo "########### preprocess module ############"

echo "PYTHONPATH=\"/gcbi/analyze/preprocess\" python3 -m task.workflow run file:/workspace/${params.tag}/germline  --workDir=/workspace/${params.tag}/ --maxCores ${params.preproc.maxCores} --message  {\"accession\":\"${normalId}\",\"baseQualityTrimming\":${params.preproc.baseQualityTrimming},\"fileType\":\"${params.preproc.fileType}\",\"umiFlag\":\"${params.umiFlag}\",\"mateFileList\":[{\"mateFile1\":\"file://$R1N\",\"mateFile2\":\"file://$R2N\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"preprocess\",\"qualityThreshold\":${params.preproc.qualityThreshold},\"removingAdapter\":${params.preproc.removingAdapter},\"mate1AdapterSequence\":\"${params.preproc.mate1AdapterSequence}\",\"mate2AdapterSequence\":\"${params.preproc.mate2AdapterSequence}\",\"otherFilterParameter\":{\"minimum-length\":\"70\"},\"resultPath\":\"file:///workspace/${normalId}/preproc\"}"
	

PYTHONPATH="/gcbi/analyze/preprocess" python3 -m task.workflow run file:/workspace/${params.tag}/germline  --workDir=/workspace/${params.tag}/ --maxCores ${params.preproc.maxCores} --message  "{\"accession\":\"${normalId}\",\"baseQualityTrimming\":${params.preproc.baseQualityTrimming},\"fileType\":\"${params.preproc.fileType}\",\"umiFlag\":\"${params.umiFlag}\",\"mateFileList\":[{\"mateFile1\":\"file://$R1N\",\"mateFile2\":\"file://$R2N\"}],\"paired\":${params.paired},\"processId\":\"${params.tag}\",\"processType\":\"preprocess\",\"qualityThreshold\":${params.preproc.qualityThreshold},\"removingAdapter\":${params.preproc.removingAdapter},\"mate1AdapterSequence\":\"${params.preproc.mate1AdapterSequence}\",\"mate2AdapterSequence\":\"${params.preproc.mate2AdapterSequence}\",\"otherFilterParameter\":{\"minimum-length\":\"70\"},\"resultPath\":\"file:///workspace/${normalId}/preproc\"}"
