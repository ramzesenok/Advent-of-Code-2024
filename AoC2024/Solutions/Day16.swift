//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

enum Day16: Day {
    static let input = ""

    struct PathTile: Hashable {
        let coordinate: Coordinate
        let accessedFrom: Direction
    }

    struct Coordinate: Hashable {
        let x: Int
        let y: Int
    }

    enum Direction: CaseIterable {
        case east, south, west, north

        var opposite: Direction {
            switch self {
            case .east: return .west
            case .north: return .south
            case .west: return .east
            case .south: return .north
            }
        }
    }

    static func part1() -> Int {
        let grid: [[Character]] = input.split(separator: "\n").map { Array($0) }

        let startX = grid.firstIndex { $0.contains("S") }!
        let startCoordinate = Coordinate(x: startX, y: grid[startX].firstIndex(of: "S")!)

        let endX = grid.firstIndex { $0.contains("E") }!
        let endCoordinate = Coordinate(x: endX, y: grid[endX].firstIndex(of: "E")!)

        var costsGrid = Array(repeating: Array(repeating: Int.max, count: grid[0].count), count: grid.count)

        costsGrid[startCoordinate.x][startCoordinate.y] = 0

        var tilesToCheck = Set([PathTile(coordinate: startCoordinate, accessedFrom: .east)])

        while let tileToCheck = tilesToCheck.popFirst() {
            let currentCost = costsGrid[tileToCheck.coordinate.x][tileToCheck.coordinate.y]

            for direction in Direction.allCases.filter({ $0.opposite != tileToCheck.accessedFrom }) {
                let coordinate = switch direction {
                case .east: Coordinate(x: tileToCheck.coordinate.x, y: tileToCheck.coordinate.y + 1)
                case .south: Coordinate(x: tileToCheck.coordinate.x + 1, y: tileToCheck.coordinate.y)
                case .west: Coordinate(x: tileToCheck.coordinate.x, y: tileToCheck.coordinate.y - 1)
                case .north: Coordinate(x: tileToCheck.coordinate.x - 1, y: tileToCheck.coordinate.y)
                }

                let newCost = currentCost + 1 + (direction == tileToCheck.accessedFrom ? 0 : 1000)

                if 0..<grid.count ~= coordinate.x && 0..<grid[coordinate.x].count ~= coordinate.y {
                    if grid[coordinate.x][coordinate.y] != "#" && costsGrid[coordinate.x][coordinate.y] > newCost {
                        costsGrid[coordinate.x][coordinate.y] = newCost

                        tilesToCheck.insert(
                            PathTile(coordinate: coordinate, accessedFrom: direction)
                        )
                    }
                }
            }
        }

        return costsGrid[endCoordinate.x][endCoordinate.y]
    }

    static func part2() -> Int {
        0
    }
}
