//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

enum Day08: Day {
    static let input = ""

    struct Coordinate: Hashable {
        let line: Int
        let column: Int

        init(line: Int, column: Int) {
            self.line = line
            self.column = column
        }

        init(from inputIndex: Int, columnsCount: Int) {
            self.line = inputIndex / columnsCount
            self.column = inputIndex % columnsCount
        }

        func asInputIndex(columnsCount: Int) -> Int {
            line * columnsCount + column
        }

        func isInBounds(linesCount: Int, columnsCount: Int) -> Bool {
            0..<linesCount ~= line && 0..<columnsCount ~= column
        }
    }

    static let lines = input.split(separator: "\n")
    static let linesCount = lines.count
    static let columnsCount = lines[0].count + 1

    static func part1() -> Int {
        var antennasMap = [Character: [Coordinate]]()

        for idx in 0..<input.count where ![".", "\n"].contains(input[idx]) {
            let coordinate = Coordinate(from: idx, columnsCount: columnsCount)

            antennasMap[input[idx], default: []].append(coordinate)
        }

        var antinodes = Set<Coordinate>()

        for case let coordinates in antennasMap.values {
            let pairs = combinations(coordinates, choose: 2)

            for pair in pairs {
                let dX = pair[0].column - pair[1].column
                let dY = pair[0].line - pair[1].line

                antinodes.formUnion([
                    Coordinate(line: pair[0].line + dY, column: pair[0].column + dX),
                    Coordinate(line: pair[1].line - dY, column: pair[1].column - dX)
                ])
            }
        }

        return antinodes.filter({ $0.isInBounds(linesCount: linesCount, columnsCount: columnsCount - 1) }).count
    }

    static func part2() -> Int {
        var antennasMap = [Character: [Coordinate]]()

        for idx in 0..<input.count where ![".", "\n"].contains(input[idx]) {
            let coordinate = Coordinate(from: idx, columnsCount: columnsCount)

            antennasMap[input[idx], default: []].append(coordinate)
        }

        var antinodes = Set(antennasMap.values.flatMap({ $0 }))

        for case let coordinates in antennasMap.values {
            let pairs = combinations(coordinates, choose: 2)

            for pair in pairs {
                let dX = pair[0].column - pair[1].column
                let dY = pair[0].line - pair[1].line

                var newCoordinateDirection1 = Coordinate(line: pair[0].line + dY, column: pair[0].column + dX)

                while newCoordinateDirection1.isInBounds(linesCount: linesCount, columnsCount: columnsCount - 1) {
                    antinodes.insert(newCoordinateDirection1)

                    newCoordinateDirection1 = Coordinate(
                        line: newCoordinateDirection1.line + dY,
                        column: newCoordinateDirection1.column + dX
                    )
                }

                var newCoordinateDirection2 = Coordinate(line: pair[1].line - dY, column: pair[1].column - dX)

                while newCoordinateDirection2.isInBounds(linesCount: linesCount, columnsCount: columnsCount - 1) {
                    antinodes.insert(newCoordinateDirection2)

                    newCoordinateDirection2 = Coordinate(
                        line: newCoordinateDirection2.line - dY,
                        column: newCoordinateDirection2.column - dX
                    )
                }
            }
        }

        return antinodes.count
    }

    static func combinations<T>(_ list: [T], choose k: Int) -> [[T]] {
        guard k > 0 && k <= list.count else { return [] }

        if k == 1 {
            return list.map { [$0] }
        }

        var result: [[T]] = []

        for (index, element) in list.enumerated() {
            let remaining = Array(list[(index + 1)...])
            let subcombinations = combinations(remaining, choose: k - 1)
            result += subcombinations.map { [element] + $0 }
        }

        return result
    }
}
