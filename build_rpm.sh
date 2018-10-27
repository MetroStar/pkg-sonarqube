#!/bin/bash
#
# Script to fetch and (RPM) package Sonarqube from ZIP
#
#################################################################
PROGNAME="$(basename ${0})"
PROGDIR="$( readlink -f $( dirname ${0} ) )"
SOURCEPKG="${1:-UNDEF}"
SOURCEFIL=${SOURCEPKG##*/}
SONARMAJ="$( echo ${SOURCEFIL} | sed -e 's/.zip//' -e 's/^.*-//' | \
             cut -d . -f 1)"
SONARMIN="$( echo ${SOURCEFIL} | sed -e 's/.zip//' -e 's/^.*-//' | \
             cut -d . -f 2)"

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

# Build the RPM
cd "${PROGDIR}/rpmbuild" &&
rpmbuild --define "_topdir ${PROGDIR}/rpmbuild" --define "major ${SONARMAJ}" \
  --define "minor ${SONARMIN}" -ba "SPECS/sonar.spec"
