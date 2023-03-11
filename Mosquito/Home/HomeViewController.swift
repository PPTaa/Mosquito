//
//  ViewController.swift
//  Mosquito
//
//  Created by leejungchul on 2023/03/03.
//

import UIKit
import Alamofire
import Charts

class HomeViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    private let viewModel = HomeViewModel(service: MosquitoService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        bind()
        
    }
    
    private func attribute() {
        // chartView Setting
        
        lineChartView.backgroundColor = UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1)
        // 차트 세로선 설정
        lineChartView.xAxis.enabled = true
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.legend.enabled = false
        
        
        let numbers = [10,9,8,7,6,5,4,3,2,1,0]
        var lineChartEntry = [ChartDataEntry]()
        for i in 0...10 {
            // 아이콘 이미지 설정
            let value = ChartDataEntry(x: Double(i), y: Double(Int.random(in: 0...20)), icon: NSUIImage(systemName: "star.fill"))
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number")
        
        
        line1.colors = [NSUIColor.brown]
        line1.lineWidth = 10
        line1.circleRadius = 10
        
        line1.drawCirclesEnabled = false
        line1.drawIconsEnabled = true
        // 그래프 하단 그라데이션 설정
        let gradientColors = [
            //00: 불투명, ff: 투명
            ChartColorTemplates.colorFromString("#00f4f4f4").cgColor,
            ChartColorTemplates.colorFromString("#ffd9d9d9").cgColor
        ]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        line1.fillAlpha = 1
        line1.fill = LinearGradientFill(gradient: gradient, angle: 90)
        
        line1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: line1)
        
        lineChartView.data = data
        
        
        lineChartView.chartDescription.text = "test"
    }
    
    private func bind() {
        viewModel.getMosquitoInfo()
    }


}

