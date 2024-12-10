//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

enum Day10: Day {
    static let input = ""

    enum Turn: CaseIterable {
        case up, right, down, left

        func nextCoordinate(for coordinate: Coordinate) -> Coordinate {
            switch self {
            case .up:
                Coordinate(line: coordinate.line - 1, column: coordinate.column)
            case .right:
                Coordinate(line: coordinate.line, column: coordinate.column + 1)
            case .down:
                Coordinate(line: coordinate.line + 1, column: coordinate.column)
            case .left:
                Coordinate(line: coordinate.line, column: coordinate.column - 1)
            }
        }
    }

    struct Coordinate: Hashable {
        let line: Int
        let column: Int

        func isOutOfBounds(lines: Int, columns: Int) -> Bool {
            line < 0 || line >= lines || column < 0 || column >= columns
        }
    }

    static let lines = input.split(separator: "\n")
    static let linesCount = lines.count
    static let columnsCount = lines[0].count + 1

    static func part1() -> Int {
        (0..<input.count)
            .filter { input[$0] == "0" }
            .reduce(0) { partialResult, idx in
                partialResult + Set(checkNext(currentCoordinate: coordinate(for: idx))).count
            }
    }

    static func part2() -> Int {
        (0..<input.count)
            .filter { input[$0] == "0" }
            .reduce(0) { partialResult, idx in
                partialResult + checkNext(currentCoordinate: coordinate(for: idx)).count
            }
    }

    static func checkNext(currentCoordinate: Coordinate) -> [Coordinate] {
        var trailCoordinates = [Coordinate]()

        for turn in Turn.allCases {
            let nextCoordinate = turn.nextCoordinate(for: currentCoordinate)

            guard !nextCoordinate.isOutOfBounds(lines: linesCount, columns: columnsCount),
                  index(for: nextCoordinate) < input.count,
                  let currentNum = Int(String(input[index(for: currentCoordinate)])),
                  let nextNum = Int(String(input[index(for: nextCoordinate)])),
                  currentNum == nextNum - 1
            else { continue }

            if input[index(for: nextCoordinate)] == "9" {
                trailCoordinates.append(nextCoordinate)
            } else {
                trailCoordinates.append(contentsOf: checkNext(currentCoordinate: nextCoordinate))
            }
        }

        return trailCoordinates
    }

    static func coordinate(for idx: Int) -> Coordinate {
        Coordinate(line: idx / columnsCount, column: idx % columnsCount)
    }

    static func index(for coordinate: Coordinate) -> Int {
        coordinate.line * columnsCount + coordinate.column
    }
}
