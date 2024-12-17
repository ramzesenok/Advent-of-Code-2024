//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

import Foundation

enum Day17: Day {
    static let input = ""

    class Program {
        private var registerA: Int
        private var registerB: Int
        private var registerC: Int

        let instructions: [Int]

        private var pointer = 0

        private var output = [Int]()

        init(input: String) {
            let split = input.split(separator: "\n\n")
            let registers = split[0]
                .split(separator: "\n")
                .map { $0.dropFirst(12) }
                .map { Int($0)! }
            let instructions = split[1]
                .dropFirst(9)
                .split(separator: ",")
                .map { Int($0)! }

            self.registerA = registers[0]
            self.registerB = registers[1]
            self.registerC = registers[2]
            self.instructions = instructions
        }

        init(registerA: Int = 0, registerB: Int = 0, registerC: Int = 0, instructions: [Int]) {
            self.registerA = registerA
            self.registerB = registerB
            self.registerC = registerC
            self.instructions = instructions
        }

        func run() -> [Int] {
            while pointer < instructions.count - 1 {
                run(instruction: instructions[pointer], operand: instructions[pointer + 1])
            }

            return output
        }

        private func run(instruction: Int, operand: Int) {
            switch instruction {
            case 0:
                let result = Double(registerA) / pow(2.0, Double(comboValue(for: operand)))
                registerA = Int(result)
            case 1:
                let result = registerB ^ operand
                registerB = result
            case 2:
                let result = comboValue(for: operand) % 8
                registerB = result
            case 3:
                if registerA != 0 {
                    pointer = operand
                    return // To not get to `pointer += 2`
                }
            case 4:
                let result = registerB ^ registerC
                registerB = result
            case 5:
                output.append(comboValue(for: operand) % 8)
            case 6:
                let result = Double(registerA) / pow(2.0, Double(comboValue(for: operand)))
                registerB = Int(result)
            case 7:
                let result = Double(registerA) / pow(2.0, Double(comboValue(for: operand)))
                registerC = Int(result)
            default:
                fatalError("Unknown instruction \(instruction)")
            }

            pointer += 2
        }

        func comboValue(for operand: Int) -> Int {
            switch operand {
            case 0, 1, 2, 3: return operand
            case 4: return registerA
            case 5: return registerB
            case 6: return registerC
            default: fatalError("Unknown operand \(operand)")
            }
        }
    }

    static func part1() -> Int {
        let program = Program(input: input)

        return Int(program.run().map(String.init).joined(separator: ""))!
    }

    static func part2() -> Int {
        let instructions = Program(input: input).instructions

        var i = 0

        while true {
            let program = Program(registerA: i, instructions: instructions)
            let output = program.run()

            if output == instructions {
                break
            } else {
                i += 1
            }
        }

        return i
    }
}
