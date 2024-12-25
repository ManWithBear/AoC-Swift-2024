import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day25Tests {
    // Smoke test data provided in the challenge question
    let testData = """
        #####
        .####
        .####
        .####
        .#.#.
        .#...
        .....

        #####
        ##.##
        .#.##
        ...##
        ...#.
        ...#.
        .....

        .....
        #....
        #....
        #...#
        #.#.#
        #.###
        #####

        .....
        .....
        #.#..
        ###..
        ###.#
        ###.#
        #####

        .....
        .....
        .....
        #....
        #.#..
        #.#.#
        #####
        """

    @Test func testPart1() async throws {
        let challenge = Day25(data: testData)
        #expect(String(describing: challenge.part1()) == "3")
    }

    @Test func testPart2() async throws {
        let challenge = Day25(data: testData)
        #expect(String(describing: challenge.part2()) == "32000")
    }
}
