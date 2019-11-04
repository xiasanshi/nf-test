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


	
# ---------------germline filter------------------
germline_filter=${resultPath}/germline_result/filter
if [ ! -d ${germline_filter} ]; then mkdir -p -m 777 ${germline_filter};fi

germline_raw_vcf=`ls ${germline_snpIndel}/seq_raw_vcf_file*`

docker run --rm --env SENTIEON_LICENSE=$SENTIEON_LICENSE  -v $mount1:$mount1 -v $dbPath:/gcbi/ref -v $mount2:$mount2 --privileged=true $docker_images \
	${codePath}/germline_filter.sh \
	${germline_filter} \
	$sampleIdN \
	$genome \
	$toolVendor \
	$germline_filterMethod \
	$germline_filterToolArguFile \
	$bedTarget \
	$germline_raw_vcf \
	$maxCores \
	$logFile

#--------------annox-----------
germline_annox=${resultPath}/germline_result/annox
if [ ! -d ${germline_annox} ]; then mkdir -p -m 777 ${germline_annox};fi

germline_filter_vcf=`ls ${germline_filter}/seq_filter_vcf_file-*`

docker run -it --rm -v $mount1:$mount1 -v $mount2:$mount2 -v ${annoxFlowDir}:/gcbi annox-env nextflow run /gcbi/annoFlow-snv.nf \
--inputfile $germline_filter_vcf \
--genome $genome \
--type vcf \
--mode germline \
--rawvcf $germline_raw_vcf \
--outpath ${germline_annox} \
--bedFile $bedTarget \
--cancertype $phy \
--logpath ${logpath} \
-params-file /gcbi/annoFlow.yml \
-c /gcbi/nextflow.config

#-------------interx------------
germline_interx=${resultPath}/germline_result/interx
if [ ! -d ${germline_interx} ]; then mkdir -p -m 777 ${germline_interx};fi

tmp=${germline_filter_vcf##*/}
annox_base=`echo ${tmp%.*}`

#python ${interxDir}/interx.py -g hg19 -indic $phy -phy $phy acmg ${annox_base}.annox.txt

fi

echo "DONE!!!"
endtime=`date +'%Y-%m-%d %H:%M'`
echo "$starttime" >> $logFile
echo "$endtime" >> $logFile

start_seconds=$(date --date="$starttime" +%m);
end_seconds=$(date --date="$endtime" +%m);
echo "本次运行时间： "$((end_seconds-start_seconds))"min"






