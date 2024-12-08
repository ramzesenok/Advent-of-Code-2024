//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

enum Day07: Day {
    static let input = ""

    typealias Operator = (Int, Int) -> Int

    static func part1() -> Int {
        calculate(with: [(*), (+)])
    }

    static func part2() -> Int {
        calculate(with: [(*), (+), { Int(String($0) + String($1))! }])
    }

    static func createPermutations(from elements: [Operator], count: Int) -> [[Operator]] {
        switch count {
        case 0:
            [[]]
        case 1:
            elements.map { [$0] }
        default:
            elements.flatMap { element in
                createPermutations(from: elements, count: count - 1).map { [element] + $0 }
            }
        }
    }

    private static func calculate(with operators: [Operator]) -> Int {
        input.split(separator: "\n").map { equation in
            let testValue = Int(equation.split(separator: ": ")[0])!
            let coefficients = equation.split(separator: ": ")[1].split(separator: " ").map { Int($0)! }

            let operatorsPermutations = createPermutations(
                from: operators,
                count: coefficients.count - 1
            )

            operatorsLoop: for operators in operatorsPermutations {
                var localResult = coefficients[0]

                for i in 1..<coefficients.count {
                    localResult = operators[i - 1](localResult, coefficients[i])

                    if localResult > testValue {
                        continue operatorsLoop
                    }
                }

                if localResult == testValue {
                    return testValue
                }
            }

            return 0
        }
        .reduce(0, +)
    }
}
