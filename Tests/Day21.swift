import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day21Tests {
    // Smoke test data provided in the challenge question
    let testData = """
        029A
        980A
        179A
        456A
        379A
        """

    @Test func testPart1() async throws {
        let challenge = Day21(data: testData)
        #expect(String(describing: challenge.part1()) == "126384")
    }

    @Test func testPart2() async throws {
        let challenge = Day21(data: testData)
        #expect(String(describing: challenge.part2()) == "32000")
    }
}
