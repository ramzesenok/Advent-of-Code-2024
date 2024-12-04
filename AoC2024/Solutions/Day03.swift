//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

import Foundation

enum Day03: Day {
    static let input = ""

    static func part1() -> Int {
        Self.compute(regex: #"mul\(\d*\,\d*\)"#, in: input)
    }

    static func part2() -> Int {
        var result = 0

        let dontSplit = input.split(separator: "don't()")

        result += Self.compute(regex: #"mul\(\d*\,\d*\)"#, in: String(dontSplit[0]))

        for split in dontSplit.dropFirst() {
            let computable = split.split(separator: "do()").dropFirst().joined()

            result += Self.compute(regex: #"mul\(\d*\,\d*\)"#, in: computable)
        }

        return result
    }

    private static func compute(regex: String, in input: String) -> Int {
        try! NSRegularExpression(pattern: regex)
            .matches(in: input, range: NSRange(location: 0, length: input.count))
            .map {
                String(input[Range($0.range, in: input)!])
                    .replacingOccurrences(of: "mul(", with: "")
                    .replacingOccurrences(of: ")", with: "")
                    .split(separator: ",")
                    .compactMap { Int($0) }
            }
            .reduce(into: 0, { $0 += $1[0] * $1[1] })
    }
}
