//
//  PersistanteData.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 03/07/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit
import CoreData

//FUNCTION

//public var names = [String]()
public var playerss: [Player]?

public func clearDataClub() {
    
    if let context = DataManager.shared.objectContext {
        
        do {
            
            let entityNames = ["Player"]
            
            for entityName in entityNames {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                
                let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                
                for object in objects! {
                    context.delete(object)
                }
            }
            
            try(context.save())
            
            
        } catch let err {
            print(err)
        }
        
    }
}

func setupDataClub(_name: String, _club: String) {
    
    clearDataClub()
        if let context = DataManager.shared.objectContext {
            
            
            let player = NSEntityDescription.insertNewObject(forEntityName: "Player", into: context) as! Player
            
            
            player.name = _name
            player.club = _club
            
            
            
            do {
                try(context.save())
            } catch let err {
                print(err)
            }
        }
    
    loadDataClub()
    
}


public func loadDataClub() {
    
    if let context = DataManager.shared.objectContext {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        
        do {
            
            playerss = try(context.fetch(fetchRequest)) as? [Player]
            
        } catch let err {
            print(err)
        }
        
    }
}


/////////////////////////


public var score: [Score]?

public func clearDataUser() {
    
    if let context = DataManager.shared.objectContext {
        
        do {
            
            let entityNames = ["Score"]
            
            for entityName in entityNames {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                
                let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                
                for object in objects! {
                    context.delete(object)
                }
            }
            
            try(context.save())
            
            
        } catch let err {
            print(err)
        }
        
    }
}

func setupDataUser(_name: String) {
    
    clearDataUser()
    if let context = DataManager.shared.objectContext {
        
        
        let score = NSEntityDescription.insertNewObject(forEntityName: "Score", into: context) as! Score
        
        
        score.name = _name
        
        
        do {
            try(context.save())
        } catch let err {
            print(err)
        }
    }
    
    loadDataUser()
    
}


public func loadDataUser() {
    
    if let context = DataManager.shared.objectContext {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Score")
        
        do {
            
            score = try(context.fetch(fetchRequest)) as? [Score]
            
        } catch let err {
            print(err)
        }
        
    }
}




