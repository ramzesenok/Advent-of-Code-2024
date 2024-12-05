//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

import Foundation

enum Day05: Day {
    static let input = ""

    struct Rule {
        let lhs, rhs: Int
    }

    static func part1() -> Int {
        let (updates, rules) = Self.getUpdatesAndRules()

        return updates
            .filter { Self.isInCorrectOrder(update: $0, rules: rules) }
            .map(Self.getMiddleNumber)
            .reduce(0, +)
    }

    static func part2() -> Int {
        let (updates, rules) = Self.getUpdatesAndRules()

        return updates
            .filter { !Self.isInCorrectOrder(update: $0, rules: rules) }
            .map { Self.fixUpdate($0, rules: rules) }
            .map(Self.getMiddleNumber)
            .reduce(0, +)
    }

    private static func getUpdatesAndRules() -> (updates: [[Int]], rules: [Rule]) {
        let split = input.split(separator: "\n\n")

        let rules = split[0].split(separator: "\n").map { line in
            let ruleSplit = line.split(separator: "|").compactMap { Int($0) }

            return Rule(lhs: ruleSplit[0], rhs: ruleSplit[1])
        }

        let updates = split[1].split(separator: "\n")
            .map { line in
                line.split(separator: ",").compactMap { Int($0) }
            }

        return (updates, rules)
    }

    private static func isInCorrectOrder(update: [Int], rules: [Rule]) -> Bool {
        for i in 0..<update.count - 1 {
            let lhs = update[i]
            let rhs = update[i + 1]
            
            if !rules.contains(where: { $0.lhs == lhs && $0.rhs == rhs }) {
                return false
            }
        }

        return true
    }

    private static func fixUpdate(_ update: [Int], rules: [Rule]) -> [Int] {
        var result = [update[0]]
        var restUpdate = update.dropFirst()

        loop: while let value = restUpdate.popFirst() {
            for i in 0..<result.count {
                let establishedValue = result[i]

                if rules.contains(where: { $0.lhs == establishedValue && $0.rhs == value }) {
                    continue
                } else if rules.contains(where: { $0.lhs == value && $0.rhs == establishedValue }) {
                    result.insert(value, at: i)
                    continue loop
                }
            }

            result.append(value)
        }

        return result
    }

    private static func getMiddleNumber(_ numbers: [Int]) -> Int {
        numbers.count.isMultiple(of: 2) ? numbers[numbers.count / 2 - 1] : numbers[numbers.count / 2]
    }
}
