# Bluetooth Integrated Temperature Control System

This project uses an Arduino to read temperature data from a sensor, display it on an LCD, and send the data via Bluetooth (BLE) to an iOS device. On the iOS side, a modern SwiftUI interface displays the data in a stylish format, showing the mode (Heating/Cooling/Stable), the set point, and the current temperature.

---

## Table of Contents

- [Features](#features)
- [Hardware Requirements](#hardware-requirements)
- [Software Requirements](#software-requirements)
- [Setup and Usage](#setup-and-usage)
  - [Arduino Code](#arduino-code)
  - [iOS SwiftUI Application](#ios-swiftui-application)
- [System Workflow](#system-workflow)
- [Known Issues and Solutions](#known-issues-and-solutions)
- [License](#license)
- [Contact](#contact)

---

## Features

**Arduino Side:**

- Reads analog data from a temperature sensor and converts it to Celsius.
- Displays the temperature and system mode (Heating/Cooling/Stable) on an LCD.
- Sends the same data via a Bluetooth module (e.g., a BLE module like HM‑10).

**iOS Side:**

- Scans for BLE devices using CoreBluetooth and establishes a connection.
- Parses the incoming data and displays the mode, set point, and current temperature in a stylish SwiftUI interface.

---

## Hardware Requirements

- **Arduino Board** (Uno, Mega, or a compatible model)
- **Temperature Sensor** (e.g., LM35)
- **16x2 LCD Display** (or a compatible LCD)
- **Bluetooth Module** (BLE-supported, recommended: HM‑10)
- **Connecting wires and breadboard**

---

## Software Requirements

- **Arduino IDE** – for compiling and uploading the Arduino code.
- **Xcode** – for developing and compiling the SwiftUI-based iOS application.
- **Swift 5** or later.
- **iOS 13** or later (for the SwiftUI application).

---

## Setup and Usage

### Arduino Code

1. **Download and Open the Code:**  
   Open the Arduino IDE, create a new project, and paste the provided Arduino code that handles the Bluetooth data transmission, LCD display, and temperature control logic.

2. **Check Connections:**  
   - Ensure that the pin definitions for the temperature sensor, LCD, and Bluetooth module are correctly configured.
   - Adjust the digital pins used for the Bluetooth module (e.g., RX and TX) to match your hardware setup.

3. **Upload the Code:**  
   Upload the code to your Arduino and power up your circuit.

### iOS SwiftUI Application

1. **Create a New SwiftUI Project:**  
   Open Xcode and create a new "SwiftUI App" project.

2. **Add the Required Files:**  
   - `BluetoothManager.swift`: Manages BLE scanning, connection, and data handling.
   - `ContentView.swift`: Displays the Bluetooth data using a stylized interface.
   - The main app file (e.g., `YourAppNameApp.swift`).

3. **Running Without UUID Filtering:**  
   If you prefer to run the code without filtering by specific UUIDs, the BluetoothManager is configured with `scanForPeripherals(withServices: nil, options: nil)`, which scans for all nearby BLE devices. This allows you to test and view the incoming data without binding to specific UUIDs.

4. **Run the Application:**  
   Run the app on your iOS device or in the simulator. The app will scan for BLE devices, connect, and display the received data.

---

## System Workflow

1. **Sensor Data Reading:**  
   The Arduino reads the analog data from the temperature sensor and converts it to Celsius using a specific conversion factor.

2. **Data Display and Transmission:**  
   - The LCD displays the current temperature and system mode (Heating/Cooling/Stable).
   - The same data is transmitted via the Bluetooth module.

3. **BLE Communication:**  
   The iOS application scans for BLE devices using CoreBluetooth, connects to the device, discovers its services and characteristics, and then receives the data.

4. **Displaying in the SwiftUI Interface:**  
   The data (e.g., in the format "Mode: Heating, Set:25,Cur:27.5") is parsed and presented in a stylized card view within the SwiftUI interface.

---

## Known Issues and Solutions

- **Bluetooth UUID Requirement:**  
  If you need to scan without specific service or characteristic UUIDs, use `scanForPeripherals(withServices: nil, options: nil)`. However, be cautious as you may receive data from unintended devices.

- **Data Format Consistency:**  
  The format of the data sent by the Arduino must match the expected format in the iOS app. If necessary, modify the `parseSensorData(from:)` function to suit your data format.

- **Connection Issues:**  
  BLE connection problems can arise due to signal strength, device compatibility, or environmental factors. Consider adding error handling and retry mechanisms to manage connection stability.

---

## License

This project is licensed under the MIT License. For more details, please see the [LICENSE](LICENSE) file.

---

## Contact

For any questions, suggestions, or issues, please contact [email@example.com](mailto:furkandenizalbaylar@gmail.com).
