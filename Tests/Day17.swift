import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day17Tests {
    // Smoke test data provided in the challenge question
    let testData = """
        Register A: 729
        Register B: 0
        Register C: 0

        Program: 0,1,5,4,3,0
        """

    @Test func testPart1_main() async throws {
        let challenge = Day17(data: testData)
        #expect(String(describing: challenge.part1()) == "4,6,3,5,6,3,5,2,1,0")
    }
    @Test func testPart1_example2() async throws {
        let testData = """
            Register A: 10
            Register B: 0
            Register C: 0

            Program: 5,0,5,1,5,4
            """
        let challenge = Day17(data: testData)
        #expect(String(describing: challenge.part1()) == "0,1,2")
    }
    @Test func testPart1_example3() async throws {
        let testData = """
            Register A: 2024
            Register B: 0
            Register C: 0

            Program: 0,1,5,4,3,0
            """
        let challenge = Day17(data: testData)
        #expect(String(describing: challenge.part1()) == "4,2,5,6,7,7,7,7,3,1,0")
    }

    @Test func testPart2() async throws {
        let testData = """
            Register A: 2024
            Register B: 0
            Register C: 0

            Program: 0,3,5,4,3,0
            """
        let challenge = Day17(data: testData)
        #expect(String(describing: challenge.part2()) == "117440")
    }
}
