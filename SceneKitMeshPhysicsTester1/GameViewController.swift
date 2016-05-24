//
//  GameViewController.swift
//  SceneKitMeshPhysicsTester1
//
//  Created by Dan Goyette on 5/20/16.
//  Copyright (c) 2016 Dan Goyette. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    
    let scene = SCNScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 25)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
  
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
        
        scnView.debugOptions = .ShowPhysicsShapes
        
        
        //addOddPieces()
        addTunnelPieces()
    }
  
    
    func addTunnelPieces() {
        
        let halfSide : Float = 1.25
        
        let positions: [SCNVector3] = [   SCNVector3Make(-halfSide, -halfSide,  halfSide),
                                          SCNVector3Make( halfSide, -halfSide,  2 * halfSide),
                                          SCNVector3Make(-halfSide, -halfSide, -halfSide),
                                          SCNVector3Make( halfSide, -halfSide, -halfSide),
                                          SCNVector3Make(-halfSide,  halfSide,  halfSide),
                                          SCNVector3Make( halfSide,  3 * halfSide,  halfSide),
                                          SCNVector3Make(-halfSide,  3 * halfSide, -halfSide),
                                          SCNVector3Make( 8 * halfSide,  halfSide, -halfSide)
                                       ]
        
        var indices: [Int32] = [
            0, 2, 1,
            1, 2, 3,
            // back
            2, 6, 3,
            3, 6, 7,
            // left
            0, 4, 2,
            2, 4, 6,
            // right
            1, 3, 5,
            3, 7, 5,
            // front
            0, 1, 4,
            1, 5, 4,
            // top
            4, 5, 6,
            5, 7, 6
        ]
        let vertexSource = SCNGeometrySource(vertices: positions, count: positions.count)
        let indexData = NSData(bytes: indices, length: sizeof(Int32) * indices.count)
        
        
        
        let element = SCNGeometryElement(data: indexData, primitiveType: .Triangles, primitiveCount: indices.count / 3, bytesPerIndex: sizeof(Int32))
        let geometry = SCNGeometry(sources: [vertexSource], elements: [element])
        
//        let sphere = SCNSphere(3)
//        
//        let physicsShape = SCNPhysicsShape(geometry: sphere, options: [SCNPhysicsShapeTypeKey: SCNPhysicsShapeTypeConvexHull])

        let physicsShape = SCNPhysicsShape(geometry: geometry, options: [SCNPhysicsShapeTypeKey: SCNPhysicsShapeTypeConcavePolyhedron])
        
        
        
        let compoundPhysicsBody = SCNPhysicsBody(type: .Static, shape: physicsShape)
        let compoundPhysicsBodyNode = SCNNode(geometry: geometry)
        let material = SCNMaterial()
        material.diffuse.contents = [UIColor.redColor()]
        geometry.materials = [material]
        compoundPhysicsBodyNode.physicsBody = compoundPhysicsBody;
        compoundPhysicsBodyNode.eulerAngles.x = Float(M_PI_4)
        compoundPhysicsBodyNode.position.z = -0.5
        
        scene.rootNode.addChildNode(compoundPhysicsBodyNode)
        
        
        
        let sphereShape = SCNSphere(radius: 1)
        let sphereNode = SCNNode(geometry: sphereShape)
        sphereNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        sphereNode.physicsBody!.mass = 500
        sphereNode.position.y = 10
        
        scene.rootNode.addChildNode(sphereNode)
    }
    
    func addOddPieces() {
        
    
        let box1 = SCNBox(width: 4, height: 4, length: 4, chamferRadius: 0)
        let box1PhysicsShape = SCNPhysicsShape(geometry: box1, options: [SCNPhysicsShapeTypeKey: SCNPhysicsShapeTypeConcavePolyhedron])
        let box2 = SCNBox(width: 1, height: 1, length: 8, chamferRadius: 0)
        let box2PhysicsShape = SCNPhysicsShape(geometry: box2, options: [SCNPhysicsShapeTypeKey: SCNPhysicsShapeTypeConcavePolyhedron])
        
        let compoundPhysicsShape = SCNPhysicsShape(shapes: [box1PhysicsShape, box2PhysicsShape], transforms: [NSValue(SCNMatrix4: SCNMatrix4MakeTranslation(0, 0, 0)), NSValue(SCNMatrix4: SCNMatrix4MakeTranslation(0, 0, 6))])
        
        let compoundPhysicsBody = SCNPhysicsBody(type: .Static, shape: compoundPhysicsShape)
        let compoundPhysicsBodyNode = SCNNode()
        compoundPhysicsBodyNode.physicsBody = compoundPhysicsBody;
        compoundPhysicsBodyNode.eulerAngles.x = Float(M_PI_4)
        compoundPhysicsBodyNode.position.z = -0.5
        
        scene.rootNode.addChildNode(compoundPhysicsBodyNode)
        
        
        
        let sphereShape = SCNSphere(radius: 1)
        let sphereNode = SCNNode(geometry: sphereShape)
        sphereNode.physicsBody = SCNPhysicsBody(type: .Dynamic, shape: nil)
        sphereNode.physicsBody!.mass = 500
        sphereNode.position.y = 10
        
        scene.rootNode.addChildNode(sphereNode)
        
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
