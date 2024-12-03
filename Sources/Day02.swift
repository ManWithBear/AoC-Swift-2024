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
        entities
            .filter { isSafe($0) }
            .count
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        entities.filter {
            if isSafe($0) {
                return true
            }
            for i in 1...$0.count {
                let pref = $0.prefix(upTo: i - 1)
                let suff = $0.dropFirst(i)
                if isSafe(pref + suff) {
                    return true
                }
            }
            return false
        }
        .count
    }

    func isSafe(_ report: some Sequence<Int>) -> Bool {
        let deltas = zip(report, report.dropFirst()).map { $0.0 - $0.1 }
        let allNegative = deltas.allSatisfy { $0 < 0 }
        let allPositive = deltas.allSatisfy { $0 > 0 }
        let allWithinRange = deltas.allSatisfy { (abs($0) <= 3) && (abs($0) >= 1) }
        return (allNegative || allPositive) && allWithinRange
    }
}
