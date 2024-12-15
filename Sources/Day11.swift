import Algorithms

struct Day11: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var initialStones: [Int: Int]

    init(data: String) {
        self.data = data
        self.initialStones = [:]
        let stones = data.split(separator: " ").map { Int($0)! }
        for stone in stones {
            self.initialStones[stone, default: 0] += 1
        }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var stones = initialStones
        for _ in 0..<25 {
            var newStones: [Int: Int] = [:]
            for (stone, count) in stones {
                if stone == 0 {
                    newStones[1, default: 0] += count
                    continue
                }
                let digitsCount = numberOfDigits(in: stone)
                if digitsCount.isMultiple(of: 2) {
                    let separator = (0..<digitsCount / 2).reduce(1) { acc, _ in acc * 10 }
                    let top = stone / separator
                    let bottom = stone % separator
                    newStones[top, default: 0] += count
                    newStones[bottom, default: 0] += count
                    continue
                }
                newStones[stone * 2024, default: 0] += count
            }
            stones = newStones
        }
        return stones.values.reduce(0, +)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        -1
    }
}
