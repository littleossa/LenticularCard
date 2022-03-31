//
//  Double+convertedRadiansToDegrees.swift
//  LenticularCard
//
//  Created by 平岡修 on 2022/03/31.
//

import Foundation

extension Double {
    
    func convertedRadianToDegree() -> Double {
        return self * 180 / Double.pi
    }
}
