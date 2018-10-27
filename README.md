This is a small set of files to assist Sonarqube administrators convert the SonarSource-provided ZIP archives into Linux packages.

Currently, this repository only includes logic for creating RPMs. The included SPEC file will attempt to determine if the build-host is EL6 or EL7, 32bit or 64bit and construct an RPM with the appropriate binaries and startup utilities.
