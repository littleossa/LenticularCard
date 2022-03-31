//
//  MotionAlphaManager.swift
//  LenticularCard
//
//  Created by 平岡修 on 2022/03/30.
//

import CoreMotion
import CoreGraphics

class LenticulationManager: ObservableObject {
    
    @Published var middleImageOpacity: CGFloat = 1
    @Published var frontImageOpacitry: CGFloat = 0
    
    private let motionManager = CMMotionManager()
    
    ///  基準にする角度
    private let baseDegrees: CGFloat = 60
    
    init() {
        if motionManager.isDeviceMotionAvailable {
            startUpdatingLenticulation()
        }
    }
    
    private func startUpdatingLenticulation() {
        // 1秒間に60回アップデートする
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (deviceMotion, error) in
            guard let deviceMotion = deviceMotion,
                  error == nil
            else { return }
            
            // ラジアンを角度に変換
            let degree = deviceMotion.attitude.roll.convertedRadianToDegree()
            // 角度から姿勢状態に変換
            let attitudeState = DeviceAttitudeState(degree)
            // 姿勢の状態に応じてImageOpacityの値を更新
            self.updateImageOpacity(with: attitudeState)
        }
    }
    
    /// デバイスの姿勢状態に応じてImageOpacityの値を更新
    private func updateImageOpacity(with attributeState: DeviceAttitudeState) {
        
        switch attributeState {
        case .flat:
            update(middleImageOpacity: 1, andFrontImageOpacity: 0)
        case .forward(let degree):
            let frontOpacity = degree >= baseDegrees ?  1 : degree / baseDegrees
            update(middleImageOpacity: 1, andFrontImageOpacity: frontOpacity)
        case .backward(let degree):
            let middleOpacity = degree >= baseDegrees ?  0 : (baseDegrees - degree) / baseDegrees
            update(middleImageOpacity: middleOpacity, andFrontImageOpacity: 0)
        }
    }
    
    private func update(middleImageOpacity: CGFloat,
                        andFrontImageOpacity frontImageOpacty: CGFloat) {
        self.middleImageOpacity = middleImageOpacity
        self.frontImageOpacitry = frontImageOpacty
    }
}

extension LenticulationManager {
    
    enum DeviceAttitudeState {
        case flat
        case forward(degree: Double)
        case backward(degree: Double)
        
        init(_ degree: Double) {
            
            switch degree {
            case 1...180:
                self = .forward(degree: degree)
            case -180 ... -1:
                let positiveDegree = degree * -1
                self = .backward(degree: positiveDegree)
            default:
                self = .flat
            }
        }
    }
}
