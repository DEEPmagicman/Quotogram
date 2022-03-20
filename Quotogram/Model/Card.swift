//
//  Card.swift
//  Quotogram
//
//  Created by MAC on 19/03/22.
//

import SwiftUI

struct Card: Identifiable {
    
    var id = UUID().uuidString
    var cardColor: Color
    var date: String = ""
    var title: String
}
