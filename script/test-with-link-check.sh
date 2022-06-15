#!/usr/bin/env bash
set -e # halt script on error

export PAGES_REPO_NWO=publiccodenet/standard

# Build the site
bundle exec jekyll build

# bundle exec htmlproofer --help | grep url-ignore
#  --url-ignore link1,[link2,...]  A comma-separated list of
#    Strings or RegExps containing URLs that are safe to ignore.
# * github.com/foo/edit/ : may reference yet-to-exist pages
# * docs.github.com/en : blocked by github DDoS protection
# * plausible.io/js/plausible.js : does not serve to scripts
URL_IGNORE_REGEXES="\
/github\.com\/.*\/edit\//\
,/docs\.github\.com\/en\//\
,/plausible\.io\/js\/plausible\.js/\
"

# Check for broken links and missing alt tags:
# jekyll does not require extentions like HTML
# ignoring problem urls (see above)
# set an extra long timout for test-servers with poor connectivity
# ignore request rate limit errors (HTTP 429)
# using the files in Jekylls build folder
bundle exec htmlproofer \
    --assume-extension \
    --url-ignore $URL_IGNORE_REGEXES \
    --typhoeus-config '{"timeout":60,"ssl_verifypeer":false,"ssl_verifyhost":"0"}' \
    --http_status_ignore "429" \
    ./_site
