//
//  ButtonViewModel.swift
//  CurrencyConverter
//
//  Created by Olya Ganeva on 04.07.2022.
//

import UIKit

struct ButtonViewModel {
    
    enum Style {
        case dark
        case light(fontSize: CGFloat)
        case orange(fontSize: CGFloat)
    }
    
    let title: String
    let style: Style
    
    var font: String {
        switch style {
        case .dark:
            return "SFPro-Regular"
        case .light:
            if title == "􀘾" {
                return "SFPro-Semibold"
            }
            return "SFPro-Medium"
        case .orange:
            return "SFPro-Medium"
        }
    }
    
    var fontSize: CGFloat {
        switch style {
        case .dark:
            return 40
        case .light(let fontSize):
            return fontSize
        case .orange(let fontSize):
            return fontSize
        }
    }
    
    var titleColor: UIColor {
        switch style {
        case .dark:
            return .white
        case .light:
            return .black
        case .orange:
            return .white
        }
    }
    
    var normalColor: UIColor {
        switch style {
        case .dark:
            return .darkGray
        case .light:
            return .lightGray
        case .orange:
            return UIColor(red: 255.0 / 255.0, green: 149 / 255.0, blue: 0 / 255.0, alpha: 1)
        }
    }
    
    var highlightedColor: UIColor {
        switch style {
        case .dark:
            return .lightGray
        case .light:
            return .white
        case .orange:
            return UIColor(red: 241.0 / 255.0, green: 163 / 255.0, blue: 59 / 255.0, alpha: 1)
        }
    }
}
