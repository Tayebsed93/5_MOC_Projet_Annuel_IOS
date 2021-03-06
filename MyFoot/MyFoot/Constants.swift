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
let GREENBlACK_THEME_TRANSPARENT = UIColor(red: 89/255.0, green: 156/255.0, blue: 120/255.0, alpha: 0.9)

let GREY_THEME = UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0)
let GREEN_OLDCELL = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 0.5)
let GREY_CLASSEMENT = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1.0)
let DRAPEAU_FRANCE_IMG = "France"
let EMPTY_LOGO_IMG = "empty-logo"
let LOGO_BALL = "football_icon"
let LOGO_CONSTANTE = "logo"
let LICENSE_CONSTANTE = "license"
let ACTUALITY_CONSTANTE = "photo"
let ERROR_CONSTANTE = "Une erreur technique est survenue. Veuillez-nous excuser pour la gêne occasionnée"
let FACEBOOK_COLOR_BLUE = UIColor.rgb(r: 59, g: 89, b: 153)
let MDP_DEFAULT = "azerty"


//API URL
public var addressUrlString = "http://localhost:8888/FootAPI/API/v1"
public var addressUrlStringProd = "http://poubelle-connecte.pe.hu/FootAPI/API/v1"
public var tweetFeedUrl = "https://api.twitter.com/1.1/search/tweets.json?q=PSG&result_type=popular"
public var adressUrlCountryStringExterne = "https://apifootball.com/api/?action=get_leagues&country_id=173&APIkey=1efa2ed903e36f30a5c119f4391b1ca327e8f3405305dab81f21d613fe593144"


//API URL FOR IMAGE
public var matchid = String()
public var addressUrlForImage = "http://www.football-data.org/v1/competitions/"+matchid+"/teams"

//API KEY
public var twitterKey = "Bearer AAAAAAAAAAAAAAAAAAAAABjczAAAAAAAmpsyum03hAwA3jfPdbcpIrWLwXY%3Dg5wRYqAQUdGvCiPYoWV6vAsJ5ELWctM37PDkaAFXeX1NOFgn8"


//LOGIN ENDPOINT
public var registerUrlString = "/register"
public var loginUrlString = "/login"
public var loginFbUrlString = "/loginfb"

//CLUB ENDPOINT
public var clubUrlString = "/club"
//PLAYER ENDPOINT
public var playerUrlString = "/player"
//COMPSITION ENDPOINT
public var compositionUrlString = "/composition"
//COMPETITION ENDPOINT
public var competitionUrlString = "/competition"
//CHECK COMPETITION ENDPOINT
public var checkcompetitionUrlString = "/checkcompetition"

//USER ENDPOINT
public var userUrlString = "/user"
//NEWS ENDPOINT
public var newsUrlString = "/actuality/"
public var newsMembreUrlString = "/actuality"
//Comparaison ENDPOINT
public var playerUrlCompoResult = "/composition/result"

//DATE DEBUT SAISON
let DATE_DEBUT_SAISON = "2018-08-01"
let DATE_FIN_SAISON = "2018-12-31"

//POSTE
let ATTAQUANT = "AT"
let MILLIEU = "MIL"
let DEFENSSEUR = "DEF"
let GOAL = "GK"

//ROLE
let PAYSBAS = "Pays-Bas"
let ALLEMAGNE = "Allemagne"
let PAYSBASAPI = "Netherlands"
let ALLEMAGNEAPI = "Germany"

//Pays
let role_president = "president"
let role_joueur = "joueur"
let role_coach = "coach"
let role_supporter = "supporter"

//Dispositif
let qtt = "4-3-3"
let qqd = "4-4-2"

//Persistante
let defaults_comp = UserDefaults.standard
let defaults = UserDefaults.standard
let defaultsTwitter = UserDefaults.standard
struct defaultsssKeys {
    static let league_id = "league_id"
    static let urlResult = "urlResult"
    static let club = "club"
    static let role = "role"
    static let team_name = "team_name"
}

struct competitionKeys {
    static let competition_id = "competition_id"
}

struct TwitterKeys {
    static let team_name = "team_name"
}
//FUNCTION
func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}

//Dictionnnary Twitter
var dictionnaryTwitter: [String:String] = [
    "Paris Saint Germain" : "PSG_inside",
    "Monaco" : "AS_Monaco",
    "Lyon" : "OL",
    "Marseille" : "OM_Officiel",
    "Rennes" : "staderennais ‏",
    "Bordeaux" : "girondins",
    "Saint-Etienne" : "ASSEofficiel",
    "Nice" : "ogcnice",
    "Nantes" : "FCNantes",
    "Montpellier" : "MontpellierHSC",
    "Dijon" : "DFCO_Officiel",
    "Guingamp" : "EAGuingamp",
    "Amiens" : "AmiensSC",
    "Angers" : "AngersSCO",
    "Strasbourg" : "RCSA ‏",
    "Caen" : "SMCaen",
    "Lille" : "losclive",
    "Toulouse" : "ToulouseFC",
    "Troyes" : "estac_officiel",
    "Metz" : "FCMetz",
    
    "Reims" : "StadeDeReims",
    "Nimes" : "nimesolympique",
    "AC Ajaccio" : "ACAjaccio",
    "Le Havre" : "HAC_Foot",
    "Brest" : "SB29",
    "Clermont Foot" : "ClermontFoot",
    "Lorient" : "FCLorient",
    "Paris FC" : "ParisFC",
    "Chateauroux" : "LaBerrichonne",
    "Sochaux" : "FCSM_officiel",
    "Auxerre" : "AJA",
    "Orleans" : "US_Orleans",
    "Valenciennes" : "VAFC",
    "Lens" : "RCLens",
    "Niort" : "ChamoisNiortais",
    "GFC Ajaccio" : "gfc_ajaccio",
    "Nancy" : "asnlofficiel",
    "Bourg en Bresse Peronnas" : "FBBP01",
    "Quevilly" : "QRM",
    "Tours" : "ToursFC",
]



