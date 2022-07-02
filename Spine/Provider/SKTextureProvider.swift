//
//  File.swift
//  
//
//  Created by Corey Barnard on 2/07/22.
//

import Foundation
import SpriteKit

public protocol SKTextureProvider {
    func texture(named: String) -> SKTexture?
}
