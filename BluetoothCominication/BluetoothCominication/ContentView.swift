//
//  ContentView.swift
//  BluetoothCominication
//
//  Created by Furkan Deniz Albaylar on 7.02.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    
    var body: some View {
        ZStack {
            // Arka plan için gradient
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Sensör Verisi")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                SensorDataCard(dataString: bluetoothManager.sensorData)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
    }
}

// SensorDataCard: Bluetooth'tan gelen veriyi daha detaylı gösteren görünüm
struct SensorDataCard: View {
    var dataString: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if let parsedData = parseSensorData(from: dataString) {
                HStack {
                    Text("Mod:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(parsedData.mode)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(colorForMode(parsedData.mode))
                }
                HStack {
                    Text("Set Noktası:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(String(format: "%.1f °C", parsedData.setPoint))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                HStack {
                    Text("Güncel:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(String(format: "%.1f °C", parsedData.current))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
            } else {
                // Eğer veri beklenen formatta değilse, direkt göster
                Text(dataString)
                    .font(.body)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.5))
        )
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    // Verilen moda göre renk seçimi
    func colorForMode(_ mode: String) -> Color {
        switch mode.lowercased() {
        case "heating":
            return .red
        case "cooling":
            return .blue
        default:
            return .green
        }
    }
    
    // Gelen veri örneğin "Mode: Heating, Set:25,Cur:27.5" şeklindeyse, veriyi ayrıştırma fonksiyonu
    func parseSensorData(from dataString: String) -> (mode: String, setPoint: Double, current: Double)? {
        let components = dataString.split(separator: ",")
        var mode: String?
        var setPoint: Double?
        var current: Double?
        
        for component in components {
            let pair = component.split(separator: ":")
            if pair.count == 2 {
                let key = pair[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let value = pair[1].trimmingCharacters(in: .whitespacesAndNewlines)
                
                if key.lowercased().contains("mode") {
                    mode = value
                } else if key.lowercased().contains("set") {
                    setPoint = Double(value)
                } else if key.lowercased().contains("cur") {
                    current = Double(value)
                }
            }
        }
        
        if let mode = mode, let setPoint = setPoint, let current = current {
            return (mode, setPoint, current)
        }
        return nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
