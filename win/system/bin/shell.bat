:: Open a terminal at the given location                       
:: Note: truncates off filenames and uses them for the title   
@echo off                                                      
start cmd /k "title %~nx1 && pushd %~dp1"                    
