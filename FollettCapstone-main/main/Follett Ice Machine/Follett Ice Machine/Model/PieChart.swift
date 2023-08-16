//
//  UtilizationChart.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/2/22.
//  Support for SwiftUI, ability to display pie chart, intended to used for the utilization summary, but not used in the current app

import Foundation
import Charts
import SwiftUI

struct PieChart: UIViewRepresentable {
    let entries: [ChartDataEntry]
    let pieChart = PieChartView()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> PieChartView {
        pieChart.delegate = context.coordinator
        pieChart.noDataText = "No Data"
                        
        pieChart.drawEntryLabelsEnabled = true
    
        pieChart.usePercentValuesEnabled = true
        pieChart.legend.enabled = false
        
        pieChart.isUserInteractionEnabled = true
        
        return pieChart
    }
    
    func updateUIView(_ uiView: PieChartView, context: Context) {
        let dataSet = PieChartDataSet(entries: entries)
//        dataSet.label = "Utilization"
        dataSet.colors = [
            NSUIColor(red: 192/255.0, green: 255/255.0, blue: 140/255.0, alpha: 1.0),
            NSUIColor(red: 255/255.0, green: 247/255.0, blue: 140/255.0, alpha: 1.0),
            NSUIColor(red: 255/255.0, green: 208/255.0, blue: 140/255.0, alpha: 1.0),
            NSUIColor(red: 140/255.0, green: 234/255.0, blue: 255/255.0, alpha: 1.0),
            NSUIColor(red: 255/255.0, green: 140/255.0, blue: 157/255.0, alpha: 1.0),
            NSUIColor(red: 193/255.0, green: 37/255.0, blue: 82/255.0, alpha: 1.0),
            NSUIColor(red: 255/255.0, green: 102/255.0, blue: 0/255.0, alpha: 1.0),
            NSUIColor(red: 245/255.0, green: 199/255.0, blue: 0/255.0, alpha: 1.0),
            NSUIColor(red: 106/255.0, green: 150/255.0, blue: 31/255.0, alpha: 1.0),
            NSUIColor(red: 179/255.0, green: 100/255.0, blue: 53/255.0, alpha: 1.0),
            NSUIColor(red: 129/255.0, green: 150/255.0, blue: 103/255.0, alpha: 1.0)
        ]
        dataSet.drawIconsEnabled = false
        
        dataSet.valueColors = [.black]
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        formatter.zeroSymbol = ""
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        
        dataSet.xValuePosition = .insideSlice
        dataSet.yValuePosition = .insideSlice
        
        uiView.data = PieChartData(dataSet: dataSet)
        
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent: PieChart
        
        init(parent: PieChart) {
            self.parent = parent
        }
    }
}
