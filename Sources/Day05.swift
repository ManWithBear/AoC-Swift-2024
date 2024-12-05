import Algorithms

struct Day05: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var mustBeBefore: [Int: [Int: Bool]]
    var updates: [[Int]]

    init(data: String) {
        self.data = data
        mustBeBefore = [:]
        updates = []

        let groups = data.split(separator: "\n\n")
        groups[0].split(separator: "\n").forEach {
            let parts = $0.split(separator: "|")
            mustBeBefore[Int(parts[0])!, default: [:]][Int(parts[1])!] = true
            mustBeBefore[Int(parts[1])!, default: [:]][Int(parts[0])!] = false
        }
        updates = groups[1].split(separator: "\n").map {
            $0.split(separator: ",").map { Int($0)! }
        }
    }

    func isUpdateValid(_ update: [Int]) -> Bool {
        for i in 0..<update.count - 1 {
            let page = update[i]
            for j in i + 1..<update.count {
                let nextPage = update[j]
                guard let pageRulebook = mustBeBefore[page] else { continue }
                guard let pairOrder = pageRulebook[nextPage] else { continue }
                guard pairOrder else { return false }
            }
        }
        return true
    }

    func middlePage(of update: [Int]) -> Int {
        let index = update.count / 2
        return update[index]
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        updates.filter { isUpdateValid($0) }
            .map { middlePage(of: $0) }
            .reduce(0, +)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        updates.filter { !isUpdateValid($0) }
            .map {
                $0.sorted { pageA, pageB in
                    mustBeBefore[pageA]?[pageB] == true
                }
            }
            .map { middlePage(of: $0) }
            .reduce(0, +)
    }
}
