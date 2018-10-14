//
//  main.swift
//  macOS airport tool
//
//  Created by Antoni Silvestrovic on 02/08/2018.
//  Copyright © 2018 Vincent Rodriguez. All rights reserved.
//

func printUsage() {
    // Get usage info and print it
    let usageInfo = UsageInfo()
    print(usageInfo.usageInfoData)
}

func handleAssociation(_ interfaceName: String?) {
    // Utitilty for connceting to APs
    let associator = Associator(interfaceName);
    
    if(associator == nil) {
        return;
    }
    
    var bssid: String?
    var essid: String?
    var password: String?
    
    if(arguments.contains("--bssid")) {
        let bssidIndex = arguments.firstIndex(of: "--bssid");
        if let index = bssidIndex {
            if(arguments.indices.contains(index + 1)) {
                bssid = arguments[(index + 1)]
            } else {
                print("No bssid specified! \nSpecify essid or bssid after using --essid or --bssid.")
            }
            
        }
    } else if(arguments.contains("--essid")) {
        let essidIndex = arguments.firstIndex(of: "--essid");
        if let index = essidIndex {
            if(arguments.indices.contains(index + 1)) {
                essid = arguments[(index + 1)]
            } else {
                print("No essid specified! \nSpecify essid or bssid after using --essid or --bssid.")
            }
        }
    }
    
    if(arguments.contains("--pass")) {
        let passwdIndex = arguments.firstIndex(of: "--pass");
        if let index = passwdIndex {
            if(arguments.indices.contains(index + 1)) {
                password = arguments[index + 1]
            } else {
                print("No password specified! \nIf network doesn't have password, don't use --pass.")
            }
        }
    }
    
    do {
        if let bss = bssid {
            try associator!.associate(bssid: bss, password: password)
        } else if let ess = essid {
            try associator!.associate(essid: ess, password: password)
        }
    } catch WifiConnectionError.CouldNotScanForNetworks {
        print("Could not scan networks. Check your wifi interface!")
    } catch WifiConnectionError.CouldNotAssociateWithNetwork {
        print("Could not associate with network. Try Again!")
    } catch {
        print("Unknown error !")
    }
    
}

let arguments = CommandLine.arguments;

if (arguments.count == 1 ) {
    // If user inputs no arguments (1 unique word in command line)
    printUsage()
} else {
    // User puts at least one argument after program name itself:
    
    if (arguments.contains("-s") || arguments.contains("scan") || arguments.contains("--scan")) {
        // Setup scanner
        let scanner = Scanner()
        
        if (arguments.firstIndex(of: "-s") == 1 || arguments.firstIndex(of: "scan") == 1 || arguments.firstIndex(of: "--scan") == 1) {
            //standard scan argument
            scanner.scanNetworksClassic(nil)
        } else if(arguments.firstIndex(of: "-s") == 2 || arguments.firstIndex(of: "scan") == 2 || arguments.firstIndex(of: "--scan") == 2){
            if (CommandLine.arguments[2] == "-s") {
                scanner.scanNetworksClassic(CommandLine.arguments[1])
            } else {
                // If no known commands are provided, or the syntax is incorrect - print usage info
                printUsage()
            }
        }
    } else if (arguments.contains("associate") || arguments.contains("-a")) {
        // no interface provided
        if (arguments.firstIndex(of: "associate") == 1 || arguments.firstIndex(of: "-a") == 1) {
            handleAssociation(nil)
        } else if(arguments.firstIndex(of: "associate") == 2 || arguments.firstIndex(of: "-a") == 2) {
            handleAssociation(arguments[1])
        } else {
            // If no known commands are provided, or the syntax is incorrect - print usage info
            printUsage()
        }
    }
}


