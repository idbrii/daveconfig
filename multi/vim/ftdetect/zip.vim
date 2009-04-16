" p4p files are actually zips

au BufReadCmd *.jar,*.xpi,*.p4p call zip#Browse(expand("<amatch>"))
