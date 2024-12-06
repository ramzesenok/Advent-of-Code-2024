//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

import Foundation

enum Day06: Day {
    static let input = ""

    struct Coordinate: Hashable {
        let line: Int
        let column: Int

        func isOutOfBounds(lines: Int, columns: Int) -> Bool {
            line < 0 || line >= lines || column < 0 || column >= columns
        }
    }

    struct VisitedTile {
        let accessedAtStep: Int
        let accessedFromDirection: Direction
    }

    enum Direction: CaseIterable {
        case top, right, bottom, left

        var turnedRight: Direction {
            switch self {
            case .top: return .right
            case .right: return .bottom
            case .bottom: return .left
            case .left: return .top
            }
        }

        var opposite: Direction {
            switch self {
            case .top: return .bottom
            case .right: return .left
            case .bottom: return .top
            case .left: return .right
            }
        }

        init?(from character: Character) {
            switch character {
            case "^": self = .top
            case ">": self = .right
            case "v": self = .bottom
            case "<": self = .left
            default: return nil
            }
        }
    }

    static let lines = input.split(separator: "\n")
    static let linesCount = lines.count
    static let columnsCount = lines[0].count + 1
    static let initialIdx = input.firstIndex(where: "^><v".contains)!.utf16Offset(in: input)
    static let initialDirection = Direction(from: input[initialIdx])!
    static let initialCoordinate = Coordinate(line: initialIdx / columnsCount, column: initialIdx % columnsCount)

    static func part1() -> Int {
        getVisitedTiles().count
    }

    static func part2() -> Int {
        getVisitedTiles()
            .filter({ $0 != initialCoordinate })
            .filter(containsLoop)
            .count
    }

    static func getVisitedTiles() -> Set<Coordinate> {
        var visitedTiles = Set<Coordinate>()

        var currentCoordinate = initialCoordinate
        var currentDirection = initialDirection

        while true {
            visitedTiles.insert(currentCoordinate)

            let newCoordinate = switch currentDirection {
            case .top:
                Coordinate(line: currentCoordinate.line - 1, column: currentCoordinate.column)
            case .right:
                Coordinate(line: currentCoordinate.line, column: currentCoordinate.column + 1)
            case .bottom:
                Coordinate(line: currentCoordinate.line + 1, column: currentCoordinate.column)
            case .left:
                Coordinate(line: currentCoordinate.line, column: currentCoordinate.column - 1)
            }

            if newCoordinate.isOutOfBounds(lines: linesCount, columns: columnsCount) { break }

            if input[newCoordinate.line * columnsCount + newCoordinate.column] == "#" {
                currentDirection = currentDirection.turnedRight
            } else {
                currentCoordinate = newCoordinate
            }
        }

        return visitedTiles
    }

    static func containsLoop(withObstructionAt coordinate: Coordinate) -> Bool {
        var visitedTiles = [Coordinate: [VisitedTile]]()

        var currentCoordinate = initialCoordinate
        var currentDirection = initialDirection
        var currentStep = 0

        while true {
            if visitedTiles[currentCoordinate, default: []].contains(where: { $0.accessedFromDirection == currentDirection.opposite }) {
                return true
            }

            if !visitedTiles[currentCoordinate, default: []].contains(where: { $0.accessedAtStep == currentStep }) {
                visitedTiles[currentCoordinate, default: []].append(
                    VisitedTile(
                        accessedAtStep: currentStep,
                        accessedFromDirection: currentDirection.opposite
                    )
                )
            }

            let newCoordinate = switch currentDirection {
            case .top:
                Coordinate(line: currentCoordinate.line - 1, column: currentCoordinate.column)
            case .right:
                Coordinate(line: currentCoordinate.line, column: currentCoordinate.column + 1)
            case .bottom:
                Coordinate(line: currentCoordinate.line + 1, column: currentCoordinate.column)
            case .left:
                Coordinate(line: currentCoordinate.line, column: currentCoordinate.column - 1)
            }

            if newCoordinate.isOutOfBounds(lines: linesCount, columns: columnsCount) { break }

            if input[newCoordinate.line * columnsCount + newCoordinate.column] == "#" || newCoordinate == coordinate {
                currentDirection = currentDirection.turnedRight
            } else {
                currentCoordinate = newCoordinate
                currentStep += 1
            }
        }

        return false
    }
}
