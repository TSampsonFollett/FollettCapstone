//
//  ChartsMultipleLineChart.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 4/29/22.
//  State/model chart utilizing linechart

import SwiftUI
import Charts


struct StateChartView: View {
    @ObservedObject var BTManager: BLEManager
    var currentMode = ""

    var body: some View {
        
        VStack(alignment: .center) {
//            HStack(spacing: 10) {
//                VStack(spacing: 20) {
//                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
//                        .fill(.green)
//                        .frame(width: 10, height: 10)
//                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
//                        .fill(.yellow)
//                        .frame(width: 10, height: 10)
//                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
//                        .fill(.blue)
//                        .frame(width: 10, height: 10)
//                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
//                        .fill(.red)
//                        .frame(width: 10, height: 10)
//                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
//                        .fill(.brown)
//                        .frame(width: 10, height: 10)
//                }
//                VStack(spacing: 15) {
//                    Text("Standby")
//                    Text("Water Fill")
//                    Text("Making ice")
//                    Text("Time Delay")
//                    Text("Sleep")
//                }
//                Spacer()
//                VStack(spacing: 20) {
//                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
//                        .fill(.cyan)
//                        .frame(width: 10, height: 10)
//                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
//                        .fill(.indigo)
//                        .frame(width: 10, height: 10)
//                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
//                        .fill(.orange)
//                        .frame(width: 10, height: 10)
//                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
//                        .fill(.white)
//                        .frame(width: 10, height: 10)
//                    RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
//                        .fill(.mint)
//                        .frame(width: 10, height: 10)
//                }
//                VStack(spacing: 15) {
//                    Text("Shutdown ice making")
//                    Text("Time delay flush")
//                    Text("Running flush")
//                    Text("Clean")
//                    Text("Maintenance")
//                }
//            }
//            .frame(width: 300, height: 100)
//            .font(.system(size: 12))
//            .multilineTextAlignment(.center)
            LineChart(entries: BTManager.modeEntries).frame(width: 300, height: 300, alignment: .center)
            //PieChart(entries: BTManager.modeDataPercentage).frame(width: 300, height: 300, alignment: .center)
        }
    }
}

