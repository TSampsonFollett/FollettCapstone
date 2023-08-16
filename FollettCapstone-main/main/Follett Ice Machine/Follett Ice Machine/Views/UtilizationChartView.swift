//
//  UtilizationChartView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/2/22.
//  Intented to be used for the utilization pie chart, not used in the current app

import Charts
import SwiftUI

struct UtilizationChartView: View {
    @ObservedObject var BTManager: BLEManager
    @State private var data: [PieChartDataEntry] = [
        PieChartDataEntry(value: 354, label: "Offline"),
        PieChartDataEntry(value: 261, label: "Making Ice"),
        PieChartDataEntry(value: 117, label: "Sleep"),
        PieChartDataEntry(value: 37, label: "Time Delay"),
        PieChartDataEntry(value: 37, label: "Shuttle Flush")
    ]

    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 10) {
                VStack(spacing: 20) {
                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                        .fill(Color(red: 192/255.0, green: 255/255.0, blue: 140/255.0, opacity: 1.0))
                        .frame(width: 10, height: 10)
                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                        .fill(Color(red: 255/255.0, green: 247/255.0, blue: 140/255.0, opacity: 1.0))
                        .frame(width: 10, height: 10)
                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                        .fill(Color(red: 255/255.0, green: 208/255.0, blue: 140/255.0, opacity: 1.0))
                        .frame(width: 10, height: 10)
                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                        .fill(Color(red: 140/255.0, green: 234/255.0, blue: 255/255.0, opacity: 1.0))
                        .frame(width: 10, height: 10)
                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                        .fill(Color(red: 255/255.0, green: 140/255.0, blue: 157/255.0, opacity: 1.0))
                        .frame(width: 10, height: 10)
                }
                VStack(spacing: 15) {
                    Text("Standby")
                    Text("Water Fill")
                    Text("Making ice")
                    Text("Time Delay")
                    Text("Sleep")
                }
                Spacer()
                VStack(spacing: 20) {
                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                        .fill(Color(red: 193/255.0, green: 37/255.0, blue: 82/255.0, opacity: 1.0))
                        .frame(width: 10, height: 10)
                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                        .fill(Color(red: 255/255.0, green: 102/255.0, blue: 0/255.0, opacity: 1.0))
                        .frame(width: 10, height: 10)
                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                        .fill(Color(red: 245/255.0, green: 199/255.0, blue: 0/255.0, opacity: 1.0))
                        .frame(width: 10, height: 10)
                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                        .fill(Color(red: 106/255.0, green: 150/255.0, blue: 31/255.0, opacity: 1.0))
                        .frame(width: 10, height: 10)
                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                        .fill(Color(red: 179/255.0, green: 100/255.0, blue: 53/255.0, opacity: 1.0))
                        .frame(width: 10, height: 10)
                }
                VStack(spacing: 15) {
                    Text("Shutdown ice making")
                    Text("Time delay flush")
                    Text("Running flush")
                    Text("Clean")
                    Text("Maintenance")
                }
                RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                    .fill(Color(red: 129/255.0, green: 150/255.0, blue: 103/255.0, opacity: 1.0))
                    .frame(width: 10, height: 10)
                Text("Shuttle Flush")
            }
            .frame(width: 300, height: 100)
            .font(.system(size: 12))
            .multilineTextAlignment(.center)
//        VStack(alignment: .center, spacing: 20) {
            PieChart(entries: BTManager.mode24DataPercentage).frame(height:300, alignment: .center)
        }
//        Spacer()
    }
}
