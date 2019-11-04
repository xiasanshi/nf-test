#! /bin/bash
# author : Zhang Limei; at 2019-03-10
# 
R1T=$1
R2T=$2
sampleIdT=$3
R1N=$4
R2N=$5
sampleIdN=$6

resultPath=$7
indic=$8
phy=$9
logFile=/data/bioxFlow/logs/wes.log

echo "tumor $R1T ; $R2T; $sampleIdT; "
echo "normal $R1N ; $R2N; $sampleIdN;  "
echo "indic $indic" 
echo "phy $phy" 

starttime=`date +'%Y-%m-%d %H:%M'`




source ./bioxFlow.config
source ./somatic_paired.config

if [ ! -d ${resultPath} ]; then mkdir -p -m 777 ${resultPath};fi



for sampleId in $sampleIdT $sampleIdN;do
if [ $sampleId == $sampleIdT ];then
	R1=$R1T
	R2=$R2T
	echo "Tumor sample: ${R1}  ${R2}"
else
	R1=$R1N
	R2=$R2N
	echo "Normal sample: ${R1}  ${R2}"
fi


samlpe_Dir=${resultPath}/$sampleId
if [ ! -d ${samlpe_Dir} ]; then mkdir -p -m 777 ${samlpe_Dir};fi

preproc_Dir=${resultPath}/$sampleId/preproc
processId=$sampleId




#--------------germline_snpIndel-------

docker run --rm --env SENTIEON_LICENSE=$SENTIEON_LICENSE  -v $mount1:$mount1 -v $dbPath:/gcbi/ref -v $mount2:$mount2 --privileged=true $docker_images \
	${codePath}/germline_varcall.sh \
	${germline_snpIndel} \
	$sampleIdN \
	$genome \
	$germline_baseRecalibration \
	$bedTarget \
	$germline_callingToolArguFile \
	$germline_includeDuplication \
	$paired \
	$germline_variantCallingTool \
	$seq_sorted_bamN \
	$seq_bam_indexN \
	$maxCores \
	$logFile

