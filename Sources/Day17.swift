import Algorithms

struct Day17: AdventDay {
    struct Computer {
        var A: Int
        var B: Int
        var C: Int
        var rawProgram: String
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
            case 7: fatalError("Combo operand 7 is reserved and will not appear in valid programs.")
            default: fatalError("Outside of 3-bit")
            }
        }

        mutating func adv() {
            defer { pointer += 1 }
            let operand = readComboOperand()
            let divisor = 1 << operand
            A = A / divisor
        }
        mutating func bxl() {
            defer { pointer += 1 }
            let operand = readLiteralOperand()
            B = B ^ operand
        }
        mutating func bst() {
            defer { pointer += 1 }
            let operand = readComboOperand()
            B = operand % 8
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
            let operand = readComboOperand()
            let divisor = 1 << operand
            B = A / divisor
        }
        mutating func cdv() {
            defer { pointer += 1 }
            let operand = readComboOperand()
            let divisor = 1 << operand
            C = A / divisor
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
            rawProgram: program.map { String($0) }.joined(separator: ","),
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

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        -1
    }
}
