//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

import Foundation

enum Day11: Day {
    static let input = ""

    static func part1() -> Int {
        blink(times: 7)
    }

    static func part2() -> Int {
        blink(times: 75)
    }

    static func blink(times count: Int) -> Int {
        input.split(separator: " ")
            .compactMap { Int($0) }
            .map { blink(for: $0, count: count) }
            .reduce(0, +)
    }

    struct Key: Hashable {
        let stone: Int
        let count: Int
    }

    static var cache = [Key: Int]()

    static func blink(for stone: Int, count: Int) -> Int {
        if count == 0 {
            return 1
        }

        let key = Key(stone: stone, count: count)

        if let result = cache[key] {
            return result
        }

        let result: Int = {
            let charCount = "\(stone)".count

            if stone == 0 {
                return blink(for: 1, count: count - 1)
            } else if charCount.isMultiple(of: 2) {
                let p = pow(10, charCount / 2)

                return blink(for: stone / p, count: count - 1) + blink(for: stone % p, count: count - 1)
            } else {
                return blink(for: 2024 * stone, count: count - 1)
            }
        }()

        cache[key] = result

        return result
    }

    static func pow(_ x: Int, _ y: Int) -> Int {
        Int(Foundation.pow(Double(x), Double(y)))
    }
}
