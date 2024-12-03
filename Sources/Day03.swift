import Algorithms
import RegexBuilder

struct Day03: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let mulReg = Regex {
            "mul("
            Capture { OneOrMore(.digit) }
            ","
            Capture { OneOrMore(.digit) }
            ")"
        }
        let matches = data.matches(of: mulReg)
        return matches.map {
            let a = Int($0.1)!
            let b = Int($0.2)!
            return a * b
        }.reduce(0, +)
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let mulReg = Regex {
            Capture {
                ChoiceOf {
                    "do()"
                    "don't()"
                    Regex {
                        "mul("
                        Capture { OneOrMore(.digit) }
                        ","
                        Capture { OneOrMore(.digit) }
                        ")"
                    }
                }
            }
        }
        let matches = data.matches(of: mulReg)
        return matches.reduce((0, true)) { acc, match in
            switch match.0 {
            case "do()":
                return (acc.0, true)
            case "don't()":
                return (acc.0, false)
            default:
                guard acc.1 else { return acc }
                return (acc.0 + (Int(match.2!)! * Int(match.3!)!), acc.1)
            }
        }.0
    }
}
