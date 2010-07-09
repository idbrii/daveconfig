::p4v history window
pushd %~dp1
p4v -win 0 -cmd "history %*" 
popd
