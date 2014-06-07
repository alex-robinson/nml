# nml

A Fortran namelist I/O module

This module is intended to provide a small upgrade to native Fortran namelist functionality. 



## Example model setup

All model parameters are loaded from nml files. 
Each model should have a default parameter file 
(eg, model.nml) that is loaded first,
which ensures that all parameters are initialized
with realistic values. Then, for a given domain,
a parameter file can be specified (eg, Greenland.nml)
that overwrites the default parameter values. In
principle, the domain-specific parameter file should
contain parameters from all relevant models. The key
to this method is to properly specify the name of each
group of parameters in the file.





