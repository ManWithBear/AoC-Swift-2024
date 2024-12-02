import Algorithms

struct Day01: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: (left: [Int], right: [Int]) {
        data
            .split(separator: "\n")
            .map {
                let parts = $0.split(separator: " ").compactMap { Int($0) }
                return (parts[0], parts[1])
            }.reduce(([], [])) { acc, next in
                var acc = acc
                acc.0.append(next.0)
                acc.1.append(next.1)
                return acc
            }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let (left, right) = entities
        return zip(left.sorted(), right.sorted())
            .map { abs($0.0 - $0.1) }
            .reduce(0, +)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let (left, right) = entities
        let count = Dictionary(right.map { ($0, 1) }, uniquingKeysWith: +)
        return left.map { $0 * count[$0, default: 0] }
            .reduce(0, +)
    }
}
