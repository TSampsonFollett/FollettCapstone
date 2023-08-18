import Foundation // Contains various supporting functions and data types

// Contains the classes to be inherited from so that the bluetooth functionality can be customized/
import CoreBluetooth
import Charts // Contains base classes for making the charts and their animations

// Used to group together the actual peripheral and their identifying values
struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
    let cbPerpheral: CBPeripheral!
}

// Used to group together the different representations of the parameter (as ordered number, byte length, its bytes, and its integer and string values
struct Parameter: Identifiable {
    public var id: Int
    var paramByteLength: Int8 // Number of bytes that each parameter takes up
    var paramName: String // Name of the parameter
    var bytes: [Int8] // The actual bytes for each parameter
    var paramVal: Int32 // The calculated integer value of parameter
    var nonInt: [Character] // The String value of the parameter if necessary
}

struct CBUUIDs{

    // list all of the characteristics UUID as constant for easier reference
    static let mode_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A1"
    static let ampsLow_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A2"
    static let ampsHigh_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A3"
    static let dipSwitch_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A4"
    static let errHigh_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A5"
    static let led1_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A6"
    static let led2_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A7"
    static let swv_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A8"
    static let sn_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A9"
    static let phd_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26B1"
    static let mode24_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26B2"
    static let augerCurMax_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26B3"
    
//    static let mergedin1UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26B1"
//    static let mergedin2_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A4"
//    static let dipSwitches_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A5"
//    static let dout0_UUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A6"
    
}

// Inherits from NSObject to give the class certain runtime characteristics and objective-c qualities
// Inherits from ObservableObject so that any changes made in other files are immediately reflected on the instance of the class
// Inherits from CBCentralManagerDelegate and CBPeripheralDelegate to override functions that deal with bluetooth connections
class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    

    // Initialized array of parameters taken from starbucks arduino code in order to save values
    @Published var params = [
    //    Parameter(paramByteLength: 1, paramName: "90", bytes: [], paramVal: 90, nonInt: []),
    //    Parameter(id: 1, paramByteLength: 1, paramName: "They afraid of the 6", bytes: [], paramVal: 6, nonInt: []),
        Parameter(id: 2, paramByteLength: 2, paramName: "augerCurMax", bytes: [], paramVal: -1, nonInt: [])//,
    //    Parameter(paramByteLength: 2, paramName: "augerCurMin", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 1, paramName: "augerCurMinEn", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 1, paramName: "augerRunOnSb", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 1, paramName: "augerTDRunOnSb", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 1, paramName: "binSignalLowHigh", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 2, paramName: "callWaterToutSw", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 1, paramName: "cleaningBits", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 1, paramName: "cleanTimeMb", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 2, paramName: "compServiceTHw", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 2, paramName: "compStartupDly", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 1, paramName: "dlyAfterPourSb", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 1, paramName: "dlyBeforeEmptySb", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 1, paramName: "dlyBeforeRinseSb", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 1, paramName: "dip", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 2, paramName: "displMDlyDur1Tw", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 2, paramName: "displMDlyDur2Tw", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 2, paramName: "displMDlyDur3Tw", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 2, paramName: "displMDlyDur4Tw", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 2, paramName: "callW.dlyDurMw", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 1, paramName: "callW.dlyMonHb", bytes: [], paramVal: -1, nonInt: []),
    //    Parameter(paramByteLength: 1, paramName: "callW.dis", bytes: [], paramVal: -1, nonInt: [])
        
    //   {1, "callW.dlyMonHb", {}, -1, ""}, {1, "callW.dis", {}, -1, ""}, {2, "hAmps.dlyDurMw", {}, -1, ""},
    //  {1, "hAmps.dlyMonHb", {}, -1, ""}, {1, "hAmps.dis", {}, -1, ""}, {2, "hPres.dlyDurMw", {}, -1, ""}, {1, "hPres.dlyMonHb", {}, -1, ""}, {1, "hPres.dis", {}, -1, ""},
    //  {2, "lowW.dlyDurMw", {}, -1, ""}, {1, "lowW.dlyMonHb", {}, -1, ""}, {1, "lowW.dis", {}, -1, ""}, {2, "wLeak.dlyDurMw", {}, -1, ""}, {1, "wLeak.dlyMonHb", {}, -1, ""},
    //  {1, "wLeak.dis", {}, -1, ""}, {1, "drainToutSb", {}, -1, ""}, {1, "fanRunOnMb", {}, -1, ""}, {2, "fanStartupDly", {}, -1, ""}, {2, "gearSensingDly", {}, -1, ""},
    //  {2, "gearStartupDly", {}, -1, ""}, {1, "have", {}, -1, ""}, {1, "hideUIText", {}, -1, ""}, {1, "imStartupDlySb", {}, -1, ""}, {1, "lowWDlySb", {}, -1, ""},
    //  {2, "maxOffTMw", {}, -1, ""}, {1, "model", {}, -1, ""}, {1, "modelInd", {}, -1, ""}, {1, "pDebounceBits", {}, -1, ""}, {1, "selfFlshBits1", {}, -1, ""},
    //  {1, "selfFlshBits2", {}, -1, ""}, {2, "selfFlushDur1Sw", {}, -1, ""}, {2, "selfFlushDur2Sw", {}, -1, ""}, {2, "selfFlushFreq1Sw", {}, -1, ""},
    //  {2, "selfFlushFreq2Sw", {}, -1, ""}, {1, "selfFlushRepeat1", {}, -1, ""}, {1, "selfFlushRepeat2", {}, -1, ""}, {1, "sleepDelayMb", {}, -1, ""},
    //  {1, "lightUIDurSleep", {}, -1, ""}, {1, "tdlyDrainToutsb", {}, -1, ""}, {1, "tDlyFlushDip", {}, -1, ""}, {1, "tDlyFlushDurSb", {}, -1, ""}, {1, "tDlyFlushEn", {}, -1, ""},
    //  {1, "tDlyFlushFreqMb", {}, -1, ""}, {1, "tDlyFlushRep", {}, -1, ""}, {1, "tDlyLongMb", {}, -1, ""}, {1, "tDlyShortMb", {}, -1, ""}, {1, "FailsafeWhenDisp", {}, -1, ""}, {1, "waterManage", {}, -1, ""},
    //  {2, "wMDrainRetryMw", {}, -1, ""}, {2, "wFillToutSw", {}, -1, ""}, {1, "modbusAddress", {}, -1, ""}, {1, "noWaterADLo", {}, -1, ""}, {1, "noWaterADHi", {}, -1, ""},
    //  {1, "noWaterADDrip", {}, -1, ""}, {1, "noWaterADLeak", {}, -1, ""}, {1, "shuttleFlushEn", {}, -1, ""}, {2, "callWaterToutOnStartSw", {}, -1, ""}, {6, "sn", {}, -1, ""},
    //  {1, "spRunOnSb", {}, -1, ""}, {2, "spStartupDly", {}, -1, ""}, {1, "icePerRes", {}, -1, ""}, {1, "DlyWUsageSb", {}, -1, ""}, {4, "PhDModel", {}, -1, ""},
    ]
    
    enum modes: Int { // List of modes for use later
        case standby
        case waterfill
        case makingice
        case timedelay
        case sleep
        case shutdownicemaking
        case timedelayflush
        case runningflush
        case clean
        case maintenance
        case shuttleflush
    }
    

    var myCentral: CBCentralManager! // Variable that stores the actual manager for the data rx tx
    
    // Variable that stores the peripheral to be connected to: "Follett Ice Machine"
    var myPeripheral: CBPeripheral!
    
    // init all the tx and rx vairables for all the characteristics
    private var ampsLow_tx: CBCharacteristic!
    private var ampsLow_rx: CBCharacteristic!
    private var ampsHigh_tx: CBCharacteristic!
    private var ampsHigh_rx: CBCharacteristic!
    
//    private var mergedin1_tx: CBCharacteristic!
//    private var mergedin1_rx: CBCharacteristic!
//    private var mergedin2_tx: CBCharacteristic!
//    private var mergedin2_rx: CBCharacteristic!
    
//    private var dipSwitches_tx: CBCharacteristic!
//    private var dipSwitches_rx: CBCharacteristic!
//    private var dout0_tx: CBCharacteristic!
//    private var dout0_rx: CBCharacteristic!
    
    private var dipSwitch_tx: CBCharacteristic!
    private var dipSwitch_rx: CBCharacteristic!
    private var errHigh_tx: CBCharacteristic!
    private var errHigh_rx: CBCharacteristic!
    private var mode_tx: CBCharacteristic!
    private var mode_rx: CBCharacteristic!
    private var led1_tx: CBCharacteristic!
    private var led1_rx: CBCharacteristic!
    private var led2_tx: CBCharacteristic!
    private var led2_rx: CBCharacteristic!
    private var swv_tx: CBCharacteristic!
    private var swv_rx: CBCharacteristic!
    private var sn_tx: CBCharacteristic!
    private var sn_rx: CBCharacteristic!
    private var phd_tx: CBCharacteristic!
    private var phd_rx: CBCharacteristic!
    private var mode24_tx: CBCharacteristic!
    private var mode24_rx: CBCharacteristic!
    private var augerCurMax_tx: CBCharacteristic!
    private var augerCurMax_rx: CBCharacteristic!

    @Published var isSwitchedOn = false // Bool to know if Follett Ice Machine is on
    @Published var peripherals = [Peripheral]() // List of all the bluetooth peripheral found
    var gettingMode = false // Bool to know if the 24 hour mode data is incoming
    @Published var modeCount = 0 // Counting the number of values in the 24 hour mode data
    
    @Published var send = false // Bool to know if a written value should be sent
    
    // arrays for data tables
    @Published var maxAmpData: [[Double]] = []
    @Published var minAmpData: [[Double]] = []
    @Published var modeData: [[Double]] = []
    @Published var errorData: [[Double]] = []
    @Published var dipSwitchData: [[Double]] = []
    @Published var led1Data: [[Double]] = []
    @Published var led2Data: [[Double]] = []
    
    // arrays for graphs
    @Published var minEntries: [ChartDataEntry] = []
    @Published var maxEntries: [ChartDataEntry] = []
    @Published var modeEntries: [ChartDataEntry] = []
    @Published var errorEntries: [BarChartDataEntry] = []
    
    @Published var mode24DataPercentage: [PieChartDataEntry] = [PieChartDataEntry(value: 0), PieChartDataEntry(value: 0), PieChartDataEntry(value: 0), PieChartDataEntry(value: 0), PieChartDataEntry(value: 0), PieChartDataEntry(value: 0), PieChartDataEntry(value: 0), PieChartDataEntry(value: 0), PieChartDataEntry(value: 0), PieChartDataEntry(value: 0), PieChartDataEntry(value: 0)] // Percentages of time spent in each mode
    @Published var mode24Data: [Double] = [] // 24 hour mode data
    
    @Published var WPResponses: [String] = Array(repeating: "", count: 82) // var to store written values

    // led and dip switches
    var status = IceMachineStatus.shared
    var dpStatus = DipSwitchStatus.dswitch
    
    //Software version, Serial number, PhD Model
    var swv = 0
    var sn = "I00001"
    var phd = "0470"
    
//    var counter = 0

    override init() { // Initialize the subclass and assign the delegator role to this instance
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) { // On switch
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
    }
    
    // Attaining the peripherals and add them to the list; sort them by rssi
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        var peripheralName: String!

        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        } else {
            peripheralName = "Unknown"
            return
        }
        
        let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue, cbPerpheral: peripheral)
        
        for existing in peripherals {
            if existing.name == peripheral.name {
                return
            }
        }
        
        print(newPeripheral)
        peripherals.append(newPeripheral)
        peripherals.sort(by: { $0.rssi > $1.rssi} )
        
        // to do, make it into the scan view
//        if peripheralName == "Follett Ice Machine" {
//            print(true)
//            self.stopScanning()
//            self.myPeripheral = peripheral
//            self.myPeripheral.delegate = self
//            self.myCentral.connect(myPeripheral, options: nil)
//        }
        
    }
    
    // Used just to connect to the selected peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // to do, throw error when connect to nonesp32
        self.myPeripheral.discoverServices(nil)
        //isConnected = true
    }
    
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral) {
//        // to do, throw error when connect to nonesp32
//        //self.myPeripheral.discoverServices(nil)
//        isConnected = false
//    }
    
//    func didConnect(from central: CBCentralManager, to peripheral: CBPeripheral) -> Bool {
//        centralManager(central, didConnect: peripheral)
//        centralManager(central, didFailToConnect: peripheral)
//        return isConnected
//    }
    
    // Another function that exposes any errors when connecting
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {

        if ((error) != nil) {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        
        print("Discovered Services: \(services)")
    }
    
    // A function that looks to get the characteristics from the service from the peripheral
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
           
        guard let characteristics = service.characteristics else {
              return
        }
            
//        print("Found \(characteristics.count) characteristics.")
//        print("\(characteristics[0])")
//        print("\(characteristics[1])")
//        print("\(characteristics[2])")
//        print("\(characteristics[3])")
//        print("\(characteristics[4])")
//        print("\(characteristics[5])")
//        print("\(characteristics[6])")
        
        
        // Setting the reading and writing characteristics to the characteristics found from the bluetooth service
        for characteristic in characteristics {
            print("SWV: ", characteristic.uuid.uuidString == CBUUIDs.swv_UUID)
            if (characteristic.uuid.uuidString == CBUUIDs.mode_UUID) {
                mode_rx = characteristic
                mode_tx = characteristic
                peripheral.setNotifyValue(true, for: mode_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.ampsLow_UUID)  {
                ampsLow_rx = characteristic
                ampsLow_tx = characteristic
                peripheral.setNotifyValue(true, for: ampsLow_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.ampsHigh_UUID)  {
                ampsHigh_rx = characteristic
                ampsHigh_tx = characteristic
                peripheral.setNotifyValue(true, for: ampsHigh_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.dipSwitch_UUID) {
                dipSwitch_rx = characteristic
                dipSwitch_tx = characteristic
                peripheral.setNotifyValue(true, for: dipSwitch_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.errHigh_UUID) {
                errHigh_rx = characteristic
                errHigh_tx = characteristic
                peripheral.setNotifyValue(true, for: errHigh_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.led1_UUID) {
                led1_rx = characteristic
                led1_tx = characteristic
                peripheral.setNotifyValue(true, for: led1_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.led2_UUID) {
                led2_rx = characteristic
                led2_tx = characteristic
                peripheral.setNotifyValue(true, for: led2_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.swv_UUID) {
                swv_rx = characteristic
                swv_tx = characteristic
                peripheral.setNotifyValue(true, for: swv_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.sn_UUID) {
                sn_rx = characteristic
                sn_tx = characteristic
                peripheral.setNotifyValue(true, for: sn_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.phd_UUID) {
                phd_rx = characteristic
                phd_tx = characteristic
                peripheral.setNotifyValue(true, for: phd_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.mode24_UUID) {
                mode24_rx = characteristic
                mode24_tx = characteristic
                peripheral.setNotifyValue(true, for: mode24_rx!)
                peripheral.readValue(for: characteristic)
            } else if (characteristic.uuid.uuidString == CBUUIDs.augerCurMax_UUID) {
                augerCurMax_rx = characteristic
                augerCurMax_tx = characteristic
                peripheral.setNotifyValue(true, for: augerCurMax_rx!)
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    // Handling for what to do with the values read from the bluetooth service
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        

        guard let characteristicValue = characteristic.value else {
            // no data transmitted, handle if needed
            print("error")
            return
        }
        
//        print("This is \(characteristicValue.count)")
//        print("\(characteristic.uuid)")
//        print("\(characteristicValue)")
        
        if (characteristic.uuid.uuidString == CBUUIDs.mode_UUID){ // Mode data
            gettingMode = false
//            for i in stride(from: 0, through: characteristicValue.count - 1, by: 2) {
            let time = Date().timeIntervalSince1970 // Need to get a time for each value
            if (characteristicValue.description != "0 bytes") { // Make sure there's data
                let mode = Double(characteristicValue[1])
                //              counter = Int(characteristicValue[i])
                
                // Add to the data storage
                self.modeEntries.append(ChartDataEntry(x: Double(time), y: Double(mode), data: "Mode data"))
                self.modeData.append([Double(time), Double(mode)])
                
                // Cut off the data in the graph to only previous 50 values
                if (self.modeData.count > 80){
                    self.modeData = self.modeData.suffix(50)
                }
                if (self.modeEntries.count > 80){
                    self.modeEntries = self.modeEntries.suffix(50)
                }
                
                //            }
            }
        } else if (characteristic.uuid.uuidString == CBUUIDs.mode24_UUID){ // 24 hour mode data
            gettingMode = true

            if (characteristicValue.description != "0 bytes") {
                let mode = Double(characteristicValue[1])
                var label: String
                
                self.mode24Data.append(Double(mode))
                for kv in self.mode24Data.histogram {
                        
                    switch Int(kv.key) {
                    case modes.standby.rawValue:
                        label = "Standby"
                    case modes.waterfill.rawValue:
                        label = "Water Fill"
                    case modes.makingice.rawValue:
                        label = "Making Ice"
                    case modes.timedelay.rawValue:
                        label = "Time Delay"
                    case modes.sleep.rawValue:
                        label = "Sleep"
                    case modes.shutdownicemaking.rawValue:
                        label = "Shutdown Ice Making"
                    case modes.timedelayflush.rawValue:
                        label = "Time Delay Flush"
                    case modes.runningflush.rawValue:
                        label = "Running Flush"
                    case modes.clean.rawValue:
                        label = "Clean Mode"
                    case modes.maintenance.rawValue:
                        label = "Maintenance"
                    case modes.shuttleflush.rawValue:
                        label = "Shuttle Flush"
                    default:
                        label = "Some Error"
                    }
                    var entry = PieChartDataEntry(
                        value: (100 * Double(kv.value)) / Double(self.mode24Data.count),
                        label: label,
                        data: "Mode24 data")
                    if (self.mode24DataPercentage[Int(kv.key)] != entry && (self.mode24Data.count > modeCount+1 || self.mode24Data.count == 288)) {
                        self.mode24DataPercentage[Int(kv.key)] = entry
                    }
                }
            }
        } else if(characteristic.uuid.uuidString == CBUUIDs.ampsLow_UUID){
            gettingMode = false
            let time = Date().timeIntervalSince1970
            
            let minAmpRB = Double(characteristicValue[0]) * 0.01
            let minAmpLB = Double(characteristicValue[1]) * 0.01
            let minAmp = Double(UInt16(minAmpLB) << 8 | UInt16(minAmpRB))
            let minAmpInt = Int(UInt16(minAmpLB) << 8 | UInt16(minAmpRB))
            let minAmpU16 = UInt16(minAmpLB) << 8 | UInt16(minAmpRB)
            
            self.minEntries.append(ChartDataEntry(x: Double(time), y: minAmp, data: "Min Amp data"))
            
            if (self.minAmpData.count > 80){
                self.minAmpData = self.minAmpData.suffix(50)
            }
            if (self.minEntries.count > 80){
                self.minEntries = self.minEntries.suffix(50)
            }
            self.minAmpData.append([Double(time), minAmp])
            print("min")
            print(minAmp)
            print(minAmpInt)
            print(minAmpU16)
            
            
        } else if (characteristic.uuid.uuidString == CBUUIDs.ampsHigh_UUID){
            gettingMode = false
            let time = Date().timeIntervalSince1970
            
            let maxAmpRB = UInt8(characteristicValue[0])
            let maxAmpLB = UInt8(characteristicValue[1])
            let maxAmp = Double(UInt16(maxAmpLB) << 8 | UInt16(maxAmpRB))
            let maxAmpInt = Int(UInt16(maxAmpLB) << 8 | UInt16(maxAmpRB))
            let maxAmpU16 = UInt16(maxAmpLB) << 8 | UInt16(maxAmpRB)
            
            self.maxEntries.append(ChartDataEntry(x: Double(time), y: maxAmp, data: "Max Amp data"))
            
            if (self.maxAmpData.count > 80){
                self.maxAmpData = self.maxAmpData.suffix(50)
            }
            if (self.minEntries.count > 80){
                self.maxEntries = self.maxEntries.suffix(50)
            }

            self.maxAmpData.append([Double(time), maxAmp])
            print("amp")
            print(maxAmp)
            print(maxAmpInt)
            print(maxAmpU16)
            
        } else if (characteristic.uuid.uuidString == CBUUIDs.led1_UUID){
            gettingMode = false
            for i in stride(from: 0, through: characteristicValue.count - 1, by: 2) {
                status.statusArray = [1,0,0,0,0,0,0,0,0,0,0,0]
                let masks: [UInt8] = [1,2,4,8,16,32,64,128]
                
                let val = UInt8(characteristicValue[i+1])
                let time = Date().timeIntervalSince1970
                
                for i in 1...7 {
                    if (val & masks[i] >= 1){
                        status.statusArray[i] = 1
                    }
                }
                
                self.led1Data.append([Double(time), Double(characteristicValue[i+1])])
                if (self.led1Data.count > 80){
                    self.led1Data = self.led1Data.suffix(50)
                }
            }
        } else if (characteristic.uuid.uuidString == CBUUIDs.led2_UUID){
            gettingMode = false
            for i in stride(from: 0, through: characteristicValue.count - 1, by: 2) {
                let masks: [UInt8] = [128,64,32,16]
                let val = UInt8(characteristicValue[i+1])
                let time = Date().timeIntervalSince1970
                if (val&1 >= 1){
                    status.statusArray[6] = 1
                }
                
                for i in 0...3 {
                    if (val&masks[i] >= 1){
                        status.statusArray[i+8] = 1
                    }
                }
                self.led2Data.append([Double(time), Double(characteristicValue[i+1])])
                if (self.led1Data.count > 80){
                    self.led1Data = self.led1Data.suffix(50)
                }
            }

        } else if (characteristic.uuid.uuidString == CBUUIDs.errHigh_UUID){
            gettingMode = false
//            for i in stride(from: 0, through: characteristicValue.count - 1, by: 2) {
                let val = UInt16(characteristicValue[0])
                var errState = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
                let masks: [UInt16] = [1,2,4,8,16,32,64,128,256,512,32768]
                let time = Date().timeIntervalSince1970
                
                for i in 0...10{
                    if (val&masks[i] >= 1){
                        errState[i] = 1.0
                    }
                }
            
                
                self.errorEntries.append(BarChartDataEntry(x: Double(time), yValues: errState, data: "Error data"))
                self.errorData.append([Double(time), Double(val)])
                if (self.errorData.count > 80){
                    self.errorData = self.maxAmpData.suffix(50)
                }
                if (self.errorEntries.count > 80){
                    self.errorEntries = self.errorEntries.suffix(50)
                }
//            }
        } else if (characteristic.uuid.uuidString == CBUUIDs.dipSwitch_UUID){
            gettingMode = false
//            dpStatus.isOn = [false, false, false, false, false, false, false, false]
            dpStatus.isOn = [true, true, true, true, true, true, true, true]
            let masks: [UInt8] = [1,2,4,8,16,32,64,128]
            let time = Date().timeIntervalSince1970
            let val = UInt8(characteristicValue[0])

            for i in 0...7 {
                if (val&masks[i] >= 1){
                    dpStatus.isOn[i] = false
                }
            }
            
            self.dipSwitchData.append([Double(time), Double(characteristicValue[0])])
            if (self.dipSwitchData.count > 80){
                self.dipSwitchData = self.dipSwitchData.suffix(50)
            } 

        } else if (characteristic.uuid.uuidString == CBUUIDs.swv_UUID) {
            gettingMode = false
            swv = (Int(characteristicValue[1]) << 8) + Int(characteristicValue[0])
        } else if (characteristic.uuid.uuidString == CBUUIDs.sn_UUID) {
            gettingMode = false
            if (characteristicValue.description != "0 bytes") {
                sn = String(Character(UnicodeScalar(characteristicValue[0]))) + String(Character(UnicodeScalar(characteristicValue[1]))) + String(Character(UnicodeScalar(characteristicValue[2]))) + String(Character(UnicodeScalar(characteristicValue[3]))) + String(Character(UnicodeScalar(characteristicValue[4]))) + String(Character(UnicodeScalar(characteristicValue[5])))
            }
        } else if (characteristic.uuid.uuidString == CBUUIDs.phd_UUID) {
            gettingMode = false
            if (characteristicValue.description != "0 bytes") {
                phd = String(Character(UnicodeScalar(characteristicValue[0]))) + String(Character(UnicodeScalar(characteristicValue[1]))) + String(Character(UnicodeScalar(characteristicValue[2]))) + String(Character(UnicodeScalar(characteristicValue[3])))
            }
        } else if (characteristic.uuid.uuidString == CBUUIDs.augerCurMax_UUID) {
            gettingMode = false
            params[0].paramVal = (Int32(characteristicValue[1]) << 8) + Int32(characteristicValue[0])
        }
            else {

        }
        if (!gettingMode) {
            modeCount = mode24Data.count
            mode24Data.removeAll()
        }
        
    }
    
    func writeOutgoingValue(data: String){
          
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        
        if let myPeripheral = myPeripheral {
              
            if let txCharacteristic = augerCurMax_tx {
                print(valueString!)
                myPeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    
    func updateParameters(index: Int, data: Int32) {
        print("INSIDE UPDATEPARAM: ", data)
        params[index].paramVal = data
        print(UInt8(data), UInt8(data >> 8))
        writeOutgoingValue(data: String(Character(UnicodeScalar(UInt8(data)))) + String(Character(UnicodeScalar(UInt8(data >> 8)))))
    }
    
    func startScanning() {
        print("startScanning")
        myCentral.scanForPeripherals(withServices: nil, options: nil)
        //Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
     }
    
    func stopScanning() {
        print("stopScanning")
        myCentral.stopScan()
    }
    
    func connect(peripheralName: String){
        
        if let peripheralToConnect = peripherals.first(where: {$0.name == peripheralName}) {
            self.myCentral.connect(peripheralToConnect.cbPerpheral, options: nil)
            peripheralToConnect.cbPerpheral.readValue(for: ampsLow_rx)
        }
    }
    
    func disconnect () {
        if myPeripheral != nil {
            myCentral?.cancelPeripheralConnection(myPeripheral!)
        }
    }
    
    
    
//    @objc func fireTimer() {
//        peripherals.removeAll()
//    }

}

extension BLEManager: CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("Peripheral Is Powered On.")
        case .unsupported:
            print("Peripheral Is Unsupported.")
        case .unauthorized:
        print("Peripheral Is Unauthorized.")
        case .unknown:
            print("Peripheral Unknown")
        case .resetting:
            print("Peripheral Resetting")
        case .poweredOff:
          print("Peripheral Is Powered Off.")
        @unknown default:
          print("Error")
        }
    }
}

extension Sequence where Element: Hashable {
    var histogram: [Element: Int] {
        return self.reduce(into: [:]) { counts, elem in counts[elem, default: 0] += 1 }
    }
}

extension UInt8 {
    var bin: String {
        String(self, radix: 2).leftPad(with: "0", length: 8)
    }
}

fileprivate extension String {
    
    func leftPad(with character: Character, length: UInt) -> String {
        let maxLength = Int(length) - count
        guard maxLength > 0 else {
            return self
        }
        return String(repeating: String(character), count: maxLength) + self
    }
}
