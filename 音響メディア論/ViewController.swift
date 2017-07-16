//  545204 平岡　祥太
//  ViewController.swift
//  音響メディア論
//
//  Created by raoka0000 on 2017/07/14.
//  Copyright © 2017年 raoka0000. All rights reserved.
//

import UIKit
import Charts
import PathMenu

class ViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var lineChartView: LineChartView!
    
    let pathMenuDelegateOnkai:PathMenuDelegateOnkai! = PathMenuDelegateOnkai()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //チャートの準備
        self.lineChartView.delegate = self
        //ボタンの準備
        音階ボタン()
        音波ボタン()
        view.backgroundColor = UIColor(red:0.96, green:0.94, blue:0.92, alpha:1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func 音階ボタン(){
        let menuItemImage = UIImage(named: "maru")!
        let onpuImage = UIImage(named: "onkai")!
        let abcdefg = ["a", "b", "c", "d", "e", "f", "g"]
        var items = [PathMenuItem]()
        for oto in abcdefg{
            items.append(PathMenuItem(image: menuItemImage, highlightedImage: menuItemImage, contentImage: UIImage(named: oto)))
        }
        let startItem = PathMenuItem(image: menuItemImage,
                                     highlightedImage: menuItemImage,
                                     contentImage: onpuImage,
                                     highlightedContentImage: onpuImage)
        let menu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
        menu.delegate = pathMenuDelegateOnkai
        menu.startPoint = CGPoint(x: UIScreen.main.bounds.width * 0.9, y: view.frame.size.height * 0.1)
        menu.animationDuration = 0.3 // アニメーション速度
        menu.menuWholeAngle = CGFloat(π * 0.5) // アイテムを角度を制限
        menu.rotateAngle    = CGFloat(π) //メニューの向き
        menu.farRadius      = 500.0
        menu.endRadius      = 300.0
        view.addSubview(menu)
    }
    
    func 音波ボタン(){
        let menuItemImage = UIImage(named: "maruBig")!
        let onpuImage = UIImage(named: "onpa")!
        let abcdefg = ["wave_seigen", "wave_sankaku", "wave_kukei", "wave_nokogiri"]
        var items = [PathMenuItem]()
        for oto in abcdefg{
            items.append(PathMenuItem(image: menuItemImage, highlightedImage: menuItemImage, contentImage: UIImage(named: oto)))
        }
        let startItem = PathMenuItem(image: menuItemImage,
                                     highlightedImage: menuItemImage,
                                     contentImage: onpuImage,
                                     highlightedContentImage: onpuImage)
        let menu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
        menu.delegate = self
        menu.startPoint = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: view.frame.size.height * 0.3)
        menu.animationDuration = 0.3 // アニメーション速度
        menu.rotateAngle    = CGFloat(π/4) //メニューの向き
        menu.farRadius      = 200.0
        menu.endRadius      = 150.0
        view.addSubview(menu)
    }

    
    func setChart(_ y: [Float]) {
        
        // グラフタイトル
        lineChartView.chartDescription?.text = "２周期分の波形"
        
        // アニメーション
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        lineChartView.xAxis.enabled = false
        lineChartView.borderColor = NSUIColor.black
        
        
        // y軸
        var data = [BarChartDataEntry]()
        
        
        for (i, val) in y.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(val))
            data.append(dataEntry)
        }
        // グラフをセット
        let dataSet = LineChartDataSet(values: data, label: "波")
        lineChartView.data = LineChartData(dataSet: dataSet)
        dataSet.drawIconsEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.setColor(NSUIColor.black)
        
    }
    
}

extension ViewController: PathMenuDelegate {
    func didSelect(on menu: PathMenu, index: Int) {
        switch index {
        case 0:
            setChart(正弦波())
        case 1:
            setChart(三角波())
        case 2:
            setChart(矩形波())
        case 3:
            setChart(ノコギリ波())
        default:
            print("Select the index : \(index)")
        }
    }
    func willStartAnimationOpen(on menu: PathMenu) {
        
    }
    func willStartAnimationClose(on menu: PathMenu){}
    func didFinishAnimationOpen(on menu: PathMenu) {}
    func didFinishAnimationClose(on menu: PathMenu) {}
}

class PathMenuDelegateOnkai: PathMenuDelegate {
    let 音階:[Float] = [440.000, 493.883, 523.251, 587.330, 659.255, 698.456, 783.991]
    func didSelect(on menu: PathMenu, index: Int) {
        基本周波数 = 音階[index]
        print("基本周波数は\(基本周波数)")
    }
    func willStartAnimationOpen(on menu: PathMenu) {}
    func willStartAnimationClose(on menu: PathMenu){}
    func didFinishAnimationOpen(on menu: PathMenu) {}
    func didFinishAnimationClose(on menu: PathMenu) {}
}

