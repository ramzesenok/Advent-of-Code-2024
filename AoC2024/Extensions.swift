//
//  Extensions.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 06.12.24.
//

extension StringProtocol {
    subscript(_ idx: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: idx)]
    }
}
