//
//  File.swift
//  
//
//  Created by Corey Barnard on 2/07/22.
//

import Foundation
import SpriteKit

public class SKTextureAtlasProvider: SKTextureProvider {
    
    private let atlas: SKTextureAtlas
    
    public init(atlas: SKTextureAtlas) {
        self.atlas = atlas
    }
    
    public func texture(named name: String) -> SKTexture? {
        return atlas.textureNamed(name)
    }
    
}
