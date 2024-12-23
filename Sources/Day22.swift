import Algorithms

struct Day22: AdventDay {
    struct Secret {
        nonisolated(unsafe)
            static var cache: [Int: Secret] = [:]
        var value: Int

        func next() -> Self {
            if let cached = Self.cache[self.value] {
                return cached
            }
            var value = self.value
            value = value ^ (value * 64)
            value %= 16_777_216
            value = value ^ Int((Double(value) / 32.0).rounded(.down))
            value %= 16_777_216
            value = value ^ (value * 2048)
            value %= 16_777_216
            let result = Secret(value: value)
            Self.cache[self.value] = result
            return result
        }
    }

    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    let initialSecrets: [Secret]

    init(data: String) {
        self.data = data
        self.initialSecrets = data.split(separator: "\n").map { Secret(value: Int($0)!) }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var secrets = initialSecrets
        for _ in 0..<2000 {
            secrets = secrets.map { $0.next() }
        }
        return secrets.map(\.value).reduce(0, +)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        -1
    }
}
