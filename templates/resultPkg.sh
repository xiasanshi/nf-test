#! /bin/bash
# author :
if [ ! -d /workspace/logs ]; then mkdir -p -m 777 /workspace/logs;fi

exec >/workspace/logs/${params.tag}-somatic-results.log 2>&1

cd ${params.outdir}
zip -r /workspace/${params.tag}.report.zip  ./ -x " ${params.outdir}/somatic/snpIndel/temp/*" -x " ${params.outdir}/germline/snpIndel/temp/*" -x " ${params.outdir}/somatic/sv/temp/*" -x " ${params.outdir}/sample/qc_${tumorId}/*" -x " ${params.outdir}/sample/qc_${normalId}/*" -x "${params.outdir}/germline/hla/${normalId}.GCA*"