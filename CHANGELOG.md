# 2022 April 27 

- adds env variable SENTRY_SAMPLE_RATE

# 2022 April 20

- fix wrong method ProjectsController#find_project
- adds validation to project (uniqueness on project_id scope api_client)

# v2 2022 February 28

- installed sentry for errors tracking
- migrated from postgres 9.4 to postgres 13
- improves dockerfile (bundler version, extract supervisor out of image, install gems except dev group)
- removed elasticsearch, replaced by pg_search
- extracted nginx from Dockerfile to docker-compose.yml and updated to the latest version
- updated ruby version to 2.7.4
- updated rails version to 6.1.4
- updated loofah to 2.14.0
- updated redis to 6-alpine
- updated rake to 13.0.6 to fix [CVE-2020-8130](https://nvd.nist.gov/vuln/detail/CVE-2020-8130)
- updated kaminari to 1.2.2 to fix [CVE-2020-11082](https://nvd.nist.gov/vuln/detail/CVE-2020-11082)
- updated websocket-extensions to 0.1.5 to fix [CVE-2020-7663](https://nvd.nist.gov/vuln/detail/CVE-2020-7663)
- updated rack to 2.2.3 to fix [CVE-2020-8161](https://nvd.nist.gov/vuln/detail/CVE-2020-8161), [CVE-2020-8184](https://nvd.nist.gov/vuln/detail/CVE-2020-8184), [CVE-2019-16782](https://nvd.nist.gov/vuln/detail/CVE-2019-16782), [CVE-2018-16470](https://nvd.nist.gov/vuln/detail/CVE-2018-16470) and [CVE-2018-16471](https://nvd.nist.gov/vuln/detail/CVE-2018-16471)
- updated addressable to 2.8.0 to fix [CVE-2021-32740](https://nvd.nist.gov/vuln/detail/CVE-2021-32740)
- updated nokogiri to 1.13.3 to fix [CVE-2021-41098](https://nvd.nist.gov/vuln/detail/CVE-2021-41098), [GHSA-7rrm-v45f-jp64](https://github.com/advisories/GHSA-7rrm-v45f-jp64), [CVE-2020-26247](https://nvd.nist.gov/vuln/detail/CVE-2020-26247), [CVE-2020-7595](https://nvd.nist.gov/vuln/detail/CVE-2020-7595), [CVE-2019-5477](https://nvd.nist.gov/vuln/detail/CVE-2019-5477) and [CVE-2018-14404](https://nvd.nist.gov/vuln/detail/CVE-2018-14404)
- updated sidekiq to 6.4.1 to fix [CVE-2021-30151](https://nvd.nist.gov/vuln/detail/CVE-2021-30151)
- updated puma to 5.6.2 to fix [CVE-2021-41136](https://nvd.nist.gov/vuln/detail/CVE-2021-41136), [CVE-2021-29509](https://nvd.nist.gov/vuln/detail/CVE-2021-29509), [CVE-2020-11077](https://nvd.nist.gov/vuln/detail/CVE-2020-11077), [CVE-2020-11076](https://nvd.nist.gov/vuln/detail/CVE-2020-11076), [CVE-2020-5249](https://nvd.nist.gov/vuln/detail/CVE-2020-5249), [CVE-2020-5247](https://nvd.nist.gov/vuln/detail/CVE-2020-5247) and [CVE-2019-16770](https://nvd.nist.gov/vuln/detail/CVE-2019-16770)

## v1.0.3 2020 August 18

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
