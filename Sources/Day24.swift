import Algorithms

struct Day24: AdventDay {
    struct Circuit {
        var values: [String: Bool]
        var outputs: [String]
        nonisolated(unsafe) var rules: [String: (String, String, (Bool, Bool) -> Bool)]

        mutating func value(for wire: String) -> Bool {
            if let value = values[wire] {
                return value
            }
            let (lhs, rhs, op) = rules[wire]!
            let lhsValue = value(for: lhs)
            let rhsValue = value(for: rhs)
            values[wire] = op(lhsValue, rhsValue)
            return values[wire]!
        }

        mutating func toInt() -> Int {
            outputs.reversed().reduce(0) { $0 * 2 + (value(for: $1) ? 1 : 0) }
        }
    }

    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var initialCircuit: Circuit
    var rawRules: [String: (String, String, String)] = [:]

    nonisolated(unsafe) static let op = [
        "AND": { $0 && $1 },
        "OR": { $0 || $1 },
        "XOR": { $0 != $1 },
    ]
    static let rawOp = [
        "AND": "&",
        "OR": "|",
        "XOR": "^",
    ]

    init(data: String) {
        self.data = data
        var values: [String: Bool] = [:]
        var rules: [String: (String, String, (Bool, Bool) -> Bool)] = [:]
        let split = data.split(separator: "\n\n")
        var outputs: Set<String> = []
        for line in split[0].split(separator: "\n") {
            let parts = line.split(separator: ": ")
            values[String(parts[0])] = parts[1] == "1"
            if parts[0].hasPrefix("z") {
                outputs.insert(String(parts[0]))
            }
        }
        for rule in split[1].split(separator: "\n") {
            let parts = rule.split(separator: " ")
            let lhs = String(parts[0])
            let op = Self.op[String(parts[1])]!
            let rhs = String(parts[2])
            let result = String(parts[4])
            rules[result] = (lhs, rhs, op)
            if lhs.hasPrefix("z") {
                outputs.insert(lhs)
            }
            if rhs.hasPrefix("z") {
                outputs.insert(rhs)
            }
            if result.hasPrefix("z") {
                outputs.insert(result)
            }
            self.rawRules[result] = (lhs, Self.rawOp[String(parts[1])]!, rhs)
        }
        self.initialCircuit = Circuit(values: values, outputs: outputs.sorted(), rules: rules)
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var circuit = initialCircuit
        return circuit.toInt()
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        var rawRules = self.rawRules
        func swap(_ node1: String, _ node2: String) {
            let node1Rule = rawRules[node1]!
            let node2Rule = rawRules[node2]!
            rawRules[node1] = node2Rule
            rawRules[node2] = node1Rule
        }
        swap("dhg", "z06")
        swap("bhd", "z23")
        swap("nbf", "z38")
        swap("dpd", "brk")
        // bhd,brk,dhg,dpd,nbf,z06,z23,z38

        var mappedNames: [String: String] = [:]
        func map(name: String) -> String {
            if let mapped = mappedNames[name] {
                return mapped
            }
            if let (lhs, op, rhs) = rawRules[name] {
                let tmp = [map(name: lhs), map(name: rhs)].sorted()
                let newName = "(\(tmp[1])\(op)\(tmp[0]))"
                mappedNames[name] = newName
                return newName
            }
            mappedNames[name] = name
            return name
        }
        for output in initialCircuit.outputs.sorted() {
            _ = map(name: output)
            print("\(output): \(mappedNames[output]!)")
        }

        for name in mappedNames.keys.sorted() {
            if name.hasPrefix("z") || name.hasPrefix("x") || name.hasPrefix("y") { continue }
            print("\(name): \(mappedNames[name]!)")
        }
        return -1
    }
}
