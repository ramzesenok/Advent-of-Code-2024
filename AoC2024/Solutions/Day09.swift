//
//  Day01.swift
//  AoC2024
//
//  Created by Roman Mirzoyan on 01.12.24.
//

enum Day09: Day {
    static let input = ""

    struct Chunk {
        let value: String
        let count: Int
        let index: Int

        var isEmptySpace: Bool {
            value == "."
        }

        var asArray: [String] {
            Array(repeating: value, count: count)
        }
    }

    static func part1() -> Int {
        var discImage = [String]()
        var currentDataId = 0

        for idx in 0..<input.count {
            guard let count = Int(String(input[idx])) else { continue }

            if idx.isMultiple(of: 2) {
                discImage.append(contentsOf: Array(repeating: String(currentDataId), count: count))
                currentDataId += 1
            } else {
                discImage.append(contentsOf: Array(repeating: ".", count: count))
            }
        }

        var reverseNumIdx = 0

        var checksum = 0

        for i in 0..<discImage.count where i < discImage.count - reverseNumIdx - 1 {
            if let num = Int(discImage[i]) {
                checksum += i * num
            } else if discImage[i] == "." {
                for j in reverseNumIdx..<discImage.count {
                    if let num = Int(discImage[discImage.count - j - 1]) {
                        checksum += i * num
                        reverseNumIdx = j + 1
                        break
                    }
                }
            }
        }

        return checksum
    }

    static func part2() -> Int {
        var discImage = [Chunk]()
        var currentDataId = 0

        for idx in 0..<input.count {
            guard let count = Int(String(input[idx])), count > 0 else { continue }

            if idx.isMultiple(of: 2) {
                discImage.append(Chunk(value: String(currentDataId), count: count, index: discImage.count))
                currentDataId += 1
            } else {
                discImage.append(Chunk(value: ".", count: count, index: discImage.count))
            }
        }

        var chunksToMove = discImage.filter { !$0.isEmptySpace }

        while let chunkToMove = chunksToMove.popLast() {
            for i in 0..<discImage.count {
                let chunkToCheck = discImage[i]

                guard chunkToCheck.isEmptySpace && chunkToCheck.index < chunkToMove.index else { continue }

                if chunkToCheck.count > chunkToMove.count {
                    if let idx = discImage.firstIndex(where: { $0.index == chunkToMove.index }) {
                        discImage[idx] = Chunk(value: ".", count: chunkToMove.count, index: chunkToMove.index)
                    }

                    discImage.remove(at: i)

                    discImage.insert(
                        Chunk(value: ".", count: chunkToCheck.count - chunkToMove.count, index: chunkToCheck.index),
                        at: i
                    )
                    discImage.insert(chunkToMove, at: i)

                    break
                } else if chunkToCheck.count == chunkToMove.count {
                    if let idx = discImage.firstIndex(where: { $0.index == chunkToMove.index }) {
                        discImage[idx] = Chunk(value: ".", count: chunkToMove.count, index: chunkToMove.index)
                    }

                    discImage[i] = chunkToMove
                    break
                }
            }
        }

        return discImage.flatMap(\.asArray).enumerated().reduce(into: 0) { checksum, iter in
            let (idx, value) = iter

            if let num = Int(value) {
                checksum += idx * num
            }
        }
    }
}
