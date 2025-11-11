#!/bin/bash 

BASENAME=${1##*/}
IMAGE=${BASENAME%%:*}
EXPORT_IMAGE=/tmp/${IMAGE}.tar
GRYPE_DIR=grype_scans
GRYPE_OUT=${GRYPE_DIR}/${IMAGE}.grype.$(date +%m%d%Y).json 
SUMM_TMP=/tmp/${IMAGE}.grype.$(date +%m%d%Y).tsv
SUMM_OUT=${GRYPE_OUT%.*}.tsv
VEX_URL="https://security.access.redhat.com/data/csaf/v2/vex"
VEX_TMP=/tmp/${IMAGE}.vex.dat

mkdir -p $GRYPE_DIR
# export local podman image on mac 
if [ ! -f $EXPORT_IMAGE ]; then 
	echo "RUN: podman save -o $EXPORT_IMAGE $1"
	podman save -o $EXPORT_IMAGE $1
fi

echo "RUN: grype $EXPORT_IMAGE -o json > $GRYPE_OUT"
grype $EXPORT_IMAGE -o json > $GRYPE_OUT

{
echo "id\tseverity\tbase-score\tpackage\tversion\tfix-verion\tlocation" 
jq -r '
 .matches[] |
  [
    .vulnerability.id,
    .vulnerability.severity,
    .vulnerability.cvss[0].metrics.baseScore,
    .artifact.name, 
	.artifact.version, 
	(.vulnerability.fix.versions[]? // "None"), 
	(.artifact.locations | map(.path) | join("; "))
  ] | @tsv
' $GRYPE_OUT | sort -k3 -n | awk -F\t '($3 != "" && $3 > 7.9)'  
} | tee $SUMM_TMP 


{
echo "RH_VEX"
tail -n +2 $SUMM_TMP | cut -f1 | while read -r CVE; do 
	YEAR=$(echo $CVE | cut -d- -f2)
	CVE_LOW=$(printf '%s' "$CVE" | tr '[:upper:]' '[:lower:]')
	curl -s "$VEX_URL/$YEAR/${CVE_LOW}.json" | jq '.vulnerabilities[0].scores[0].cvss_v3.baseScore' 2> /dev/null || echo "NA"
done
} > $VEX_TMP

paste $SUMM_TMP $VEX_TMP > $SUMM_OUT
