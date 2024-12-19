import Algorithms

struct Day19: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    let stripes: [String]
    let designs: [String]

    init(data: String) {
        self.data = data
        let split = data.split(separator: "\n\n")
        self.stripes = split[0].split(separator: ", ").map { String($0) }.sorted()
        self.designs = split[1].split(separator: "\n").map { String($0) }
    }

    nonisolated(unsafe) static var cache: [String: Bool] = [:]
    func canMake(design: String) -> Bool {
        if let cached = Self.cache[design] {
            return cached
        }
        for stripe in stripes {
            guard design.hasPrefix(stripe) else { continue }
            let remaining = design.dropFirst(stripe.count)
            if remaining.isEmpty {
                Self.cache[design] = true
                return true
            }
            if canMake(design: String(remaining)) {
                Self.cache[design] = true
                return true
            }
        }
        Self.cache[design] = false
        return false
    }

    func part1() -> Any {
        designs.count { canMake(design: $0) }
    }

    nonisolated(unsafe) static var cache2: [String: Int] = [:]
    func howManyCanMake(design: String) -> Int {
        if let cached = Self.cache2[design] {
            return cached
        }
        var count = 0
        for stripe in stripes {
            guard design.hasPrefix(stripe) else { continue }
            if stripe == design {
                count += 1
                continue
            }
            let remainingCount = howManyCanMake(design: String(design.dropFirst(stripe.count)))
            if remainingCount > 0 {
                count += remainingCount
            }
        }
        Self.cache2[design] = count
        return count
    }

    func part2() -> Any {
        designs.map { howManyCanMake(design: $0) }.reduce(0, +)
    }
}
