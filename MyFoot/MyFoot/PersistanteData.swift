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


/////////////////////////


public var fbuser: [FacebookUser]?

public func clearDataFacebookUser() {
    
    if let context = DataManager.shared.objectContext {
        
        do {
            
            let entityNames = ["FacebookUser"]
            
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

func setupDataFacebookUser(_apikey: String) {
    
    clearDataFacebookUser()
    if let context = DataManager.shared.objectContext {
        
        
        let fb = NSEntityDescription.insertNewObject(forEntityName: "FacebookUser", into: context) as! FacebookUser
        
        
        fb.apikey = _apikey
        
        
        do {
            try(context.save())
        } catch let err {
            print(err)
        }
    }
    
    loadDataFacebookUser()
    
}


public func loadDataFacebookUser() {
    
    if let context = DataManager.shared.objectContext {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FacebookUser")
        
        do {
            
          fbuser   = try(context.fetch(fetchRequest)) as? [FacebookUser]
            
        } catch let err {
            print(err)
        }
        
    }
}



/////////////////////////


public var reconaissance: [Reconaissance]?

public func clearDataReconaissance() {
    
    if let context = DataManager.shared.objectContext {
        
        do {
            
            let entityNames = ["Reconaissance"]
            
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

func setupDataReconaissance(_name: String, _club: String) {
    
    clearDataReconaissance()
    if let context = DataManager.shared.objectContext {
        
        
        let reco = NSEntityDescription.insertNewObject(forEntityName: "Reconaissance", into: context) as! Reconaissance
        
        reco.name = _name
        reco.club = _club
        
        
        do {
            try(context.save())
        } catch let err {
            print(err)
        }
    }
    
    loadDataReconaissance()
    
}


public func loadDataReconaissance() {
    
    if let context = DataManager.shared.objectContext {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reconaissance")
        
        do {
            
            reconaissance   = try(context.fetch(fetchRequest)) as? [Reconaissance]
            
        } catch let err {
            print(err)
        }
        
    }
}





/////////////////////////


public var member: [Member]?

public func clearDataMember() {
    
    if let context = DataManager.shared.objectContext {
        
        do {
            
            let entityNames = ["Member"]
            
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

func setupDataMember(_apikey: String) {
    
    clearDataMember()
    if let context = DataManager.shared.objectContext {
        
        
        let memb = NSEntityDescription.insertNewObject(forEntityName: "Member", into: context) as! Member
        
        memb.apikey = _apikey
        
        
        do {
            try(context.save())
        } catch let err {
            print(err)
        }
    }
    
    loadDataMember()
    
}


public func loadDataMember() {
    
    if let context = DataManager.shared.objectContext {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Member")
        
        do {
            
            member   = try(context.fetch(fetchRequest)) as? [Member]
            
        } catch let err {
            print(err)
        }
        
    }
}






/////////////////////////


public var license: [License]?

public func clearDataLicense() {
    
    if let context = DataManager.shared.objectContext {
        
        do {
            
            let entityNames = ["License"]
            
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

func setupDataLicense(_trouver: String) {
    
    clearDataLicense()
    if let context = DataManager.shared.objectContext {
        
        
        let lic = NSEntityDescription.insertNewObject(forEntityName: "License", into: context) as! License
        lic.verifie = _trouver
        
        
        do {
            try(context.save())
        } catch let err {
            print(err)
        }
    }
    
    loadDataLicense()
    
}


public func loadDataLicense() {
    
    if let context = DataManager.shared.objectContext {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "License")
        
        do {
            
            license   = try(context.fetch(fetchRequest)) as? [License]
            
        } catch let err {
            print(err)
        }
        
    }
}
















