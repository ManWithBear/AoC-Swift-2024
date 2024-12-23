import Algorithms

struct Day22: AdventDay {
    struct Secret {
        nonisolated(unsafe)
            static var cache: [Int: Secret] = [:]
        var value: Int
        var price: Int { value % 10 }

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
        var sellerSequences: [Seq: Int] = [:]
        for secret in initialSecrets {
            var iterator = PriceIterator(secret: secret)
            var checkedSeqs: Set<Seq> = []
            for _ in 0..<1996 {
                let (seq, price) = iterator.next()!
                guard !checkedSeqs.contains(seq) else {
                    continue
                }
                checkedSeqs.insert(seq)
                sellerSequences[seq, default: 0] += price
            }
        }
        return sellerSequences.values.max()!
    }

    struct Seq: Hashable {
        var d1, d2, d3, d4: Int

        func next(_ d: Int) -> Self {
            return Self(d1: d2, d2: d3, d3: d4, d4: d)
        }
    }

    struct PriceIterator: IteratorProtocol {
        var secret: Secret
        var value: (Seq, Int)

        init(secret: Secret) {
            var s = secret
            let p1 = s.price
            s = s.next()
            let p2 = s.price
            s = s.next()
            let p3 = s.price
            s = s.next()
            let p4 = s.price
            s = s.next()
            let p5 = s.price
            self.secret = s
            self.value = (Seq(d1: p2 - p1, d2: p3 - p2, d3: p4 - p3, d4: p5 - p4), p5)
        }

        mutating func next() -> (Seq, Int)? {
            secret = secret.next()
            let d = secret.price - value.1
            value = (value.0.next(d), secret.price)
            return value
        }
    }
}
