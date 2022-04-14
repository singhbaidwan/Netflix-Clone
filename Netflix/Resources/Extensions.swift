//
//  Extensions.swift
//  Netflix
//
//  Created by Dalveer singh on 15/04/22.
//

import Foundation
extension String {
    func capitailizeFirstLetter()->String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
