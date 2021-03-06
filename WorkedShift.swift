//
//  WorkedShift.swift
//  SixOhFour
//
//  Created by vinceboogie on 7/29/15.
//  Copyright (c) 2015 vinceboogie. All rights reserved.
//

import UIKit
import Foundation
import CoreData
@objc(WorkedShift)

class WorkedShift: NSManagedObject {

    @NSManaged var duration: Double
    @NSManaged var source: String
    @NSManaged var status: NSNumber // 0 = Complete, 1 = Incomplete, 2 = Running, 3 = Manual, 4 = Auto
    @NSManaged var job: Job
    @NSManaged var timelogs: NSSet
    @NSManaged var startTime: NSDate
    @NSManaged var endTime: NSDate    

    var pay: Double!
    let dataManager = DataManager()
    var totalBreaktime : Double = 0.0
    var sortedTimelogs = [Timelog]()
    
    func hoursWorked() -> Double {
        sumUpDuration()
        var hoursWorked: Double = (round( 100 * ( duration / 3600 ) ) / 100 )
        return hoursWorked
    }
    
    func hoursWorkedReg() -> Double {
        sumUpDuration()
        if duration < 8*60*60 {
            var hoursWorkedReg: Double = (round( 100 * ( duration / 3600 ) ) / 100 )
            return hoursWorkedReg
        } else {
            return (8)
        }
    }
    
    func hoursWorkedOT() -> Double {
        if duration >= 8*60*60 {
            var hoursWorkedOT: Double = ( (round( 100 * ( duration / 3600 ) ) / 100 ) - 8)
            return hoursWorkedOT
        } else {
            return 0.0
        }
    }
    
    func moneyShift() -> Double {
        pay  = (round( 100 * (duration / 3600) * ( Double(self.job.payRate) ) ) / 100)
        return pay
    }


    func moneyShiftOT() -> Double {
        if duration > (60*60*8) {
            pay =  (round( 100 * (((duration / 3600) - 8 )*1.5 + 8) * ( Double(self.job.payRate) ) ) / 100)
            return pay
        } else {
            moneyShift()
        }
        return pay
    }
    
    func moneyShiftOTx2() -> Double {
        if duration > (60*60*12) {
            pay =  (round( 100 * (((duration / 3600) - 12 )*2 + (8) + (1.5*4) ) * ( Double(self.job.payRate) ) ) / 100)
            return pay
        } else if duration > (60*60*8) {
            moneyShiftOT()
        } else {
            moneyShift()
        }
        return pay
    }
    
    func sumUpDuration() {

        var timelogsArray = timelogs.allObjects as NSArray  //NSArray
        sortedTimelogs = (timelogsArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: "time", ascending: true)]) as! [Timelog]
        
        //SUM UP TOTAL
        let totalShiftTimeInterval = (sortedTimelogs.last!.time).timeIntervalSinceDate(sortedTimelogs.first!.time)
        duration = (totalShiftTimeInterval) - ( sumUpBreaktime() )
    }

    func sumUpBreaktime() -> Double{
            
        // TODO : Remove this factors
        var subtractor = 0
        var open = 0
        
        //SUMMING UP BREAKS!
        
        if self.status == 1 { //if open status, then need to add in subrator for possible open breaks
            
            if sortedTimelogs.count % 2 == 0  { //last entry = "start break" // currently on break
                subtractor = 1
            } else { //last entry = "end break"
                subtractor = 0
            }
            open = 0
        } else {
            open = 1 //last entry = "clocked out" so need to subtract 1 from array.count
        }
        
        if ((self.status != 0) && (sortedTimelogs.count > 1)) || ((self.status == 0) && (sortedTimelogs.count > 2)) {
            
            var breakCount: Int =  (( sortedTimelogs.count - open )/2)
            
            var tempTotalBreaktime = Double()
            var breakCountdown =  ( (breakCount) - subtractor) * 2
            totalBreaktime = Double()
            var partialBreaktime = Double()
            
            // NOTE : Calculates Break times for all the breakSets the user has in the shift
            if breakCount-subtractor >= 1 {
                for i in 1...(breakCount-subtractor) {
                    var endBreak = sortedTimelogs[breakCountdown].time
                    var startBreak = sortedTimelogs[breakCountdown-1].time
                    partialBreaktime = endBreak.timeIntervalSinceDate(startBreak)
                    tempTotalBreaktime = tempTotalBreaktime + partialBreaktime
                    breakCountdown = breakCountdown - 2
                }
            }
            totalBreaktime = tempTotalBreaktime
        }

        return totalBreaktime
    }
    
}