//
//  main.swift
//  macOS airport tool
//
//  Created by Antoni Silvestrovic on 02/08/2018.
//  Copyright © 2018 Vincent Rodriguez. All rights reserved.
//

func printUsage() {
    //get usage info and print it
    let usageInfo = UsageInfo()
    print(usageInfo.usageInfoData)
}

if(CommandLine.arguments.count < 2 ) {
    printUsage()
} else {
    //setup scanner only if some arguments are provided
    let scanner = Scanner()
    
    if(CommandLine.arguments[1] == "-s") {
        //standard scan argument
        scanner.scanNetworksClassic(nil)
    } else if(CommandLine.arguments.count < 4) {
        //standard scan with custom interface
        if(CommandLine.arguments[2] == "-s") {
            scanner.scanNetworksClassic(CommandLine.arguments[1])
        }
    }
}
