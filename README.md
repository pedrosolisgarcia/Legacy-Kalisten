# KALISTEN #

### What is this repository for? ###

* Store and keep track of all the changes while developing the iOS version of the app.

* Deployment Target: `13.0`
* Version: `1.0`.

# Getting Started
## Dependencies
What you need to run this app:

* `Mac` running `macOS Catalina`.

* `Swift` and `Xcode`.

* Ensure you're running the latest versions macOS `10.xx.x`, Swift `5.x` and Xcode `11.x.x`.


> **Note:** Xcode is not strictly required, but is highly recommended. All dependencies required to run the project (including Swift) will be installed automatically by Xcode.

## Running the app (Xcode)
After you have installed Xcode and all dependencies, you can now run the app. For that, you need to select a destination to run the project into. This can be either through a `Simulator` provided by Xcode, or your own iPhone device plugged to the computer via USB.

> **Note:** In order to be able, you need to sign in with Apple ID, so Xcode will use the development certificate. To review your Apple ID and profile, check `https://developer.apple.com/membercenter/`

After selecting preferred destination, click on `Product > Run` or key `Cmd+R`.

## Deploying the app (Xcode)
### Build settings
1) Go to `Project/Targets > Kalisten`. Make sure that `Version` is the same set on [App Store Connect](https://appstoreconnect.apple.com/).

2) Go to `Product > Scheme > Edit Scheme` or key `Cmd+<`. Select `Archive` and check that `Build Configuration` is set to `Release`.

### Archiving and validating
Click on `Product > Archive`

> **Note:** The Archive feature is disabled if you are using a Simulator. Select `Generic iOS Device` or your own devide as destination

On the `Organizer` window that will be shown after archiving, Click on `Validate...` to check if there are any issues, oron `Upload to App Store...` to release the build to App Store Connect.

## Localization
This app supports Localization, currently in two languages: `English` and `Spanish`. In order to run the app in one specific language, go to `Product > Scheme > Edit Scheme` or key `Cmd+<`. Select `Run` and select on `Application Language` the preferred one.

> **Note:** If the language selected is not supported, default language (English) will be displayed.


## Extensions
Any extensions needed for the project, shall try to be stored in separate files, so it can be reused freely when needed

For example, if we would like to create an extension for String:

1) Create a `String+<ExtensionName>.swift` file in the `Kalisten/utils/extensions` directory.

2) Configure inside such file the behaviour of the extension.

3) Remember to `import Foundation` before declaring the `extension String{}`.

```swift
import Foundation

extension String {
    func myExtension() -> String {
        //Code here...
    }
}
```

4) Then, when willing to use this extension, simply proceed as follows:

```swift
const myString: String = 'string content';
const newString: String = myString.myExtension();
```

# Useful Information
## Use a Swift-aware editor
As mentioned, Xcode provides a lot of facilities and transparency when it comes to develop applications using Swift. That said, there are other great editors which can also be used to develop Swift apps:

* [Xcode](https://apps.apple.com/us/app/xcode/id497799835?mt=12)
* [Visual Studio Code](https://code.visualstudio.com/)
* [Atom](https://atom.io/) with [Swift plugin](https://atom.io/packages/language-swift)


## CocoaPods
This app supports [CocoaPods](https://cocoapods.org), so third parties from this dependency manager can be added.

### Install
Simply run the command below to install CocoaPods, using `sudo` if required:

```bash
$ sudo gem install cocoapods
```

### Getting started
In the root directory, there is a [Podfile](https://bitbucket.org/pedrosolisg/kalisten-ios/src/master/Podfile), which shall have a format similar to the one that follows:

```pod
platform :ios, '8.0'
use_frameworks!

target 'Kalisten' do
  pod 'AFNetworking', '~> 2.6'
  pod 'ORStackView', '~> 3.0'
  pod 'SwiftyJSON', '~> 2.3'
end
```


> **Note:** If there would not be such file, you can simply create one with the command `pod init`

Now, to install all dependencies listed in the Podfile in the project:

```bash
$ pod install
```
Make sure you use the Xcode workspace file `Kalisten.xcworkspace`, instead of the default one, every time you open the project.

Now you can import your dependencies e.g.:

```swift
#import <Reachability/Reachability.h>
```

### Further Information
For more information about Cocoa Pods, check [the full guide](https://guides.cocoapods.org/using/getting-started.html#getting-started).


# Build Don'ts
The following are some things that will make the build compile fail.

- Donâ€™t use `Kalisten.xcworkspace` as file to open the project.
- Donâ€™t install dependencies being used.
- Donâ€™t import properly dependencies and being in use
- Use deprecated syntax from elder versions of Swift. Refer to [Swift Documentation](https://developer.apple.com/documentation/xcode_release_notes/xcode_10_2_release_notes/swift_5_release_notes_for_xcode_10_2) for more info.

### Who do I talk to? ###

* Owner: Pedro Solis Garcia (solisgpedro@gmail.com)
