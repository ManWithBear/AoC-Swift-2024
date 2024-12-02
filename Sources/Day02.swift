import Algorithms

struct Day02: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [[Int]] {
        data.split(separator: "\n").map {
            $0.split(separator: " ").compactMap { Int($0) }
        }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        entities.map {
            zip($0, $0.dropFirst()).map { $0.0 - $0.1 }
        }
        .filter {
            $0.allSatisfy { $0 > 0 } || $0.allSatisfy { $0 < 0 }
        }
        .filter {
            $0.allSatisfy { (abs($0) <= 3) && (abs($0) >= 1) }
        }
        .count
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        entities.map {
            $0.count
        }
        .count
    }
}
