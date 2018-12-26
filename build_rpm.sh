#!/bin/bash
#
# Script to fetch and (RPM) package Sonarqube from ZIP
#
#################################################################
PROGNAME="$(basename ${0})"
PROGDIR="$( readlink -f $( dirname ${0} ) )"
SOURCEPKG="${1:-UNDEF}"
SOURCEFIL=${SOURCEPKG##*/}
VERSTRING=$( echo ${SOURCEFIL} | sed -e 's/\.zip//' -e 's/^sonarqube-//' )
VERFIELDS=$( echo ${VERSTRING} | awk -F'.' '{ print NF }' )

if [[ ${VERFIELDS} -gt 2 ]]
then
   SONARMAJ=$( echo ${VERSTRING} | awk -F '.' '{printf("%s.%s",$1,$2)}')
   SONARMIN=$( echo ${VERSTRING} | awk -F '.' '{printf("%s",$3)}')
elif [[ ${VERFIELDS} -eq 2 ]]
then
   SONARMAJ=$( echo ${VERSTRING} | awk -F '.' '{printf("%s.%s",$1,$2)}')
   SONARMIN=0
else
   SONARMAJ=$( echo ${VERSTRING} | awk -F '.' '{printf("%s",$1)}')
   SONARMIN=0
fi

# Define our error-handler\n",
function err_exit {
   echo "${1}"
   logger -p user.crit -t "${PROGNAME}" "${1}"
   exit 1
}

# Fetch source if non-local resource is given
if [[ ${SOURCEPKG} == http[s]://* ]]
then
   echo "Attempting to fetch ${SOURCEPKG}... "
   curl -kL "${SOURCEPKG}" -o \
     "${PROGDIR}/rpmbuild/SOURCES/${SOURCEFIL}" && \
       echo "Success" || err_exit "Failed fetching ${SOURCEPKG}"
elif [[ ${SOURCEPKG} == s3://* ]] && [[ -x $( which aws ) ]]
then
   echo "Attempting to fetch ${SOURCEPKG}... "
   aws s3 cp "${SOURCEPKG}" \
     "${PROGDIR}/rpmbuild/SOURCES/${SOURCEFIL}" && \
       echo "Success" || err_exit "Failed fetching ${SOURCEPKG}"
elif [[ -s ${SOURCEPKG} ]]
then
   printf "Relocating %s to build-location" "${SOURCEPKG}"
   mv "${SOURCEPKG}" "$( dirname ${PROGNAME} )/rpmbuild/SOURCES/${SOURCEFIL}" \
     && echo "Success" || err_exit "Failed moving ${SOURCEFIL}"
fi

# Create suitable spec file from template
sed -e "s/__SRCARCHIVE__/${SOURCEFIL}/" \
    -e "s/__SRCROOTDIR__/${SOURCEFIL%%.zip}/" \
  rpmbuild/SPECS/sonar.spec-tmplt > rpmbuild/SPECS/sonar.spec


# Build the RPM
cd "${PROGDIR}/rpmbuild" &&
rpmbuild --define "_topdir ${PROGDIR}/rpmbuild" --define "major ${SONARMAJ}" \
  --define "minor ${SONARMIN}" -ba "SPECS/sonar.spec"
