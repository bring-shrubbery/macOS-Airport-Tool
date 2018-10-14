//
//  errors.swift
//  wifiScanner
//
//  Created by Antoni Silvestrovic on 14/10/2018.
//  Copyright © 2018 Vincent Rodriguez. All rights reserved.
//

import Foundation

enum WifiConnectionError : Error {
    case CouldNotAssociateWithNetwork
    case CouldNotScanForNetworks
}
