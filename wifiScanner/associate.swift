//
//  associate.swift
//  wifiScanner
//
//  Created by Antoni Silvestrovic on 04/10/2018.
//  Copyright © 2018 Vincent Rodriguez. All rights reserved.
//

import Foundation
import CoreWLAN

class Associator {
    var wifiClient: CWWiFiClient?
    var interface: CWInterface?

    init?(_ interfaceName: String?) {
        
        wifiClient = CWWiFiClient();
        if let wific = wifiClient {
            wifiClient = wific
            
            if let name = interfaceName {
                interface = wifiClient?.interface(withName: name)
            } else {
                interface = wifiClient?.interface()
            }
        } else {
            print("Cannot find any wireless interfaces!");
            return nil;
        }
    }
    
    func associate(bssid: String, password: String?) throws {
        do {
            let networks = try interface!.scanForNetworks(withName: nil, includeHidden: true);
            
            for network in networks {
                if let bssid_to_compare = network.bssid {
                    if bssid_to_compare == bssid {
                        do {
                            try interface?.associate(to: network, password: password)
                        } catch {
                            throw WifiConnectionError.CouldNotAssociateWithNetwork
                        }
                    }
                }
            }
        } catch {
            throw WifiConnectionError.CouldNotScanForNetworks
        }
    }
    
    func associate(essid: String, password: String?) throws {
        do {
            let networks = try interface!.scanForNetworks(withName: essid, includeHidden: true);
            
            for network in networks {
                if let essid_to_compare = network.ssid {
                    if essid_to_compare == essid {
                        do {
                            try interface?.associate(to: network, password: password)
                        } catch {
                            throw WifiConnectionError.CouldNotAssociateWithNetwork
                        }
                    }
                }
            }
        } catch {
            throw WifiConnectionError.CouldNotScanForNetworks
        }
    }
    
}
