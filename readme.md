# SmallsatArray

SmallsatArray is a MATLAB GUI software tool for simulating antenna arrays for small satellites. The software has the following capabilities:

* Import 3D far-field radiation patterns from CST or HFSS, or generate far-field radiation patterns for dipole elements or isotropoc radiators.
* Translate and rotate the antenna elements to place them in an arbitrary array configuration.
* Display polar, rectangular, 2D or 3D plot of the absolute value, theta- or phi component in E-pattern or directivity.

## Repository Contents

## SmallsatArray.m
Source code for the software
## SmallsatArray.fig
GUI figure for the software
## Antenna.m
Class definition for Antenna object. Used by The **Element**-variable in SmallsatArray.m

### SmallsatArray
Files for standalone version of the software made with MATLAB Compiler. Uses MATLAB Runtime
#### for_redistribution
##### MyAppInnstaller_web.exe
Standalone version of the Software for users without MATLAB
#### for_redistribution_files_only
##### SmallsatArray.exe
Standalone version of the Software for users with MATLAB insalled
##### default_icon.ico
Default icon from MATLAB Compiler
##### readme.txt