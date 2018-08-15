//
//  SeasonStatsViewController.swift
//
//  Created by Raymond Li on 10/24/17.
//  Copyright © 2017 Raymond Li. All rights reserved.
//

import UIKit

class SeasonStatsViewController: UIViewController, NSURLConnectionDelegate {
    
    var baseStat: BaseStat = BaseStat()
    var advancedStat: AdvancedStat = AdvancedStat()
    var playerId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSeasonJSON(type: "Base")
        getSeasonJSON(type: "Advanced")
        
        //"http://stats.nba.com/stats/playercareerstats?LeagueID=00&PerMode=PerGame&PlayerID=1627759"
    }
    
    func getSeasonJSON(type: String) {
        let urlString = "https://stats.nba.com/stats/playerdashboardbyyearoveryear?DateFrom=&DateTo=&GameSegment=&LastNGames=0&LeagueID=00&Location=&Month=0&OpponentTeamID=0&Outcome=&PORound=0&PaceAdjust=N&PerMode=PerGame&Period=0&PlusMinus=N&Rank=N&Season=2017-18&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&Split=yoy&VsConference=&VsDivision=&MeasureType=" + type + "&PlayerID=" + String(playerId)
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if data != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                    let resultSetsTemp: NSArray = json["resultSets"] as! NSArray
                    let resultSets = resultSetsTemp[1] as! [String: Any]
                    let rowSetTemp: NSArray = resultSets["rowSet"] as! NSArray
                    let season: NSArray = rowSetTemp[0] as! NSArray
                    
                    if type == "Base" {
                        self.turnRowSetIntoBaseStat(rowSet: season)
                    } else if type == "Advanced" {
                        self.turnRowSetIntoAdvancedStat(rowSet: season)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                    })
                } catch {
                    print("Could not serialize")
                }
            }
        }).resume()
    }
    
    
    func turnRowSetIntoBaseStat(rowSet: NSArray) {
        let year = rowSet[1] as! String
        let team = rowSet[3] as! String
        
        let GP = rowSet[5] as! Double
        let MIN = roundThree(val: rowSet[9] as! Double)
        let PF = roundThree(val: rowSet[27] as! Double)
        
        let FGM = roundThree(val: rowSet[10] as! Double)
        let FGA = roundThree(val: rowSet[11] as! Double)
        let FGP = roundThree(val: rowSet[12] as! Double)
        
        let FG3M = roundThree(val: rowSet[13] as! Double)
        let FG3A = roundThree(val: rowSet[14] as! Double)
        let FG3P = roundThree(val: rowSet[15] as! Double)
        
        let FTM = roundThree(val: rowSet[16] as! Double)
        let FTA = roundThree(val: rowSet[17] as! Double)
        let FTP = roundThree(val: rowSet[18] as! Double)
        
        let OREB = roundThree(val: rowSet[19] as! Double)
        let DREB = roundThree(val: rowSet[20] as! Double)
        let TREB = roundThree(val: rowSet[21] as! Double)
        
        let PTS = roundThree(val: rowSet[29] as! Double)
        let AST = roundThree(val: rowSet[22] as! Double)
        let BLK = roundThree(val: rowSet[25] as! Double)
        let TOV = roundThree(val: rowSet[23] as! Double)
        
        self.baseStat = BaseStat(year: year, team: team, GP: GP, MIN: MIN, PF: PF, FGM: FGM, FGA: FGA, FGP: FGP, FG3M: FG3M, FG3A: FG3A, FG3P: FG3P, FTM: FTM, FTA: FTA, FTP: FTP, OREB: OREB, DREB: DREB, TREB: TREB, PTS: PTS, AST: AST, BLK: BLK, TOV: TOV)
    }
    
    func turnRowSetIntoAdvancedStat(rowSet: NSArray) {
        let ORAT = roundThree(val: rowSet[10] as! Double)
        let DRAT = roundThree(val: rowSet[11] as! Double)
        let NRAT = roundThree(val: rowSet[12] as! Double)
        let USG = roundThree(val: rowSet[22] as! Double)
        let EFG = roundThree(val: rowSet[20] as! Double)
        let TSP = roundThree(val: rowSet[21] as! Double)
        let ASTP = roundThree(val: rowSet[13] as! Double)
        let A2T = roundThree(val: rowSet[14] as! Double)
        let REBP = roundThree(val: rowSet[18] as! Double)
        let OREBP = roundThree(val: rowSet[16] as! Double)
        let DREBP = roundThree(val: rowSet[17] as! Double)
        let PACE = roundThree(val: rowSet[23] as! Double)
        
        self.advancedStat = AdvancedStat(ORAT: ORAT, DRAT: DRAT, NRAT: NRAT, USG: USG, EFG: EFG, TSP: TSP, ASTP: ASTP, A2T: A2T, REBP: REBP, OREBP: OREBP, DREBP: DREBP, PACE: PACE)
    }
    
    func roundThree(val: Double) -> Double {
        return Double(round(1000 * val) / 1000)
    }
    
    
    func abvToTeam(team: String) -> String {
        if team == "ATL" {
            return "Atlanta Hawks"
        }
        if team == "BOS" {
            return "Boston Celtics"
        }
        if team == "BKN" {
            return "Brooklyn Nets"
        }
        if team == "CHA" {
            return "Charlotte Hornets"
        }
        if team == "CHI" {
            return "Chicago Bulls"
        }
        if team == "CLE" {
            return "Cleveland Cavaliers"
        }
        if team == "DAL" {
            return "Dallas Mavericks"
        }
        if team == "DEN" {
            return "Denver Nuggets"
        }
        if team == "DET" {
            return "Detroit Pistons"
        }
        if team == "GSW" {
            return "Golden State Warriors"
        }
        if team == "HOU" {
            return "Houston Rockets"
        }
        if team == "IND" {
            return "Indiana Pacers"
        }
        if team == "LAC" {
            return "LA Clippers"
        }
        if team == "LAL" {
            return "LA Lakers"
        }
        if team == "MEM" {
            return "Memphis Grizzlies"
        }
        if team == "MIA" {
            return "Miami Heat"
        }
        if team == "MIL" {
            return "Milwaukee Bucks"
        }
        if team == "MIN" {
            return "Minnesota Timberwolves"
        }
        if team == "NOP" {
            return "New Orleans Pelicans"
        }
        if team == "NYK" {
            return "New York Knicks"
        }
        if team == "OKC" {
            return "Oklahoma City Thunder"
        }
        if team == "ORL" {
            return "Orlando Magic"
        }
        if team == "PHI" {
            return "Philadelphia 76ers"
        }
        if team == "PHX" {
            return "Phoenix Suns"
        }
        if team == "POR" {
            return "Portland Trail Blazers"
        }
        if team == "SAC" {
            return "Sacramento Kings"
        }
        if team == "SAS" {
            return "San Antonio Spurs"
        }
        if team == "TOR" {
            return "Toronto Rapters"
        }
        if team == "UTA" {
            return "Utah Jazz"
        }
        if team == "WAS" {
            return "Washington Wizards"
        }
        return "Team"
    }
}

struct BaseStat {
    var year: String = ""
    var team: String = ""
    var GP: Double = 0
    
    var MIN: Double = 0
    var PF: Double = 0 //Not used
    
    var FGM: Double = 0
    var FGA: Double = 0
    var FGP: Double = 0
    
    var FG3M: Double = 0
    var FG3A: Double = 0
    var FG3P: Double = 0
    
    var FTM: Double = 0
    var FTA: Double = 0
    var FTP: Double = 0
    
    var OREB: Double = 0
    var DREB: Double = 0
    var TREB: Double = 0
    
    var PTS: Double = 0
    var AST: Double = 0
    var BLK: Double = 0
    var TOV: Double = 0
    
    init(year: String, team: String, GP: Double, MIN: Double, PF: Double, FGM: Double, FGA: Double, FGP: Double, FG3M: Double, FG3A: Double, FG3P: Double, FTM: Double, FTA: Double, FTP: Double, OREB: Double, DREB: Double, TREB: Double, PTS: Double, AST: Double, BLK: Double, TOV: Double) {
        self.year = year
        self.team = team
        self.GP = GP
        self.MIN = MIN
        self.PF = PF
        self.FGM = FGM
        self.FGA = FGA
        self.FGP = FGP
        self.FG3M = FG3M
        self.FG3A = FG3A
        self.FG3P = FG3P
        self.FTM = FTM
        self.FTA = FTA
        self.FTP = FTP
        self.OREB = OREB
        self.DREB = DREB
        self.TREB = TREB
        self.PTS = PTS
        self.AST = AST
        self.BLK = BLK
        self.TOV = TOV
    }
    
    init() {}
}

struct AdvancedStat {
    var ORAT: Double = 0
    var DRAT: Double = 0
    var NRAT: Double = 0
    var USG: Double = 0
    var EFG: Double = 0
    var TSP: Double = 0
    var ASTP: Double = 0
    var A2T: Double = 0
    var REBP: Double = 0
    var OREBP: Double = 0
    var DREBP: Double = 0
    var PACE: Double = 0
    
    init(ORAT: Double, DRAT: Double, NRAT: Double, USG: Double, EFG: Double, TSP: Double, ASTP: Double, A2T: Double, REBP: Double, OREBP: Double, DREBP: Double, PACE: Double) {
        self.ORAT = ORAT
        self.DRAT = DRAT
        self.NRAT = NRAT
        self.USG = USG
        self.EFG = EFG
        self.TSP = TSP
        self.ASTP = ASTP
        self.A2T = A2T
        self.REBP = REBP
        self.OREBP = OREBP
        self.DREBP = DREBP
        self.PACE = PACE
    }
    
    init() {}
}

