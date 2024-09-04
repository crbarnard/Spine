//
//  AnimationTests.swift
//
//
//  Created by Corey Barnard on 04/09/2024.
//

import XCTest
@testable import Spine

final class AnimationTests: XCTestCase {
    
    var slots: [SlotModel] = []
    var keyframes: [DrawOrderKeyframeModel] = []
    
    override func setUp() {
        do {
            try setUpSlots()
            try setUpKeyframes()
        } catch {
            XCTFail("Setup function threw an error: \(error)")
        }
    }
    
    override func tearDown() {
        slots = []
        keyframes = []
    }
    
    func setUpSlots() throws {
        guard let url = Bundle.module.url(forResource: "slots", withExtension: "json") else {
            XCTFail()
            return
        }
        let json = try Data(contentsOf: url)
        let result = try JSONDecoder().decode([SlotModel].self, from: json)
        self.slots = result
    }
    
    func setUpKeyframes() throws {
        guard let url = Bundle.module.url(forResource: "drawOrderKeyframes", withExtension: "json") else {
            XCTFail()
            return
        }
        let json = try Data(contentsOf: url)
        let result = try JSONDecoder().decode([DrawOrderKeyframeModel].self, from: json)
        self.keyframes = result
    }
    
    func testReordered() throws {
        let offsets = [
            DrawOrderKeyframeModel.Offset(slot: "rear-thigh", offset: 5),
            DrawOrderKeyframeModel.Offset(slot: "goggles", offset: -13),
            DrawOrderKeyframeModel.Offset(slot: "rear-upper-arm", offset: 17)
        ]
        let result = Animation.reordered(slots: slots, offsets: offsets)
        
        XCTAssertEqual(5, slots.firstIndex { $0.name == "rear-thigh" })
        XCTAssertEqual(10, result.firstIndex { $0.name == "rear-thigh" })
        
        XCTAssertEqual(16, slots.firstIndex { $0.name == "goggles" })
        XCTAssertEqual(3, result.firstIndex { $0.name == "goggles" })
        
        XCTAssertEqual(0, slots.firstIndex { $0.name == "rear-upper-arm" })
        XCTAssertEqual(17, result.firstIndex { $0.name == "rear-upper-arm" })
    }
}
