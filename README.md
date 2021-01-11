![Banner](img/banner3.png?raw=true)
# CWA

CWA is a mobile application for IOS and Android based on the homepage https://www.cwa-chalmers.se/.
The app was made in order to make CWA:s content accessible in a more convenient way. The app includes
events, tickets, information about CWA, a form to contact CWA and users can register new accounts 
and login. 

## DAT257 examination 
* **Source code**: 
  * ...\DAT257-Group-4\cwa_application\lib  
* **Team Reflections**: 
  * ...\DAT257-Group-4\Project Documents\Team Reflections  
* **Individual Reflections**:
  * ...\DAT257-Group-4\Project Documents\Individual Reflections  
* **Project Scope**: 
  * ...\DAT257-Group-4\Project Documents\Project Scope  
* **Social Contract**: 
  * ...\DAT257-Group-4\Project Documents\Social Contract.pdf  
* **Sprint Documentation**: 
  * ...\DAT257-Group-4\Project Documents\Sprint Documentation  
* **GUI Document**: 
  * ...\DAT257-Group-4\Project Documents\GUI Document.pdf  
* **Meeting Protocol**: 
  * ...\DAT257-Group-4\Project Documents\Meeting Protocol.pdf  
* **Application .apk**: 
  * ...\GitHub\DAT257-Group-4\app-release.apk  
* **Trello (Scrum board)**: 
  * https://trello.com/invite/b/QOcMhEny/1e6c7e357855502bd430906e4a1e5fcb/projekt-dat257

## Running the app
### Android (.apk)
The repository includes an .apk file (can be found in the DAT257-Group-4 folder). It is runnable on android devices and is explained in more detail here: https://www.lifewire.com/apk-file-4152929.

### Debugging/Testing via Android Studio
Firstly follow https://flutter.dev/docs/get-started/install/windows to enable debugging. Note that for Intel processors, Intel HAXM should be used and VT-X might need to be enabled in the BIOS. Intel HAXM: https://github.com/intel/haxm. Open Android Studio and import the project  ...\DAT257-Group-4\cwa_application. 

#### Emulator
When everything is set up, open AVD Manager in Android Studio ![AVDManager](img/AVDManager.PNG?raw=true). If there are no emulators ready click "+ Create Virtual Device..." and add a virtual device. 
After completion; run the emulator by pressing the green run-button under the header "actions" ![AVDRun](img/AVDRun.PNG?raw=true). 
When the emulator is done loading go back to the main view and choose the emulator in a drop-down ![ChooseEmulator](img/ChooseEmulator.PNG?raw=true), and choose which runnable method to run (in most cases main.dart) ![Main](img/Main.PNG?raw=true). To run the app on the emulator press the default run button ![Run](img/Run.PNG?raw=true).

#### Android phone
Plug in USB cable and make sure to enable USB debugging mode on your phone. Choose the device and the runnable method (in most cases main.dart) ![ChooseMobile](img/ChooseMobile.PNG?raw=true). To run the app on the device press the default run button ![Run](img/Run.PNG?raw=true).

## Credits
CWA is developed and maintained by hueindahaus (Alexander Huang), joeljnsn (Joel Jönsson), hegardto (Johan Hegardt), webredocode (Milos Bastajic), EricJohanssoon (Eric Johansson), AdamJawad (Adam Jawad) and LeonardHedenblad (Leonard Hedenblad). The app is a product of the course DAT257 (Agile software project management) from Chalmers University of Technology.
