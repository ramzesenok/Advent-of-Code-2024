//
//  Executor.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

import Foundation

enum Executor {
    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    static func execute<T: Day>(_ day: T.Type) {
        print(String(describing: day))
        execute(partIdx: 1, part: day.part1)
        execute(partIdx: 2, part: day.part2)
    }

    private static func execute(partIdx: Int, part: () -> Int) {
        let date = Date.now
        let result = part()
        let elapsed = date.timeIntervalSinceNow * 1000
        let elapsedNumber = NSNumber(floatLiteral: abs(elapsed))

        print("Part \(partIdx): Result – \(result);", "Time – \(Self.numberFormatter.string(from: elapsedNumber)!)ms")
    }
}
