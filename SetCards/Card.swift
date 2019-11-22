//
//  Card.swift
//  SetCards
//
//  Created by AHMED GAMAL  on 4/14/19.
//  Copyright © 2019 AHMED GAMAL . All rights reserved.
//

import Foundation
struct Card     :  Equatable{
    let number  : Int
    let symbol  : Int
    let shading : Int
    let color   : Int
    
    static func == (lhs: Card , rhs : Card) -> Bool{
        return lhs.color   == rhs.color
            && lhs.symbol  == rhs.symbol
            && lhs.shading == rhs.shading
            && lhs.color   == rhs.color
    }
}

extension Card : Hashable{
    var hashValue : Int {
        let digits = [color, symbol, number, shading]

        return Int (digits.map(String.init).joined())! //convert array to string, join string member, convert string to integer

          }
    }












