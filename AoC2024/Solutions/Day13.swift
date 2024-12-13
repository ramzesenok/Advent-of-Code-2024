//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

enum Day13: Day {
    struct Game {
        struct Coordinate {
            var x: Int
            var y: Int
        }

        struct Advance {
            var x: Int
            let y: Int
        }

        let a: Advance
        let b: Advance
        let prize: Coordinate
    }

    struct Equation {
        let xCoefficient: Double
        let yCoefficient: Double
        let result: Double
    }

    static let input = ""

    static func part1() -> Int {
        let games = parseInput(input, adjustCoordinates: false)

        return solve(games: games)
    }

    static func part2() -> Int {
        let games = parseInput(input, adjustCoordinates: true)

        return solve(games: games)
    }

    private static func solve(games: [Game]) -> Int {
        var result = 0

        for game in games {
            let equation1 = Equation(xCoefficient: Double(game.a.x), yCoefficient: Double(game.b.x), result: Double(game.prize.x))
            let equation2 = Equation(xCoefficient: Double(game.a.y), yCoefficient: Double(game.b.y), result: Double(game.prize.y))

            let a = equation1.xCoefficient * equation2.result
            let b = equation1.xCoefficient * equation2.yCoefficient
            let c = equation1.yCoefficient * equation2.xCoefficient
            let d = equation1.result * equation2.xCoefficient

            let e = d - a
            let f = b - c

            let y = (e * -1) / f
            let x = (equation1.result - equation1.yCoefficient * y) / equation1.xCoefficient

            if y == Double(Int(y)) && x == Double(Int(x)) {
                result += Int(x) * 3 + Int(y)
            }
        }

        return result
    }

    private static func parseInput(_ input: String, adjustCoordinates: Bool) -> [Game] {
        input.split(separator: "\n\n").map { gameLines in
            let lines = gameLines.split(separator: "\n")

            return Game(
                a: parseButtonAdvance(String(lines[0])),
                b: parseButtonAdvance(String(lines[1])),
                prize: parsePrizeCoordinate(String(lines[2]), adjustCoordinates: adjustCoordinates)
            )
        }
    }

    private static func parseButtonAdvance(_ line: String) -> Game.Advance {
        let tokens = line.dropFirst(10).split(separator: ", ")

        return Game.Advance(
            x: Int(tokens[0].dropFirst(2))!,
            y: Int(tokens[1].dropFirst(2))!
        )
    }

    private static func parsePrizeCoordinate(_ line: String, adjustCoordinates: Bool) -> Game.Coordinate {
        let tokens = line.dropFirst(7).split(separator: ", ")

        return Game.Coordinate(
            x: Int(tokens[0].dropFirst(2))! + (adjustCoordinates ? 10000000000000 : 0),
            y: Int(tokens[1].dropFirst(2))! + (adjustCoordinates ? 10000000000000 : 0)
        )
    }
}
