//
//  Card.swift
//  Quotogram
//
//  Created by MAC on 19/03/22.
//

import SwiftUI

struct Card: Identifiable {
    
    var id = UUID().uuidString
    var cardColor: Color = Color.randomColor()
    var date: String = ""
    var title: String
}

extension Color {
    static func randomColor() -> Color {
        switch Int.random(in: 0...3) {
        case 0:
            return Color(red: 0.26, green: 133/255, blue: 244/255)
        case 1:
            return Color(red: 219/255, green: 68/255, blue: 55/255)
        case 2:
            return Color(red: 244/255, green: 180/255, blue: 0)
        case 3:
            return Color(red: 15.255, green: 157/255, blue: 88/255)
        default:
            return .black
        }
    }
}
