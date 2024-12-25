import Algorithms

private let width = 5
private let height = 7

struct Day25: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var locks: [[Int]]
    var keys: [[Int]]

    init(data: String) {
        self.data = data
        self.locks = []
        self.keys = []
        for entry in data.split(separator: "\n\n") {
            let split = entry.split(separator: "\n")
            let parsedEntry = (0..<width).map { column in
                split.reduce(0) {
                    $0 + ($1[$1.index($1.startIndex, offsetBy: column)] == "#" ? 1 : 0)
                }
            }
            if split[0].first == "#" {
                locks.append(parsedEntry)
            } else {
                keys.append(parsedEntry)
            }
        }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var count = 0
        for key in keys {
            middle: for lock in locks {
                for (keyPin, lockPin) in zip(key, lock) {
                    if keyPin + lockPin > height {
                        continue middle
                    }
                }
                count += 1
            }
        }
        return count
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        -1
    }
}
