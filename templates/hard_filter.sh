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




#-------------step3:filter module
echo "filter module"
somatic_filter=${resultPath}/somatic_result/filter/
if [ ! -d ${somatic_filter} ]; then mkdir -p -m 777 ${somatic_filter};fi
/bin/bash ${codePath}filter.sh \
	${somatic_filter} \
	$sampleIdT \
	$genome \
	$toolVendor \
	$filterMethod \
	$filterToolArguFile \
	$bedTarget \
	$seq_raw_vcf_file \
	$maxCores \
	$logFile

seq_filter_vcf_file=`ls ${somatic_filter}/seq_filter_vcf_file-*`

