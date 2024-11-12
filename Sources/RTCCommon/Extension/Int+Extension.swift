//
//  Int+Extension.swift
//  TUILiveKit
//
//  Created by krabyu on 2024/3/11.
//
import Foundation

public extension Int {
    func scale375(exceptPad: Bool = true) -> CGFloat {
        return CGFloat(self).scale375Width()
    }
}
