<p align="left">
    <img src="https://img.shields.io/badge/Swift-5.0-orange.svg" />
</p>


# SimTools
### Xcode-Simulation-Tools

**SimTools** is an application intended to leverage abilities of
[*SimLib*](https://github.com/Andriikym/SimLib-Xcode-Simulation-Tools) - library with a goal to simplify usage of Xcode simulators.

The application is written in Swift and designed to run on macOS. For now it provide next abilities:

* Determining that whole simulator application is running*;
* Setting arbitrary location coordinates for all already booted simulators;

\* To make this feature work, access to Automation privacy setting must be granted for the application. Security permission will be asked by the system on application start. It can be checked in  
*System Preferences->Security&Privacy->Privacy->Automation.*

## Usage

Clone this repository.  
Open the project. Dependencies should be updated automatically. (Update them manually if that did not happen).  
Build it.  
Application *Sim Tools.app* will be available in the *Products* folder of the project.  
It can be moved to preferable place than for further usage.  
Run and check Xcode simulator *Maps* application for the beginning.

Hope it will be useful 😀
