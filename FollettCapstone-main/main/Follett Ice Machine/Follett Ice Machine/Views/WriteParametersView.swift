//
//  WriteParametersView.swift
//  Follett Ice Machine
//
//  Created by Trey Sampson on 8/7/23.
//

import SwiftUI

struct WriteParametersView: View {
    @ObservedObject var BTManager: BLEManager
    @State var textFieldText: [String]
    @State var showingAlert = false
    var body: some View {
    
        ScrollView {
            VStack {
                ForEach(0..<BTManager.params.count) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 400, height: 75)
                            .foregroundColor(.blue)
                        HStack {
                            Text(BTManager.params[index].paramName)
                            Spacer()
                            TextField(String(BTManager.params[index].paramVal), text: $textFieldText[index])
                                .frame(width: 100, height: 50)
                                .background(Color.white.cornerRadius(10))
                                .foregroundColor(.green)
                                .font(.title)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 350, height: 75, alignment: .center)
                        .foregroundColor(.white)
                        .font(.title.bold())
                    }
                }
                Button(action: {
                    showingAlert = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.green)
                        Text("Send")
                            .font(.title.bold())
                            .foregroundColor(.white)
                    }
                    
                }
                .frame(width: 100, height: 50)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Send Parameters?"),
                          message: Text("All changes will be sent"),
                          primaryButton: .default(Text("Send")) {
                        BTManager.send = true
                        for index in 0..<BTManager.params.count {
                            if (textFieldText[index] != "") {
                                print("INSIDE IF STATEMENT")
                                BTManager.updateParameters(index: index, data: Int32(textFieldText[index]) ?? -1)
                                textFieldText[index] = ""
                            }
                        }
                    },
                          secondaryButton: .destructive(Text("Cancel")))
                }
            }
        }
    }
}

struct WriteParametersView_Previews: PreviewProvider {
    static var previews: some View {
        WriteParametersView(BTManager: BLEManager(), textFieldText: BLEManager().WPResponses)
    }
}
