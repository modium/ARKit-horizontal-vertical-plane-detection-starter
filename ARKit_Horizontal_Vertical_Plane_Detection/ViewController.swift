//
//  ViewController.swift
//  ARKit_Horizontal_Vertical_Plane_Detection
//
//  Created by Jaf Crisologo on 2019-10-13.
//  Copyright © 2019 Jan Crisologo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var planeName: String = ""
    var markerNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = [.horizontal, .vertical]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func createPlane(name: String, anchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        node.name = name
        node.eulerAngles.x = -.pi / 2
        node.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        node.geometry?.firstMaterial?.diffuse.contents = anchor.alignment == .horizontal ? UIColor.blue.withAlphaComponent(0.5) : UIColor.red.withAlphaComponent(0.5)
        node.geometry?.firstMaterial?.isDoubleSided = true
        node.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
        return node
    }
   
    func removeNode(name: String) {
       sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
           if node.name == name {
               node.removeFromParentNode()
           }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchorPlane = anchor as? ARPlaneAnchor else { return }
        planeName = anchorPlane.alignment == ARPlaneAnchor.Alignment.horizontal ? "horizontal" : "vertical"
        let planeNode = createPlane(name: planeName, anchor: anchorPlane)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let anchorPlane = anchor as? ARPlaneAnchor else { return }
        planeName = anchorPlane.alignment == ARPlaneAnchor.Alignment.horizontal ? "horizontal" : "vertical"
        removeNode(name: planeName)
        let planeNode = createPlane(name: planeName, anchor: anchorPlane)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let anchorPlane = anchor as? ARPlaneAnchor else { return }
        planeName = anchorPlane.alignment == ARPlaneAnchor.Alignment.horizontal ? "horizontal" : "vertical"
        removeNode(name: planeName)
    }
}
