import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day18Tests {
    // Smoke test data provided in the challenge question
    let testData = """
        5,4
        4,2
        4,5
        3,0
        2,1
        6,3
        2,4
        1,5
        0,6
        3,3
        2,6
        5,1
        1,2
        5,5
        2,5
        6,5
        1,4
        0,4
        6,4
        1,1
        6,1
        1,0
        0,5
        1,6
        2,0
        """

    @Test func testPart1() async throws {
        let challenge = Day18(data: testData, size: 7, firstDrop: 12)
        #expect(String(describing: challenge.part1()) == "22")
    }

    @Test func testPart2() async throws {
        let challenge = Day18(data: testData, size: 7, firstDrop: 12)
        #expect(String(describing: challenge.part2()) == "6,1")
    }
}
