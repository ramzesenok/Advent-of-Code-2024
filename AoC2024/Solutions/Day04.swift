//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

import Foundation

enum Day04: Day {
    static let input = ""

    static func part1() -> Int {
        let leftToRight = Self.findCount(in: input)
        let rightToLeft = Self.findCount(in: String(input.reversed()))

        let transposed = Self.transpose(input)

        let upToDown = Self.findCount(in: transposed)
        let downToUp = Self.findCount(in: String(transposed.reversed()))

        let rotatedRight = Self.rotateRight(input)

        let leftBottomToRightTop = self.findCount(in: rotatedRight)
        let rightTopToLeftBottom = self.findCount(in: String(rotatedRight.reversed()))

        let rotatedLeft = Self.rotateLeft(input)

        let leftTopToRightBottom = self.findCount(in: rotatedLeft)
        let rightBottomToLeftTop = self.findCount(in: String(rotatedLeft.reversed()))

        return [
            leftToRight,
            rightToLeft,
            upToDown,
            downToUp,
            leftBottomToRightTop,
            rightTopToLeftBottom,
            leftTopToRightBottom,
            rightBottomToLeftTop
        ].reduce(0, +)
    }

    static func part2() -> Int {
        var result = 0

        let lines = input.split(separator: "\n")

        for line in 1..<lines.count - 1 {
            for column in 1..<lines[line].count - 1 where lines[line][column] == "A" {
                let topLeft = lines[line - 1][column - 1]
                let topRight = lines[line - 1][column + 1]
                let bottomLeft = lines[line + 1][column - 1]
                let bottomRight = lines[line + 1][column + 1]

                let leftToRightMatches = topLeft == "M" && bottomRight == "S" || topLeft == "S" && bottomRight == "M"
                let rightToLeftMatches = topRight == "M" && bottomLeft == "S" || topRight == "S" && bottomLeft == "M"

                if leftToRightMatches && rightToLeftMatches {
                    result += 1
                }
            }
        }

        return result
    }

    private static func findCount(in input: String) -> Int {
        try! NSRegularExpression(pattern: "XMAS")
            .matches(in: input, range: NSRange(location: 0, length: input.count)).count
    }

    private static func transpose(_ input: String) -> String {
        var result = ""

        let lines = input.split(separator: "\n")

        for i in 0..<lines.count {
            for line in lines {
                if i < line.count {
                    result.append(line[i])
                }
            }

            result.append("\n")
        }

        return result
    }

    private static func rotateRight(_ input: String) -> String {
        var result = ""

        let lines = input.split(separator: "\n")

        for i in 0..<lines.count + lines[0].count - 1 {
            for charIdx in 0...i {
                let lineIdx = i - charIdx

                if lineIdx < lines.count, charIdx < lines[lineIdx].count {
                    result.append(lines[lineIdx][charIdx])
                }
            }

            result.append("\n")
        }

        return result
    }

    private static func rotateLeft(_ input: String) -> String {
        var result = ""

        let lines = input.split(separator: "\n")

        for i in 0..<lines.count + lines[0].count - 1 {
            let maxLineIdx = lines.count - 1
            let lineIdx = min(i, maxLineIdx)
            let maxLineIdxThisRun = min(i, maxLineIdx)
            let maxCharIdxOffsetThisRun = i - maxLineIdxThisRun

            for j in 0...maxLineIdxThisRun {
                let currentLineIdx = lineIdx - j
                let currentLine = lines[currentLineIdx]
                let charIdx = currentLine.count - 1 - j - maxCharIdxOffsetThisRun

                if charIdx >= 0, currentLineIdx < lines.count, charIdx < currentLine.count {
                    result.append(lines[currentLineIdx][charIdx])
                }
            }

            result.append("\n")
        }

        return result
    }
}

extension String.SubSequence {
    subscript(_ idx: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: idx)]
    }
}
