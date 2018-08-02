//
//  scanner.swift
//  macOS airport tool
//
//  Created by Antoni Silvestrovic on 02/08/2018.
//  Copyright © 2018 Vincent Rodriguez. All rights reserved.
//

import Foundation
import CoreWLAN

//struct for standard network data storage
struct standardNetworkData {
    let ssid: String
    let bssid: String
    let rssi: Int
    let channel: Int
    let ht: Bool
    let cc: String
    var security: String = ""
    
    init(_ network: CWNetwork) {
        //set SSID
        if let ssid = network.ssid {
            self.ssid = ssid
        } else {
            self.ssid = "unknown"
        }
        
        //set BSSID
        if let bssid = network.bssid {
            self.bssid = bssid
        } else {
            self.bssid = "unknown"
        }
        
        //set RSSI
        self.rssi = network.rssiValue
        
        //set CHANNEL
        self.channel = network.wlanChannel.channelNumber
        
        //set High Throughput
        self.ht = network.supportsPHYMode(CWPHYMode.mode11n)
        
        //set Country Code
        if let countryCode = network.countryCode {
            self.cc = countryCode
        } else {
            self.cc = "--"
        }
        
        //set Security Type
        //TODO: Figure Out All Postfixes
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
    //initialise wifi client
    var wifi: CWWiFiClient?
    
    //initialise on startup
    init() {
        self.wifi = CWWiFiClient()
    }
    
    //create a number of spaces
    func spaces(_ num: Int) -> String {
        var returnString = ""
        for _ in 0...num {
            returnString = returnString + " "
        }
        return returnString
    }
    
    public func scanNetworksClassic(_ interfaceName: String?) {
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
    
    func standardScan(_ interface: CWInterface) {
        do {
            let networks = try interface.scanForNetworks(withName: nil, includeHidden: true)
            
            //print header of the table
            print(spaces(27), terminator: "")
            print("SSID", "BSSID\(spaces(11))", "RSSI", "CHANNEL", "HT", "CC", "SECURITY (auth/unicast/group)", separator: " ")
            
            networks.forEach { (network) in
                //calculate network info from network instance
                let networkData = standardNetworkData(network)
                
                //ssid identation
                print(spaces(31-network.ssid!.count), terminator:"")
                
                //print retrieved data table
                print(  networkData.ssid,
                        networkData.bssid,
                        "\(networkData.rssi)\(spaces(3-String(networkData.rssi).count))",
                    "\(networkData.channel)\(spaces(6-String(networkData.channel).count))",
                    networkData.ht ? "Y " : "N ",
                    "\(networkData.cc)",
                    networkData.security, separator: " ")
            }
        } catch {
            //In case no networks are found
            print("No Networks Found!")
        }
    }
}
