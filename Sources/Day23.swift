import Algorithms
import Collections

struct Day23: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let allConnections = data.split(separator: "\n")
            .map { $0.split(separator: "-").map { String($0) }.sorted() }
            .reduce(into: [:]) { res, connection in
                res[connection[0], default: []].append(connection[1])
            }
            .mapValues { $0.sorted() }
        var groups: Set<[String]> = []
        for node in allConnections.keys.sorted() {
            let connections = allConnections[node]!
            for pair in connections.combinations(ofCount: 2) {
                let n1 = pair[0]
                let n2 = pair[1]
                if allConnections[n1]?.contains(n2) ?? false {
                    groups.insert([node, n1, n2])
                }
            }
        }
        return groups.count {
            $0[0].hasPrefix("t") || $0[1].hasPrefix("t") || $0[2].hasPrefix("t")
        }
    }

    // https://en.wikipedia.org/wiki/Bron–Kerbosch_algorithm#With_pivoting
    func bronKerbosch(
        graph: [String: Set<String>],
        clique: Set<String>,
        candidates: Set<String>,
        excluded: Set<String>
    ) -> Set<String> {
        if candidates.isEmpty && excluded.isEmpty {
            return clique
        }
        var candidates = candidates
        var excluded = excluded
        let pivot = candidates.union(excluded).first!
        var largestClique: Set<String> = []
        for node in candidates.subtracting(graph[pivot]!) {
            let newClique = bronKerbosch(
                graph: graph,
                clique: clique.union([node]),
                candidates: candidates.intersection(graph[node]!),
                excluded: excluded.intersection(graph[node]!)
            )
            if newClique.count > largestClique.count {
                largestClique = newClique
            }
            candidates.remove(node)
            excluded.insert(node)
        }
        return largestClique
    }

    func part2() -> Any {
        // find the maximum clique of graph
        let graph: [String: Set<String>] = data.split(separator: "\n")
            .map { $0.split(separator: "-").map { String($0) } }
            .reduce(into: [:]) { res, connection in
                res[connection[0], default: Set<String>()].insert(connection[1])
                res[connection[1], default: Set<String>()].insert(connection[0])
            }

        return bronKerbosch(
            graph: graph,
            clique: Set<String>(),
            candidates: Set(graph.keys),
            excluded: Set<String>()
        )
        .sorted()
        .joined(separator: ",")
    }
}
