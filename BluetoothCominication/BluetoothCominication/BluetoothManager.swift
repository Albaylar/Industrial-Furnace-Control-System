//
//  BluetoothManager.swift
//  BluetoothCominication
//
//  Created by Furkan Deniz Albaylar on 7.02.2025.
//

import Foundation
import CoreBluetooth
import SwiftUI

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var sensorData: String = "Veri Yok"
    
    private var centralManager: CBCentralManager!
    private var sensorPeripheral: CBPeripheral?
    
    override init() {
        super.init()
        // Merkezi yöneticiyi başlatıyoruz.
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // Servis filtrelemesi yapmadan tüm çevre birimlerini tara.
            centralManager.scanForPeripherals(withServices: nil, options: nil)
            print("Tüm çevre birimleri taranıyor...")
        } else {
            print("Bluetooth kullanılamıyor. Durum: \(central.state.rawValue)")
        }
    }
    
    // Bir çevre birimi bulunduğunda çağrılır.
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        print("Bulunan cihaz: \(peripheral.name ?? "İsimsiz")")
        
        // Test amacıyla ilk bulunan cihaza bağlanalım.
        sensorPeripheral = peripheral
        sensorPeripheral?.delegate = self
        
        // Taramayı durdurup cihazla bağlantı kuralım.
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }
    
    // Bağlantı sağlandığında çağrılır.
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Cihaza bağlanıldı: \(peripheral.name ?? "İsimsiz")")
        // Tüm servisleri keşfetmek için nil parametresi kullanıyoruz.
        peripheral.discoverServices(nil)
    }
    
    // MARK: - CBPeripheralDelegate
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                print("Keşfedilen servis: \(service.uuid)")
                // Servisin tüm karakteristiklerini keşfet.
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Keşfedilen karakteristik: \(characteristic.uuid)")
                // Karakteristiğin bildirimlerini (notification) açalım.
                peripheral.setNotifyValue(true, for: characteristic)
                // İlk değeri okumak için.
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        // Karakteristikten gelen değeri string olarak almaya çalışalım.
        if let value = characteristic.value, let dataString = String(data: value, encoding: .utf8) {
            print("Gelen veri (\(characteristic.uuid)): \(dataString)")
            DispatchQueue.main.async {
                self.sensorData = dataString
            }
        }
    }
}
