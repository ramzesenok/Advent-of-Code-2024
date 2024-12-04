//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

enum Day02: Day {
    static let input = ""

    static func part1() -> Int {
        input
            .split(separator: "\n")
            .map { line in
                isSafe(
                    report: line
                        .split(separator: " ")
                        .compactMap { Int($0) }
                )
            }
            .count(where: { $0 })
    }

    static func part2() -> Int {
        input
            .split(separator: "\n")
            .map { line in
                let report = line
                    .split(separator: " ")
                    .compactMap { Int($0) }

                return isSafe(report: report) || isDampenedSafe(report: report)
            }
            .count(where: { $0 })
    }

    private static func isSafe(report: [Int]) -> Bool {
        var sign = 0

        for i in 0..<report.count - 1 {
            if 1...3 ~= abs(report[i] - report[i+1]) {
                let currentSign = report[i] - report[i+1] > 0 ? 1 : -1

                if sign == 0 {
                    sign = currentSign
                } else if sign != currentSign {
                    return false
                }
            } else {
                return false
            }
        }

        return true
    }

    private static func isDampenedSafe(report: [Int]) -> Bool {
        for i in 0..<report.count {
            var newReport = report
            newReport.remove(at: i)

            if isSafe(report: newReport) {
                return true
            }
        }

        return false
    }
}
