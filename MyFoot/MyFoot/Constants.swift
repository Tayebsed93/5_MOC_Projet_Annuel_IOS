//
//  Constants.swift
//  MyFoot
//
//  Created by Tayeb Sedraia on 27/04/2018.
//  Copyright © 2018 Tayeb Sedraia. All rights reserved.
//

import UIKit

let GREEN_THEME = UIColor.rgb(r: 109, g: 201, b: 149)
let GREENBlACK_THEME = UIColor.rgb(r: 89, g: 156, b: 120)
let GREY_THEME = UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0)
let DRAPEAU_FRANCE_IMG = "France"
let EMPTY_LOGO_IMG = "empty-logo"
let LOGO_CONSTANTE = "logo"
let LICENSE_CONSTANTE = "license"
let ERROR_CONSTANTE = "Une erreur technique est survenue. Veuillez-nous excuser pour la gêne occasionnée"
let FACEBOOK_COLOR_BLUE = UIColor.rgb(r: 59, g: 89, b: 153)
let MDP_DEFAULT = "azerty"


//API URL
public var addressUrlString = "http://localhost:8888/FootAPI/API/v1"
public var addressUrlStringProd = "http://poubelle-connecte.pe.hu/FootAPI/API/v1"
public var tweetFeedUrl = "https://api.twitter.com/1.1/search/tweets.json?q=PSG&result_type=popular"

//API KEY
public var twitterKey = "Bearer AAAAAAAAAAAAAAAAAAAAABjczAAAAAAAmpsyum03hAwA3jfPdbcpIrWLwXY%3Dg5wRYqAQUdGvCiPYoWV6vAsJ5ELWctM37PDkaAFXeX1NOFgn8"

//LOGIN ENDPOINT
public var registerUrlString = "/register"
public var loginUrlString = "/login"
//CLUB ENDPOINT
public var clubUrlString = "/club"
//PLAYER ENDPOINT
public var playerUrlString = "/player"
//COMPSITION ENDPOINT
public var compositionUrlString = "/composition"

//USER ENDPOINT
public var userUrlString = "/user"

//DATE DEBUT SAISON
let DATE_DEBUT_SAISON = "2017-08-01"
let DATE_FIN_SAISON = "2018-07-01"

//ROLE
let role_president = "president"
let role_joueur = "joueur"
let role_coach = "coach"
let role_supporter = "supporter"


//FUNCTION
func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}




