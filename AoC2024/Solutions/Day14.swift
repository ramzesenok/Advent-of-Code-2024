//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

enum Day14: Day {
    static let input = ""

    struct Vector {
        let x: Int
        let y: Int
    }

    struct Robot {
        let position: Vector
        let velocity: Vector
    }

    private static let robots: [Robot] = input
        .split(separator: "\n")
        .map { line in
            let split = line.split(separator: " ")

            let p = split[0].dropFirst(2).split(separator: ",")
            let v = split[1].dropFirst(2).split(separator: ",")

            return Robot(
                position: Vector(x: Int(p[0])!, y: Int(p[1])!),
                velocity: Vector(x: Int(v[0])!, y: Int(v[1])!)
            )
        }

    private static let width = 101
    private static let height = 103

    static func part1() -> Int {
        let positions = reposition(robots, times: 100).map(\.position)

        var topLeftQuadrantSum = 0
        var topRightQuadrantSum = 0
        var bottomLeftQuadrantSum = 0
        var bottomRightQuadrantSum = 0

        for position in positions {
            let midX = width / 2
            let midY = height / 2

            if position.x < midX && position.y < midY {
                topLeftQuadrantSum += 1
            } else if position.x > midX && position.y < midY {
                topRightQuadrantSum += 1
            } else if position.x < midX && position.y > midY {
                bottomLeftQuadrantSum += 1
            } else if position.x > midX && position.y > midY {
                bottomRightQuadrantSum += 1
            }
        }

        return topLeftQuadrantSum * topRightQuadrantSum * bottomLeftQuadrantSum * bottomRightQuadrantSum
    }

    static func part2() -> Int {
        var robots = robots
        var i = 0

        outer: while true {
            let ys = Set(robots.map(\.position.y))

            for y in ys {
                let xs = Array(Set(robots.filter({ $0.position.y == y }).map(\.position.x))).sorted()

                guard xs.count >= 8 else { continue }

                for idx in 0..<xs.count - 7 {
                    if xs[idx] + 1 == xs[idx + 1] && xs[idx + 1] + 1 == xs[idx + 2] && xs[idx + 2] + 1 == xs[idx + 3] && xs[idx + 3] + 1 == xs[idx + 4] && xs[idx + 4] + 1 == xs[idx + 5] && xs[idx + 5] + 1 == xs[idx + 6] && xs[idx + 6] + 1 == xs[idx + 7] {
                        break outer
                    }
                }
            }

            i += 1
            robots = reposition(robots, times: 1)
        }

        return i
    }

    private static func reposition(_ robots: [Robot], times: Int) -> [Robot] {
        robots.map { robot in
            let endX = robot.position.x + times * robot.velocity.x
            let endY = robot.position.y + times * robot.velocity.y

            let modX = endX % width
            let modY = endY % height

            let normalizedX = modX < 0 ? width + modX : modX
            let normalizedY = modY < 0 ? height + modY : modY

            return Robot(position: Vector(x: normalizedX, y: normalizedY), velocity: robot.velocity)
        }
    }
}
