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

if(CommandLine.arguments.count < 2 ) {
    // If user inputs no arguments (1 unique word in command line)
    printUsage()
} else {
    // User puts at least one argument after program name itself:
    
    // Setup scanner
    let scanner = Scanner()
    
    //a case of user requesting a scan:
    if(CommandLine.arguments[1] == "-s" || CommandLine.arguments[1] == "scan" || CommandLine.arguments[1] == "--scan") {
        //standard scan argument
        scanner.scanNetworksClassic(nil)
    } else if(CommandLine.arguments.count < 4) {
        //standard scan with custom interface
        if(CommandLine.arguments[2] == "-s") {
            scanner.scanNetworksClassic(CommandLine.arguments[1])
        } else {
            // If no known commands are provided, or the syntax is incorrect - print usage info
            printUsage()
        }
    }
}
