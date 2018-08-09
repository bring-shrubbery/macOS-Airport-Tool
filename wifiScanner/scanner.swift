//
//  scanner.swift
//  macOS airport tool
//
//  Created by Antoni Silvestrovic on 02/08/2018.
//  Copyright © 2018 Vincent Rodriguez. All rights reserved.
//

import Foundation
import CoreWLAN

// Struct for standard network data storage
class standardNetworkData {
    let ssid: String
    let bssid: String
    let rssi: Int
    let channel: Int
    let ht: Bool
    let cc: String
    let ibss: Bool
    var security: String = ""
    
    init (_ network: CWNetwork) {
        // Set SSID
        if let ssid = network.ssid {
            self.ssid = ssid
        } else {
            self.ssid = "unknown"
        }
        
        // Set BSSID
        if let bssid = network.bssid {
            self.bssid = bssid
        } else {
            self.bssid = "unknown"
        }
        
        // Set RSSI
        self.rssi = network.rssiValue
        
        // Set CHANNEL
        self.channel = network.wlanChannel.channelNumber
        
        // Set High Throughput
        self.ht = network.supportsPHYMode(CWPHYMode.mode11n)
        
        // Set Country Code
        if let countryCode = network.countryCode {
            self.cc = countryCode
        } else {
            self.cc = "--"
        }
        
        // Set IBSS indicator
        self.ibss = network.ibss
        
        // Set Security Type
        // TODO: Figure Out All Postfixes
        var numOfProtocols = 0
        if(network.supportsSecurity(CWSecurity.wpaPersonal)) {
            self.security += "WPA (PSK/"
            numOfProtocols += 1
        }
        
        if(network.supportsSecurity(CWSecurity.wpa2Personal)) {
            self.security += "WPA2 (PSK/"
            numOfProtocols += 1
        }
        
        if(network.supportsSecurity(CWSecurity.WEP)) {
            self.security += "WEP "
            numOfProtocols += 1
        }
        
        if(network.supportsSecurity(CWSecurity.dynamicWEP)) {
            self.security += "Dynamic WEP "
            numOfProtocols += 1
        }
        
        if(network.supportsSecurity(CWSecurity.none)) {
            self.security += "NONE"
            numOfProtocols += 1
        }
        
        if(numOfProtocols == 0){
            self.security = "unknown"
        }
    }
}

class Scanner {
    // Initialise wifi client
    var wifi: CWWiFiClient?
    
    // Initialise on startup
    init () {
        self.wifi = CWWiFiClient()
    }
    
    // Create a number of spaces
    func spaces (_ num: Int) -> String {
        var returnString = ""
        for _ in 0...num {
            returnString = returnString + " "
        }
        return returnString
    }
    
    public func scanNetworksClassic (_ interfaceName: String?) {
        if let intName = interfaceName {
            if let interface = self.wifi?.interface(withName: intName) {
                //attpempt to scan for networks
                standardScan(interface)
            } else {
                print("No interface named \"\(intName)\" was found!")
            }
        } else if let interface = self.wifi?.interface() { //attempt to get standard interface
            //attpempt to scan for networks
            standardScan(interface)
        } else { //If no interfaces are found
            print("No interfaces are found")
        }
    }
    
    func printStandardTableHeader () {
        // Print header of the table
        print(spaces(27), terminator: "")
        print("SSID", "BSSID\(spaces(11))", "RSSI", "CHANNEL", "HT", "CC", "SECURITY (auth/unicast/group)", separator: " ")
    }
    
    func printNetworkData (_ networkData: standardNetworkData) {
        // SSID identation (to make first column align to the right)
        print(spaces(31-networkData.ssid.count), terminator:"")
        
        // Print retrieved data table
        print(  networkData.ssid,
                networkData.bssid,
                "\(networkData.rssi)\(spaces(3-String(networkData.rssi).count))",
            "\(networkData.channel)\(spaces(6-String(networkData.channel).count))",
            networkData.ht ? "Y " : "N ",
            "\(networkData.cc)",
            networkData.security, separator: " ")
    }
    
    func standardScan (_ interface: CWInterface) {
        do {
            let networks = try interface.scanForNetworks(withName: nil, includeHidden: true)
            var ibssNetworks:[standardNetworkData] = []
            
            printStandardTableHeader()
            
            // Go through each network one by one
            networks.forEach { (network) in
                // Calculate network info from network instance
                let networkData = standardNetworkData(network)
                
                // If not an IBSS network
                if(!networkData.ibss){
                    printNetworkData(networkData)
                } else {
                    // Otherwise add to ibss network array:
                    ibssNetworks.append(networkData)
                }
            }
            
            // Print IBSS network info if there are any IBSS networks
            if(ibssNetworks.count > 0) {
                let infoString = ibssNetworks.count == 1 ? " IBSS network found:" : " IBSS networks found:"
                print("\n\(ibssNetworks.count)"+infoString)
                printStandardTableHeader ()
                
                // Print IBSS network data
                ibssNetworks.forEach { (ibssNetworkData) in
                    printNetworkData(ibssNetworkData)
                }
            }
        } catch {
            // In case no networks are found
            print("No Networks Found!")
        }
    }
}
