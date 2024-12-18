import Algorithms

struct Day17: AdventDay {
    struct Computer {
        var A: Int
        var B: Int
        var C: Int
        var program: [Int]
        var pointer: Int = 0
        var output: [Int] = []
        var halted: Bool = false

        mutating func step() {
            guard !halted else { return }
            guard pointer + 1 < program.count else {
                halted = true
                return
            }
            let instruction = program[pointer]
            pointer += 1
            switch instruction {
            case 0: adv()
            case 1: bxl()
            case 2: bst()
            case 3: jnz()
            case 4: bxc()
            case 5: out()
            case 6: bdv()
            case 7: cdv()
            default: fatalError("Outside of 3-bit")
            }
        }

        func readLiteralOperand() -> Int {
            program[pointer]
        }

        func readComboOperand() -> Int {
            switch program[pointer] {
            case 0...3: return program[pointer]
            case 4: return A
            case 5: return B
            case 6: return C
            case 7:
                fatalError("Combo operand 7 is reserved and will not appear in valid input.")
            default: fatalError("Outside of 3-bit")
            }
        }

        mutating func adv() {
            defer { pointer += 1 }
            A = A >> readComboOperand()
        }
        mutating func bxl() {
            defer { pointer += 1 }
            B = B ^ readLiteralOperand()
        }
        mutating func bst() {
            defer { pointer += 1 }
            B = readComboOperand() % 8
        }
        mutating func jnz() {
            guard A != 0 else {
                pointer += 1
                return
            }
            pointer = readLiteralOperand()
        }
        mutating func bxc() {
            defer { pointer += 1 }
            B = B ^ C
        }
        mutating func out() {
            defer { pointer += 1 }
            let operand = readComboOperand()
            output.append(operand % 8)
        }
        mutating func bdv() {
            defer { pointer += 1 }
            B = A >> readComboOperand()
        }
        mutating func cdv() {
            defer { pointer += 1 }
            C = A >> readComboOperand()
        }
    }

    // Save your data in a corresponding text file in the `Data` directory.
    var data: String
    var initialComputer: Computer

    init(data: String) {
        self.data = data
        let split = data.split(separator: "\n\n")
        let registers = split[0]
            .split(separator: "\n")
            .map { Int($0.split(separator: ": ")[1])! }
        let program = split[1]
            .split(separator: ": ")[1]
            .split(separator: ",")
            .map { Int($0)! }
        self.initialComputer = Computer(
            A: registers[0], B: registers[1], C: registers[2],
            program: program
        )
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var computer = initialComputer
        while !computer.halted {
            computer.step()
        }
        return computer.output.map { String($0) }.joined(separator: ",")
    }

    // MARK: - Part 2
    struct Registers: Hashable {
        var A: Int
        var B: Int
        var C: Int

        static func all(with A: Int) -> [Registers] {
            (0..<64).map { Registers(A: A, B: $0 % 8, C: $0 / 8) }
        }

        func comboOperand(operand: Int) -> Int {
            switch operand {
            case 0...3: return operand
            case 4: return A
            case 5: return B
            case 6: return C
            case 7: fatalError("Combo operand 7 will not appear in valid input.")
            default: fatalError("Outside of 3-bit")
            }
        }

        func adv(operand: Int) -> [Registers] {
            let range = comboOperand(operand: operand)
            let baseA = A << range
            guard range > 0 else { return [self] }
            return (0..<1 << range).map { Registers(A: baseA + $0, B: B, C: C) }
        }
        func bxl(operand: Int) -> [Registers] {
            [Registers(A: A, B: B ^ operand, C: C)]
        }
        func bst(operand: Int) -> [Registers] {
            if operand == 4 && B == A % 8 { return [self] }
            if operand == 5 && B == B % 8 { return [self] }
            if operand == 6 && B == C % 8 { return [self] }
            return []
        }
        func jnz(operand: Int) -> [Registers] { [] }
        func bxc(operand: Int) -> [Registers] {
            [Registers(A: A, B: B ^ C, C: C)]
        }
        func out(operand: Int, expected: Int) -> [Registers] {
            if operand == 4 && A % 8 == expected { return [self] }
            if operand == 5 && B % 8 == expected { return [self] }
            if operand == 6 && C % 8 == expected { return [self] }
            return []
        }
        func bdv(operand: Int) -> [Registers] { [] }
        func cdv(operand: Int) -> [Registers] {
            let range = comboOperand(operand: operand)
            guard (A >> range) % 8 == C else { return [] }
            return [self]
        }
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let input = initialComputer.program.dropLast(2)
        let count = input.count
        var output = Array(initialComputer.program.reversed())
        var startingA = Set([0])
        while !output.isEmpty {
            var pointer = count - 2
            var registers = startingA.flatMap { Registers.all(with: $0) }
            while pointer >= 0 {
                let operand = input[pointer + 1]
                switch input[pointer] {
                case 0:
                    registers = registers.flatMap { $0.adv(operand: operand) }
                case 1:
                    registers = registers.flatMap { $0.bxl(operand: operand) }
                case 2:
                    registers = registers.flatMap { $0.bst(operand: operand) }
                case 3:
                    registers = registers.flatMap { $0.jnz(operand: operand) }
                case 4:
                    registers = registers.flatMap { $0.bxc(operand: operand) }
                case 5:
                    let expectedOutput = output.removeFirst()
                    registers = registers.flatMap {
                        $0.out(operand: operand, expected: expectedOutput)
                    }
                case 6:
                    registers = registers.flatMap { $0.bdv(operand: operand) }
                case 7:
                    registers = registers.flatMap { $0.cdv(operand: operand) }
                default: fatalError("Outside of 3-bit")
                }
                pointer -= 2
                if registers.isEmpty {
                    return -1
                }
            }
            startingA = Set(registers.map(\.A))
        }
        return startingA.min() ?? -1
    }
}
