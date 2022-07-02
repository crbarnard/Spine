//
//  Skeleton.swift
//  Spine
//
//  Created by Max Gribov on 06/02/2018.
//  Copyright © 2018 Max Gribov. All rights reserved.
//

import SpriteKit

public class Skeleton: SKNode {
    
    /**
     Closure that is called each time an event animation is triggered.
     The events represented by the 'EventModel' model
     
     See more information about events:
     http://esotericsoftware.com/spine-events
     */
    public var eventTriggered: ((EventModel) ->())?

    /**
     Creates a skeleton node with an 'SpineModel' and *optional* atlas folder name.
     
     See more information about Spine:
     http://esotericsoftware.com/spine-basic-concepts
     
     - parameter model: the skeleton model.
     - parameter folder: name of the folder with image atlases. *optional*
     */
    public convenience init(name: String, model: SpineModel, atlas folder: String) {
        self.init(name: name, model: model, provider: SKTextureAtlasProvider(atlas: SKTextureAtlas(named: folder)))
    }
    
    /**
     Creates a skeleton node with an 'SpineModel' and atlases dictionary.

     - parameter model: the skeleton model.
     - parameter atlases: atlases dictionary
     */
    public convenience init(name: String, model: SpineModel, atlas: SKTextureAtlas) {
        self.init(name: name, model: model, provider: SKTextureAtlasProvider(atlas: atlas))
    }
    
    public init(name: String, model: SpineModel, provider: SKTextureProvider) {
        super.init()
        self.createBones(model)
        self.createSlots(model)
        self.createSkins(name: name, model: model, provider: provider)
        self.createAnimations(model)
    }
    
    /**
     Сreates a skeleton node based on the json file stored in the bundle application.
     
     The initializer may fail, so returning value *optional*
     
     See more information about Spine:
     http://esotericsoftware.com/spine-basic-concepts
     
     - parameter name: Spine JSON file name.
     - parameter folder: name of the folder with image atlases. *optional*
     - parameter skin: the name of the skin that you want to apply to 'Skeleton'. *optional*
     */
    public convenience init?(fromJSON name: String, skin: String? = nil, provider: SKTextureProvider) {
        
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let json = try? Data(contentsOf: url),
              let model = try? JSONDecoder().decode(SpineModel.self, from: json) else {
                
                return nil
        }
        
        self.init(name: name, model: model,  provider: provider)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var skinNames: [String] {
        return skins?.map { $0.model.name }.filter { $0 != "default" } ?? []
    }

    //MARK: - Private
    
    var slots: [Slot]? { get { return self["//\(Slot.prefix)*"] as? [Slot] } }
    var skins: [Skin]?
    var animations: [Animation]?
    
    func createBones(_ model: SpineModel)  {
        
        if let bonesModels = model.bones {
            
            let bones: [Bone] = bonesModels.map { Bone($0) }
            
            for bone in bones {
                
                if let parentName = bone.model.parent,
                    let parentNode = bones.first(where: { $0.name == Bone.generateName(parentName) }) {
                    
                    parentNode.addChild(bone)
                    
                } else {
                    
                    self.addChild(bone)
                }
            }
        }
    }
    
    func createSlots(_ model: SpineModel) {

        if let slotsModels = model.slots {
            
            var slotOrder: Int = 0
            
            for slotModel in slotsModels {
                
                let boneName = Bone.generateName(slotModel.bone)
                if let bone = childNode(withName: "//\(boneName)") {
                    
                    let slot = Slot(slotModel, slotOrder)
                    bone.addChild(slot)
                } else {
                    print("missing bone " + "//\(boneName)")
                }
                
                slotOrder += 1
            }
        }
    }
    
    func createSkins(name: String, model: SpineModel, provider: SKTextureProvider) {
        
        self.skins = model.skins?.map({ (skinModel) -> Skin in
            
            return Skin(name, skinModel, provider)
        })
    }
    
    func createAnimations(_ model: SpineModel) {
        
        self.animations = model.animations?.map({ (animationModel) -> Animation in
            
            return Animation(animationModel, model)
        })
    }
}

