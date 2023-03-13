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

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var graphImageView: UIImageView!
    
    @IBOutlet weak var graphLineContainerView: UIView!
    @IBOutlet weak var graphLineHeadView: UIView!
    @IBOutlet weak var graphLineView: UIView!
    @IBOutlet weak var graphIconView: UIImageView!
    
    @IBOutlet weak var stageStringLabel: UILabel!
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var stageMosquitoNumLabel: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoTextView: UIView!
    @IBOutlet weak var infoIndoorLabel: UILabel!
    @IBOutlet weak var infoOutdoorLabel: UILabel!
    
    
    @IBOutlet weak var saveImageBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var iconTopToLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var iconToptoGraphBottom: NSLayoutConstraint!
    @IBOutlet weak var iconBottomToLabelTop: NSLayoutConstraint!
    @IBOutlet weak var labelBottomToViewTop: NSLayoutConstraint!
    
    private let viewModel = HomeViewModel(service: MosquitoService())
    private var todayData: MosquitoStatus?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController--",MosquitoSingleton.shared.mosquitoDataList)
        
        attribute()
//        bind()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function, "HomeViewController")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function, "HomeViewController")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(#function, "HomeViewController")
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(#function, "HomeViewController")
    }
    
    private func attribute() {
        // todayData Setting
        let mosquitoDataList = MosquitoSingleton.shared.mosquitoDataList
        todayData = mosquitoDataList.first(where: {
            $0.row[0].mosquitoDate == "2023-03-14"
        })
        
        // 지수 및 단계 Setting
        let score = Double(todayData?.row[0].mosquitoValueHouse ?? "0.0")!
        let stage = viewModel.getTodayStage(score: score)
        
        // cardView Setting
        cardView.layer.cornerRadius = 5
        cardView.shadowSetting(radius: 2, color: .black, opacity: 0.1)
        
        // labelSetting
        stageStringLabel.text = String(format: NSLocalizedString("stageString\(stage)", comment: "StageString"))
        stageLabel.text = String(format: NSLocalizedString("stage\(stage)", comment: "Stage"))
        stageMosquitoNumLabel.text = String(format: NSLocalizedString("stage\(stage)MosquitoNum", comment: "MosquitoNum"))
        
        // infoView Setting
        infoIndoorLabel.text = String(format: NSLocalizedString("stage\(stage)-1", comment: "indoorText"))
        infoOutdoorLabel.text = String(format: NSLocalizedString("stage\(stage)-2", comment: "outdoorText"))
        
        // saveImageBtn Setting
        saveImageBtn.layer.cornerRadius = 5
        saveImageBtn.shadowSetting(radius: 2, color: .black, opacity: 0.1)
        // shareBtn Setting
        shareBtn.layer.cornerRadius = 5
        shareBtn.shadowSetting(radius: 2, color: .black, opacity: 0.1)
        
        infoTextView.isHidden = true
        
        // graph Setting
        // y = x * pi / 100 - pi/2
        let rotation = viewModel.getRotation(score: score)
        self.graphLineContainerView.transform = CGAffineTransform(rotationAngle: rotation)
        self.graphLineView.backgroundColor = UIColor(named: "graphColor\(stage)")
        self.graphLineHeadView.backgroundColor = UIColor(named: "graphColor\(stage)")
        self.graphLineHeadView.circleCorner()
        self.graphIconView.image = UIImage(named: "stageIcon\(stage)")
        
        
        // chart Setting
        lineChartView.layer.cornerRadius = 5
        lineChartView.shadowSetting(radius: 2, color: .black, opacity: 0.1)
        
        var lineChartEntry = [ChartDataEntry]()
        var xAxisStringList = [String]()
        for (idx, data) in mosquitoDataList.enumerated() {
//            print(data)
            // 아이콘 이미지 설정
            let value = ChartDataEntry(x: Double(idx), y: Double(data.row[0].mosquitoValueHouse)!)
            let xAxis = (data.row[0].mosquitoDate).components(separatedBy: "-")
            print(value, xAxis)
            xAxisStringList.append("\(xAxis[1]).\(xAxis[2])")
            lineChartEntry.append(value)
        }
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number")
        
        line1.colors = [NSUIColor.red]
        line1.lineWidth = 4
        // 선의 둥글기
        line1.mode = .cubicBezier
        line1.cubicIntensity = 0.2
        
        line1.drawValuesEnabled = true
        line1.drawCirclesEnabled = false
        line1.drawIconsEnabled = false
        
        let data = LineChartData(dataSet: line1)
        
        lineChartView.data = data
        
        // chartView Setting
        lineChartView.backgroundColor = UIColor.white
        
        lineChartView.legend.enabled = false
        
        lineChartView.extraRightOffset = 17
        lineChartView.extraLeftOffset = 17
        lineChartView.extraBottomOffset = 10
        
        // 차트 세로선 설정
        let xAxis = lineChartView.xAxis
        xAxis.enabled = true
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "KoreanERWJL", size: 14)!
        xAxis.labelTextColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
        xAxis.drawAxisLineEnabled = true
        xAxis.axisLineColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        xAxis.axisLineWidth = 1.0
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = false
        xAxis.granularityEnabled = true
        xAxis.yOffset = 10.0

        xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisStringList)
        // 차트 가로선 설정
        lineChartView.rightAxis.enabled = false
        let leftAxis = lineChartView.leftAxis
        leftAxis.enabled = true
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        leftAxis.gridLineWidth = 1.0
        leftAxis.centerAxisLabelsEnabled = false
        leftAxis.drawLabelsEnabled = false
        

        
        
    }
    
    private func bind() {
        viewModel.getMosquitoInfo()
    }

    
    @IBAction func tapCardView(_ sender: UIButton) {
        print(self.view.frame)
        sender.isSelected = !sender.isSelected
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.iconToptoGraphBottom.constant = sender.isSelected ? -29 - 77 : -29
                
                self.iconTopToLabelBottom.constant = sender.isSelected ? 8 : 21
                
                self.iconBottomToLabelTop.constant = sender.isSelected ? 0 : 9.76
                
                self.labelBottomToViewTop.constant = sender.isSelected ? 8 : 15
                
                self.infoTextView.isHidden = sender.isSelected ? false : true

                self.view.layoutIfNeeded()
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.infoTextView.alpha = sender.isSelected ? 1 : 0
                self.view.layoutIfNeeded()
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.graphImageView.alpha = sender.isSelected ? 0 : 1
                self.graphLineContainerView.alpha = sender.isSelected ? 0 : 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func tapSaveImage(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(cardView.asImage(), self, #selector(imageSaveEnd(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func tapShare(_ sender: Any) {
        let screenShotVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        screenShotVC.modalTransitionStyle = .crossDissolve
        screenShotVC.modalPresentationStyle = .overCurrentContext
        screenShotVC.imageFrame = cardView.globalFrame!
        screenShotVC.screenShotImage = cardView.asImage()
        present(screenShotVC, animated: true)
    }
    
    @objc private func imageSaveEnd(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        print(#function)
        if let error = error {
            
        } else {
            let screenShotVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScreenShotViewController") as! ScreenShotViewController
            screenShotVC.modalTransitionStyle = .crossDissolve
            screenShotVC.modalPresentationStyle = .overCurrentContext
            screenShotVC.imageFrame = cardView.globalFrame!
            screenShotVC.screenShotImage = cardView.asImage()
            present(screenShotVC, animated: true)
        }
    }
    
}

