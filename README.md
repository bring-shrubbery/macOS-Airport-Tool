# macOS 'Airport' Tool

This is an attempt to replicate 'Airport' tool found in the depths of macOS. If you don't know what I'm talking about then you can try it out by either going here:
```
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/
```
and typing ```./airport```. It will display all you need to know about this tool. If you would like to use it from any directory in the terminal, you will need to make a symbolic link (alias) to one of the 'bin' directories in the root directory (eg. /bin, /usr/local/bin, etc.). I found that ```/usr/local/bin``` works the best and doesn't introduce any permission problems. To do it just go to one if bin directories, for example:
```
cd /usr/local/bin
```
and then make a symbolic link to that directory:
```
sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport
```

### Goal of the project
The goal is to make a perfect copy of the original tool, so someone who is curious how it approximately was made could look into source code and learn something, so the contribution is highly appreciated.

Feel free to modify the project and submit pull requests, but remember what the goal of this project is!

### Prerequisites

This project was made in Xcode 9.4.1 so it's encouraged to use this or a newer version to run it. You could also use pure swift compiler to create a binary executable. Here's how:

- Install Xcode Command Line Tools or...
- Go to swift.org and follow installation guide to install swift
- Create new folder for the project and go into it ```mkdir wifiScanner && cd wifiScanner```
- Initiate empty swift project using ```swift package init --type executable```
- Put all .swift files into the sources folder
- Run ```swift run wifiScanner```

## Usage

For now, when you run the executable you can only provide interface name and command to scan for networks ```wifiScanner en0 -s``` or just provide scan command to use default interface ```wifiScanner -s```.

## Built With

* [Xcode](https://developer.apple.com/xcode/) - development IDE
* [Swift](https://swift.org/) - Swift Programming Language

## Acknowledgments

* Thanks to Apple for having such good tool on their system, even though it is hidden
