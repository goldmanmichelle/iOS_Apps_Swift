//
//  ObstacleStats.swift
//  Zanga
//
//  Created by Michelle Goldman on 8/3/15.
//  Copyright (c) 2015 Michelle Goldman. All rights reserved.
//

import AVFoundation
import SpriteKit

class ObstacleStats {
    var isLive = false
    var timeTillNextSpawn = UInt32(0)
    var currentInterval = UInt32(0)
    init(isLive:Bool, timeTillNextSpawn:UInt32, currentInterval:UInt32) {
        self.isLive = isLive
        self.timeTillNextSpawn = timeTillNextSpawn
        self.currentInterval = currentInterval
    }
    
    func runObstacleStats() -> Bool {
        return self.currentInterval > self.timeTillNextSpawn
    }
    
    
}