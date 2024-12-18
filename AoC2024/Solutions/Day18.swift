//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

import Foundation

enum Day18: Day {
    static let input = ""

    struct Coordinate: Hashable {
        let x: Int
        let y: Int
    }

    enum Direction: CaseIterable {
        case up, right, down, left
    }

    static let width: Int = 71
    static let height: Int = 71

    static func part1() -> Int {
        let split = input.split(separator: "\n")
        var grid: [[Character]] = Array(repeating: Array(repeating: ".", count: width), count: height)

        for i in 0..<1024 {
            let (x, y) = getXY(from: split[i])

            grid[x][y] = "#"
        }

        return findPathCosts(for: grid)[width - 1][height - 1]
    }

    static func part2() -> Int {
        let split = input.split(separator: "\n")

        var grid: [[Character]] = Array(repeating: Array(repeating: ".", count: width), count: height)

        for i in 0..<1024 {
            let (x, y) = getXY(from: split[i])

            grid[x][y] = "#"
        }

        var i = 1024

        while findPathCosts(for: grid)[width - 1][height - 1] != Int.max {
            i += 1

            let (x, y) = getXY(from: split[i])

            grid[x][y] = "#"
        }

        print(split[i])

        return 0
    }

    private static func getXY(from split: any StringProtocol) -> (Int, Int) {
        let line = split.split(separator: ",")
        let x = Int(line[1])!
        let y = Int(line[0])!

        return (x, y)
    }

    private static func findPathCosts(for map: [[Character]]) -> [[Int]] {
        var tilesToCheck = Set<Coordinate>()

        var valuesGrid = Array(repeating: Array(repeating: Int.max, count: width), count: height)
        valuesGrid[0][0] = 0

        tilesToCheck.insert(Coordinate(x: 0, y: 0))

        while let tileToCheck = tilesToCheck.popFirst() {
            for direction in Direction.allCases {
                let coordinate = switch direction {
                case .up:
                    Coordinate(x: tileToCheck.x - 1, y: tileToCheck.y)
                case .right:
                    Coordinate(x: tileToCheck.x, y: tileToCheck.y + 1)
                case .down:
                    Coordinate(x: tileToCheck.x + 1, y: tileToCheck.y)
                case .left:
                    Coordinate(x: tileToCheck.x, y: tileToCheck.y - 1)
                }

                if 0..<width ~= coordinate.x && 0..<height ~= coordinate.y {
                    let currentValue = valuesGrid[tileToCheck.x][tileToCheck.y]
                    let newValue = currentValue + 1

                    if map[coordinate.x][coordinate.y] != "#" && valuesGrid[coordinate.x][coordinate.y] > newValue {
                        valuesGrid[coordinate.x][coordinate.y] = newValue

                        tilesToCheck.insert(coordinate)
                    }
                }
            }
        }

        return valuesGrid
    }
}
