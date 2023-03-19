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

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
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
    
    @IBOutlet weak var changeBtn: UIButton!
    
    @IBOutlet weak var saveImageBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var iconTopToLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var iconToptoGraphBottom: NSLayoutConstraint!
    @IBOutlet weak var iconBottomToLabelTop: NSLayoutConstraint!
    @IBOutlet weak var labelBottomToViewTop: NSLayoutConstraint!
    
    private let viewModel = HomeViewModel(service: MosquitoService())
    private var todayData: MosquitoStatus?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "ko_kr")
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "ko_kr")
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController--",MosquitoSingleton.shared.mosquitoDataList)
        
//        attribute()
        bind()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function, "HomeViewController")
        
        // labelSetting
        attribute()
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(self.view.frame.width)
        let width = self.view.frame.width
        if width <= 375 {
            stageMosquitoNumLabel.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        } else {
            stageMosquitoNumLabel.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        }
        
        
    }
    
    private func attribute() {
        // todayData Setting
        let mosquitoDataList = MosquitoSingleton.shared.mosquitoDataList
        let todayString = dateFormatter.string(from: Date())
        todayData = nil
        todayData = mosquitoDataList.first(where: {
            $0.row[0].mosquitoDate == todayString
        })
//        print(#function, todayData)
        // 지수 및 단계 Setting
        let score = Double(todayData?.row[0].mosquitoValueHouse ?? "0.0")!
//        let score = CGFloat(Int.random(in: 0...100))
        let stage = viewModel.getTodayStage(score: score)
        
        // cardView Setting
        cardView.layer.cornerRadius = 5
        cardView.layer.borderWidth = 2
        cardView.shadowSetting(radius: 2, color: .black, opacity: 0.1)
        cardView.clipsToBounds = true
        
        // labelSetting
        let startTimeString = todayString + " 00:00"
        let startDate = timeFormatter.date(from: startTimeString)!
        let endTimeString = todayString + " 03:00"
        let endDate = timeFormatter.date(from: endTimeString)!
        print("startDate", Date(), startDate, Date() > startDate, Date() < startDate)
        print("endDate", Date(), endDate, Date() > endDate, Date() < endDate)
        if (Date() > startDate && Date() < endDate) || todayData == nil {
            backgroundImageView.image = UIImage(named: "backGround5")
            title1.textColor = .white
            title2.textColor = .white
            graphImageView.alpha = 0
            graphLineContainerView.alpha = 0
            graphIconView.image = UIImage(named: "stageIcon5")
            stageLabel.text = "꿀잠단계"
            stageMosquitoNumLabel.text = "00시 부터 딱 3시간만 자고 올게요..zzZ"
            
            cardView.layer.borderColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
            infoView.layer.borderColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
            infoView.backgroundColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1)
            saveImageBtn.layer.borderColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
            shareBtn.layer.borderColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
            lineChartView.layer.borderColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1).cgColor
            
            changeBtn.isEnabled = false
            
        } else {
            backgroundImageView.image = UIImage(named: "backGround\(stage)")
            title1.textColor = .black
            title2.textColor = .black
            graphImageView.alpha = 1
            graphLineContainerView.alpha = 1
            graphIconView.image = UIImage(named: "stageIcon\(stage)")
            stageLabel.text = String(format: NSLocalizedString("stage\(stage)", comment: "Stage"))
            stageMosquitoNumLabel.text = String(format: NSLocalizedString("stage\(stage)MosquitoNum", comment: "MosquitoNum"))
            
            cardView.layer.borderColor = UIColor.white.cgColor
            infoView.layer.borderColor = UIColor.white.cgColor
            saveImageBtn.layer.borderColor = UIColor.white.cgColor
            shareBtn.layer.borderColor = UIColor.white.cgColor
            lineChartView.layer.borderColor = UIColor.white.cgColor
            
            changeBtn.isEnabled = true
        }
        
        // labelSetting
        stageStringLabel.text = String(format: NSLocalizedString("stageString\(stage)", comment: "StageString"))
        stageStringLabel.alpha = 0.0
        
        // infoView Setting
        infoView.layer.cornerRadius = 5
        infoView.layer.borderWidth = 2
        infoIndoorLabel.text = String(format: NSLocalizedString("stage\(stage)-1", comment: "indoorText"))
        infoOutdoorLabel.text = String(format: NSLocalizedString("stage\(stage)-2", comment: "outdoorText"))
        infoTextView.isHidden = true
        
        // saveImageBtn Setting
        saveImageBtn.layer.cornerRadius = 5
        saveImageBtn.layer.borderWidth = 2
        saveImageBtn.shadowSetting(radius: 2, color: .black, opacity: 0.1)
        saveImageBtn.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        // shareBtn Setting
        shareBtn.layer.cornerRadius = 5
        shareBtn.layer.borderWidth = 2
        shareBtn.shadowSetting(radius: 2, color: .black, opacity: 0.1)
        shareBtn.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        
        // graph Setting
        // y = x * pi / 100 - pi/2
        let rotation = viewModel.getRotation(score: score)
        self.graphLineContainerView.transform = CGAffineTransform(rotationAngle: rotation)
        self.graphLineView.backgroundColor = UIColor(named: "graphColor\(stage)")
        self.graphLineHeadView.backgroundColor = UIColor(named: "graphColor\(stage)")
        self.graphLineHeadView.circleCorner()
        
        // chartDataSetting
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
        line1.mode = .horizontalBezier
        
        line1.drawValuesEnabled = false
        line1.drawCirclesEnabled = false
        line1.drawIconsEnabled = false
        
        let data = LineChartData(dataSet: line1)
        
        lineChartView.data = data
        
        // chartView Setting
        lineChartView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        lineChartView.layer.cornerRadius = 5
        lineChartView.layer.borderWidth = 2
        lineChartView.shadowSetting(radius: 2, color: .black, opacity: 0.1)
        lineChartView.clipsToBounds = true
        
        lineChartView.pinchZoomEnabled = false
        lineChartView.dragEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.highlightPerTapEnabled = false
        
        lineChartView.legend.enabled = false
        
        lineChartView.extraRightOffset = 24
        lineChartView.extraLeftOffset = 24
        lineChartView.extraBottomOffset = 15
        
        // 차트 세로선 설정
        let xAxis = lineChartView.xAxis
        xAxis.enabled = true
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "Pretendard-SemiBold", size: 14)!
        xAxis.labelTextColor = UIColor.black
        xAxis.drawAxisLineEnabled = false
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
        leftAxis.gridColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.35)
        leftAxis.gridLineWidth = 2.0
        leftAxis.centerAxisLabelsEnabled = false
        leftAxis.drawLabelsEnabled = false
        

        
        
    }
    
    private func bind() {
        viewModel.didUpdateError = { [weak self] error in
            self?.changeBtn.isSelected = true
            self?.tapCardView(self?.changeBtn ?? UIButton())
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                LoadingHUD.hide()
                self?.attribute()
            }
        }
        
        viewModel.didMosquitoInfoEnd = { [weak self] in
            self?.changeBtn.isSelected = true
            self?.tapCardView(self?.changeBtn ?? UIButton())
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                LoadingHUD.hide()
                self?.attribute()
            }
        }
    }

    
    @IBAction func tapCardView(_ sender: UIButton) {
        print(self.view.frame)
        sender.isSelected = !sender.isSelected
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.iconToptoGraphBottom.constant = sender.isSelected ? -29 - 77 : -60
                
                self.iconTopToLabelBottom.constant = sender.isSelected ? 4 : 21
                
                self.iconBottomToLabelTop.constant = sender.isSelected ? 4 : 9.76
                
                self.labelBottomToViewTop.constant = sender.isSelected ? 2 : 15
                
                self.infoTextView.isHidden = sender.isSelected ? false : true
                self.stageStringLabel.alpha = sender.isSelected ? 1.0 : 0.0
                self.view.layoutIfNeeded()
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.infoTextView.alpha = sender.isSelected ? 1 : 0
                self.view.layoutIfNeeded()
            }
            
            UIView.addKeyframe(withRelativeStartTime: sender.isSelected ? 0 : 0.5, relativeDuration: sender.isSelected ? 0.5 : 1.0) {
                self.graphImageView.alpha = sender.isSelected ? 0 : 1
                self.graphLineContainerView.alpha = sender.isSelected ? 0 : 1
                self.view.layoutIfNeeded()
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1.0) {
                self.graphImageView.alpha = sender.isSelected ? 0 : 1
                self.graphLineContainerView.alpha = sender.isSelected ? 0 : 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func tapRefresh(_ sender: Any) {
        LoadingHUD.show()
        viewModel.getMosquitoInfo()
        
    }
    
    
    @IBAction func tapSaveImage(_ sender: Any) {
        LoadingHUD.show()
        UIImageWriteToSavedPhotosAlbum(cardView.asImage(), self, #selector(imageSaveEnd(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    // TODO: 공유하기 테스트 필요
    @IBAction func tapShare(_ sender: Any) {
        let shareImage = cardView.asImage()

        let activityVC = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view

        // 공유하기 기능 중 제외할 기능이 있을 때 사용
        // activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc private func imageSaveEnd(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        print(#function)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            LoadingHUD.hide()
            if let error = error {
                
            } else {
                let screenShotVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScreenShotViewController") as! ScreenShotViewController
                screenShotVC.modalTransitionStyle = .crossDissolve
                screenShotVC.modalPresentationStyle = .overCurrentContext
                screenShotVC.imageFrame = self.cardView.globalFrame!
                screenShotVC.screenShotImage = self.cardView.asImage()
                self.present(screenShotVC, animated: true)
            }
        }
    }
    
}

