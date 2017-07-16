//  545204 平岡　祥太
//  Soundcontroller .swift
//  音響メディア論
//
//  Created by raoka0000 on 2017/07/14.
//  Copyright © 2017年 raoka0000. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation


let π:Float = .pi//円周率
let 秒数:Int = 1//秒数s
var 基本周波数:Float = 440.0 //f0
let サンプリング数:Float = 44100.0 // １秒間のサンプル数を表す。
let 総サンプル数:UInt32 = UInt32(サンプリング数) * UInt32(秒数)
let 第n高調波:Int = 30 //加算する高調波の数
let 振幅:Float = 100 //amp

var audioEngine = AVAudioEngine()

func 正弦波() -> [Float]{
    return 再生(正弦波生成)
}
func 三角波() -> [Float]{
    return 再生(三角波生成)
}
func 矩形波() -> [Float]{
    return 再生(矩形波生成)
}
func ノコギリ波() -> [Float]{
    return 再生(ノコギリ生成)
}

func 正弦波生成(_ buffer:AVAudioPCMBuffer) -> [Float]{
    var waveData = [Float](repeating: 0, count: Int(総サンプル数))
    for i in 0..<waveData.count {
        waveData[i] = sinf(2.0 * π * 基本周波数 * Float(i) / サンプリング数) * 振幅
    }
    return waveData
}

func 三角波生成(_ buffer:AVAudioPCMBuffer) -> [Float]{
    var waveData = [Float](repeating: 0, count: Int(総サンプル数))
    for n in 0..<第n高調波 {
        let k = Float(n)
        for i in 0..<waveData.count {
            let t = Float(i) / サンプリング数
            waveData[i] += (8.0 / powf(π, 2)) * powf(-1, k) * sinf(2 * π * (2 * k + 1) * 基本周波数 * t) / powf(2 * k + 1,2) * 振幅
        }
    }
    return waveData
}

func 矩形波生成(_ buffer:AVAudioPCMBuffer) -> [Float]{
    var waveData = [Float](repeating: 0, count: Int(総サンプル数))
    for n in 1...第n高調波 {
        let k = Float(n)
        for i in 0..<waveData.count {
            let t = Float(i) / サンプリング数
            waveData[i] += (4.0 / π) * sinf(2.0 * π * (2 * k - 1) * 基本周波数 * t) / (2 * k - 1) * 振幅
        }
    }
    return waveData
}

func ノコギリ生成(_ buffer:AVAudioPCMBuffer) -> [Float]{
    var waveData = [Float](repeating: 0, count: Int(総サンプル数))
    for n in 1...第n高調波 {
        let k = Float(n)
        for i in 0..<waveData.count {
            let t = Float(i) / サンプリング数
            waveData[i] += (2.0 / π) * sinf(2.0 * π * k * 基本周波数 * t) / k * 振幅
        }
    }
    return waveData
}


//グラフ描写に使うデータを返します.
func 再生(_ 波形関数 : (AVAudioPCMBuffer) -> [Float]) -> [Float]{
    let player = AVAudioPlayerNode()
    
    // プレイヤーノードからオーディオフォーマットを取得
    let audioFormat = player.outputFormat(forBus: 0)
    // PCMバッファーを生成
    let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity:総サンプル数)
    buffer.frameLength = 総サンプル数
    
    let waveData = 波形関数(buffer)
    let samples = buffer.floatChannelData?[0]
    for n in 0..<Int(buffer.frameLength) {
        samples?[n] = waveData[n]
    }

    
    audioEngine.attach(player)
    let mixer = audioEngine.mainMixerNode
    audioEngine.connect(player, to: mixer, format: audioFormat)
    // 再生の開始を設定
    player.scheduleBuffer(buffer) {
        print("Play completed")
    }
    do {
        // エンジンを開始
        try audioEngine.start()
        player.play()// 再生
    } catch let error {
        print(error)
    }
    
    let waveDataForDrow:[Float] = Array (waveData[0..<Int(サンプリング数 / 基本周波数) * 2])
    return waveDataForDrow
}


