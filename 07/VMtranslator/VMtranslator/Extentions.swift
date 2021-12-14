//
//  Extentions.swift
//  VMtranslator
//
//  Created by 山崎宏哉 on 2021/12/14.
//  Copyright © 2021 山崎宏哉. All rights reserved.
//

import Foundation
 
extension String {
    func correspondingSymbol(_ index: Int = 0) -> String {
        switch self {
        case "local":
            return "LCL"
        case "argument":
            return "ARG"
        case "this":
            return "THIS"
        case "that":
            return "THAT"
        case "temp":
            let tempBaseAddress = index + 5
            return "R\(tempBaseAddress)"
        default:
            return self
        }
    }
}
