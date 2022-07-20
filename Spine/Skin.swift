//
//  Skin.swift
//  Spine
//
//  Created by Max Gribov on 08/02/2018.
//  Copyright © 2018 Max Gribov. All rights reserved.
//

import SpriteKit

class Skin {
    
    let name: String
    let model: SkinModel
//    let atlases: [String : SKTextureAtlas]?
    let provider: SKTextureProvider
    
    init(_ name: String, _ model: SkinModel, provider: SKTextureProvider) {
        
        self.name = name
        self.model = model
        
//        guard let atlasesNames = model.atlasesNames() else {
//
//            self.atlases = nil
//            return
//        }
        
//        var atlases = [String : SKTextureAtlas]()
//
//        for atlasName in atlasesNames {
//
//            var atlasPath = atlasName
//
//            if let folder = folder {
//
//                atlasPath = "\(folder)/\(atlasName)"
//            }
//
//            atlases[atlasName] = SKTextureAtlas(named: atlasPath)
//        }
        
        self.provider = provider
    }
    
    init(_ name: String, _ model: SkinModel, _ provider: SKTextureProvider) {
        
        self.name = name
        self.model = model
        self.provider = provider
    }
    
    func attachment(_ model: AttachmentModelType) -> Attachment? {
        
        if AttachmentBuilder.textureRequired(for: model) {
            
            guard let attachmentAtlasName = atlasName(for: model),
                  let textureName = textureName(for: model, prefix: name),
                let texture = texture(with: textureName, from: attachmentAtlasName) else {
                    
                    return nil
            }
            
            return AttachmentBuilder.attachment(for: model, texture)
            
        } else {
            
            return AttachmentBuilder.attachment(for: model)
        }
    }
    
    func texture(with name: String, from atlasName: String) -> SKTexture? {
        print("getting texture \(name)")
        return provider.texture(named: name)
    }
}

//MARK: - Atlases Names Helpers

func textureName(from name: String, actualName: String? , path: String?, prefix: String) -> String {
    
    let resultName = path ?? actualName ?? name
    let splittedResultName = resultName.components(separatedBy: "/")
    
//    return splittedResultName.last ?? name
    
    
    return prefix + "_" + resultName.replacingOccurrences(of: "/", with: "_")
}

func textureName(for attachmentType: AttachmentModelType, prefix: String) -> String? {
    
    switch attachmentType {
    case .region(let region): return textureName(from: region.name, actualName: region.actualName, path: region.path, prefix: prefix)
    case .mesh(let mesh): return textureName(from: mesh.name, actualName: mesh.actualName, path: mesh.path, prefix: prefix)
    case .linkedMesh(let linkedMesh): return textureName(from: linkedMesh.name, actualName: linkedMesh.actualName, path: linkedMesh.path, prefix: prefix)
    default: return nil
    }
}

func atlasName(from name: String, actualName: String?, path: String?) -> String {
    
    let nameWithPath = path ?? actualName ?? name
    var nameWithPathSplitted = nameWithPath.components(separatedBy: "/")
    
    if nameWithPathSplitted.count > 1 {
        
        nameWithPathSplitted.removeLast()
        return nameWithPathSplitted.joined(separator: "/")
        
    } else {
        
        return "default"
    }
}

func atlasName(for attachmentType: AttachmentModelType ) -> String? {

    switch attachmentType {
    case .region(let region): return atlasName(from: region.name, actualName: region.actualName, path: region.path)
    case .mesh(let mesh): return atlasName(from: mesh.name, actualName: mesh.actualName, path: mesh.path)
    case .linkedMesh(let linkedMesh): return atlasName(from: linkedMesh.name, actualName: linkedMesh.actualName, path: linkedMesh.path)
    default:
        print("missing \(attachmentType)")
        return nil
    }
}
