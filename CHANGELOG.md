
# Changelog OpenLab-Projects

## 2020 August 18

- extracts into env variable ELASTICSEARCH_PORT
- updates all gems except those concerning elasticsearch
- fix revoking a client key was not working
- admin can destroy an APIClient and its projects

TODO:
- set ELASTICSEARCH_PORT variable

## v1.0.2 2018 December 31

- Updated rake (2.0.5 -> 2.0.6) to fix [CVE-2018-16471](https://nvd.nist.gov/vuln/detail/CVE-2018-16471) and [CVE-2018-16470](https://nvd.nist.gov/vuln/detail/CVE-2018-16470)
- Updated loofah (2.2.2 -> 2.2.3) to fix [CVE-2018-16468](https://github.com/flavorjones/loofah/issues/154)
- Updated ffi (1.9.10 -> 1.9.24) to fix [CVE-2018-1000201](https://nvd.nist.gov/vuln/detail/CVE-2018-1000201)

## v1.0.1 2018 July 25

- Updated loofah (2.0.3 -> 2.2.2) to fix [CVE-2018-8048](https://github.com/flavorjones/loofah/issues/144)
- Updated nokogiri (1.6.7.2 -> 1.8.4) to fix [CVE-2017-18258](https://nvd.nist.gov/vuln/detail/CVE-2017-18258)
- Updated rails-html-sanitizer (1.0.3 -> 1.0.4) to fix [CVE-2017-18258](https://nvd.nist.gov/vuln/detail/CVE-2017-18258)
- Updated rails (5.0.0.beta3 -> 5.0.0.rc2) to fix nokogiri dependency update
- Fixed Dockerfile (ruby image was updated by the owner)
- Added deployment instructions 