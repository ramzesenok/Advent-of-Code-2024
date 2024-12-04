//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

enum Day01: Day {
    static let input = ""

    static func part1() -> Int {
        let pairs = Self.input
            .split(separator: "\n")
            .map { lines in
                lines
                    .split(separator: "   ")
                    .compactMap { num in
                        Int(String(num))
                    }
            }

        let left = pairs.map({ $0[0] }).sorted()
        let right = pairs.map({ $0[1] }).sorted()

        return zip(left, right).reduce(0, { $0 + abs($1.0 - $1.1) })
    }

    static func part2() -> Int {
        let pairs = Self.input
            .split(separator: "\n")
            .map { lines in
                lines
                    .split(separator: "   ")
                    .compactMap { num in
                        Int(String(num))
                    }
            }

        let left = pairs.map({ $0[0] })
        let right = pairs.map({ $0[1] })

        return left.reduce(0, { partialResult, leftElement in
            partialResult + leftElement * right.count(where: { $0 == leftElement })
        })
    }
}
