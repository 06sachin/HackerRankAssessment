//
//  UIView+Extensions.swift
//  HackerRankMachineRound
//
//  Created by SACHIN on 28/10/24.
//

import Foundation
import UIKit
extension UIView {
    
    func rotate(degrees: CGFloat) {

        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))
    }
}
