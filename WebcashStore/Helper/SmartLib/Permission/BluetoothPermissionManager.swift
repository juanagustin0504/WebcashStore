//
//  BluetoothPermissionManager.swift
//  SmartLib
//
//  Created by 위차이 on 1/17/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol BluetoothPermissionManagerDelegate : NSObject {
    func bluetoothPermissionDidChangeAuthorization(error : CBManagerState?)
}

public class BluetoothPermissionManager : NSObject {
    
    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var delegate : BluetoothPermissionManagerDelegate?
    
    public func requestBluetoothPermission(delegate : BluetoothPermissionManagerDelegate?) {
        self.delegate = delegate
        self.requestPermission()
    }
    
    private func requestPermission() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
}

extension BluetoothPermissionManager : CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let state = central.state
        if state == .unknown || state == .resetting || state == .unsupported ||
            state == .unauthorized || state == .poweredOff || state == .poweredOn {
            
            self.delegate?.bluetoothPermissionDidChangeAuthorization(error: central.state)
        }
        else {
            self.delegate?.bluetoothPermissionDidChangeAuthorization(error: nil)
        }
    }
}
