# MOBCore
Core code usable to streamline the development of a slew of applications.

Use MOBCore to make it quicker and easier to implement cloud/group/local defaults. Use MOBCore to add all the functionality you expect built-in objects to already have. Streamline development and spend more time on the tough stuff.
***
## Import with CocoaPods
```
  use_frameworks!
  pod 'MOBCore'
```
***
## Set up Defaults
### In any one file
#### At the top of the file, outside of the class scope (global)
```
import MOBCore
var Defaults = MOBDefaults(group: "app.group", keychain: "app.secureKeychainGroup")
```
#### Using MOBDefaults inside of any controller"
```
Defaults.local()//defaults only within your app
Defaults.shared()//defaults shared between apps in an app group
defaults.cloud()//defaults shared via icloud
defualts.keychain()//defaults encrypted and only shared within your app (password storage)

Usage:
Defaults.local().set(string: "HI", forKey: "storedValue")
Defaults.local().string(forKey: "storedValue")//"HI"
//Note, when using MOBDefaults you no longer have to call the "synchronize()" method! Defaults are automatically kept in sync. 
```
## Use Extensions and More
### In any File you want the added functionality
#### At the top of the file
```
import MOBCore
```
***
Easy as pie! Enjoy!

