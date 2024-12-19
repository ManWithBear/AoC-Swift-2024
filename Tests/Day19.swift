import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day19Tests {
    // Smoke test data provided in the challenge question
    let testData = """
        r, wr, b, g, bwu, rb, gb, br

        brwrr
        bggr
        gbbr
        rrbgbr
        ubwu
        bwurrg
        brgr
        bbrgwb
        """

    @Test func testPart1() async throws {
        let challenge = Day19(data: testData)
        #expect(String(describing: challenge.part1()) == "6")
    }

    @Test func testPart2() async throws {
        let challenge = Day19(data: testData)
        #expect(String(describing: challenge.part2()) == "16")
    }
}
