//
//  ScanView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/29/22.
//  Modal that display all existing ble

import SwiftUI

struct ScanView: View {
    
    @ObservedObject var BTManager: BLEManager
    @Binding var isPresented: Bool
    @State var showingAlert = false
    @State var storePeripheral = Peripheral(id: 0, name: "Hi", rssi: 0, cbPerpheral: nil)
    
    var body: some View {
        
        NavigationView {
            // display all existing ble
            List(BTManager.peripherals) { peripheral in
                    // name of the ble devices
                    
                    Button(action: {
                        //print("The BUTTONS WORK")
                        showingAlert = true
                        storePeripheral = peripheral
                    }) {
                        HStack {
                            Text(peripheral.name)
                            Spacer()
                            switch peripheral.cbPerpheral.state {
                            case .disconnected:
                                Text("Not Connected")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.gray)
                            case .connecting:
                                Text("Connecting...")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.gray)
                            case .connected:
                                Text("Connected")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.gray)
                            default:
                                Text("Disconnecting...")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.gray)
                            }
                    }.buttonStyle(BorderedButtonStyle())
//                    Text(peripheral.name)
//                    Spacer()


//                        //                    if (BTManager.didConnect(from: BTManager.myCentral, to: peripheral.cbPerpheral)) {
//                        //                        Text("Connected")
//                        //                    }
//                        //                    else {
//                        //                        Text("Not Connected")
//                        //                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Bluetooth Available"),
                          message: Text("Are you sure you want to connect to " + storePeripheral.name),
                          primaryButton: .default(Text("Connect")) {
                        if storePeripheral.name == "Follett Ice Machine" {
                            print(true)
                            BTManager.stopScanning()
                            BTManager.myPeripheral = storePeripheral.cbPerpheral
                            BTManager.myPeripheral.delegate = BTManager
                            BTManager.myCentral.connect(BTManager.myPeripheral, options: nil)
                        }
                    },
                          secondaryButton: .destructive(Text("Cancel")))
                }
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    //.fill(colorInvert())
////                    print(peripheral.rssi)
////                    BTManager.writeOutgoingValue(data: "Hello World")
//
//                    // comment out this if dynamic, change in blemanager
////                    BTManager.connect(peripheralName: peripheral.name)
////                    if peripheral.name == "Follett Ice Machine" {
////                        print(true)
////                        BTManager.stopScanning()
//
////                    }
//                }
            }
            
            .navigationBarTitle(Text("Scanning..."), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    isPresented = false
                }) {
                    Text("Done").bold()
                })
        }
    }
}
