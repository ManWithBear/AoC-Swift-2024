import Algorithms
import Collections

struct Day23: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var connections: [String: [String]]

    init(data: String) {
        self.data = data
        self.connections = data.split(separator: "\n")
            .map { $0.split(separator: "-").map { String($0) }.sorted() }
            .reduce(into: [:]) { res, connection in
                res[connection[0], default: []].append(connection[1])
            }
            .mapValues { $0.sorted() }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var groups: Set<[String]> = []
        for node in self.connections.keys.sorted() {
            let connections = self.connections[node]!
            for pair in connections.combinations(ofCount: 2) {
                let n1 = pair[0]
                let n2 = pair[1]
                if self.connections[n1]?.contains(n2) ?? false {
                    groups.insert([node, n1, n2])
                }
            }
        }
        return groups.count {
            $0[0].hasPrefix("t") || $0[1].hasPrefix("t") || $0[2].hasPrefix("t")
        }
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        -1
    }
}
