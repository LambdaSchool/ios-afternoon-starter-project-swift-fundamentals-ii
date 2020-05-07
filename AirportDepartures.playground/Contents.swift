import UIKit


//: ## 1. Create custom types to represent an Airport Departures display
//: ![Airport Departures](matthew-smith-5934-unsplash.jpg)
//: Look at data from [Departures at JFK Airport in NYC](https://www.airport-jfk.com/departures.php) for reference.
//:
//: a. Use an `enum` type for the FlightStatus (En Route, Scheduled, Canceled, Delayed, etc.)
//:
//: b. Use a struct to represent an `Airport` (Destination or Arrival)
//:
//: c. Use a struct to represent a `Flight`.
//:
//: d. Use a `Date?` for the departure time since it may be canceled.
//:
//: e. Use a `String?` for the Terminal, since it may not be set yet (i.e.: waiting to arrive on time)
//:
//: f. Use a class to represent a `DepartureBoard` with a list of departure flights, and the current airport
enum FlightStatus: String {
    
    case enRoute = "En Route"
    case scheduled = "Scheduled"
    case canceled = "Canceled"
    
}

struct AirPort {
    
    var name: String
    
}

struct Flight {
    
    let date: Date
    let terminal: String?
    let departureTime: Date?
    let arrivalTime: Date?
    let destination: String
    let flightID: Int
    let flightStatus: FlightStatus
    let startingAirPort: AirPort
    
}

class DepartureBoard {
    
    var flights: [Flight] = []
    var currentAirPort: AirPort
    init(flights: [Flight], currentAirPort: AirPort) {
        
        self.flights = flights
        self.currentAirPort = currentAirPort
    }
}


//: ## 2. Create 3 flights and add them to a departure board
//: a. For the departure time, use `Date()` for the current time
//:
//: b. Use the Array `append()` method to add `Flight`'s
//:
//: c. Make one of the flights `.canceled` with a `nil` departure time
//:
//: d. Make one of the flights have a `nil` terminal because it has not been decided yet.
//:
//: e. Stretch: Look at the API for [`DateComponents`](https://developer.apple.com/documentation/foundation/datecomponents?language=objc) for creating a specific time
let lhr = AirPort(name: "LHR")
let seatac = AirPort(name: "SEA")
let hiroshimaAirPort = AirPort(name: "JBH")
let tokyoIntAir = AirPort(name: "JTT")
let seattleAirPort = AirPort(name: "BFI")

let flight1 = Flight(date: Date(), terminal: "A", departureTime: Date(), arrivalTime: Date(), destination: "Hirsoshima, Japan", flightID: 763, flightStatus: FlightStatus.scheduled, startingAirPort: lhr)

let flight2 = Flight(date: Date(), terminal: "B", departureTime: nil, arrivalTime: nil, destination: "Tokyo, Japan", flightID: 923, flightStatus: FlightStatus.canceled, startingAirPort: seattleAirPort)

let flight3 = Flight(date: Date(), terminal: nil, departureTime: Date(), arrivalTime: Date(), destination: "London", flightID: 13, flightStatus: FlightStatus.enRoute, startingAirPort: seatac)

var flights: [Flight] = []
flights.append(flight1)
flights.append(flight2)
flights.append(flight3)

let panAm = DepartureBoard(flights: flights, currentAirPort: seatac)
//: ## 3. Create a free-standing function that can print the flight information from the `DepartureBoard`
//: a. Use the function signature: `printDepartures(departureBoard:)`
//:
//: b. Use a `for in` loop to iterate over each departure
//:
//: c. Make your `FlightStatus` enum conform to `String` so you can print the `rawValue` String values from the `enum`. See the [enum documentation](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html).
//:
//: d. Print out the current DepartureBoard you created using the function
func printDepartures() {
    for flight in flights {
        print(flight.flightStatus.rawValue)
    }
}
printDepartures()


//: ## 4. Make a second function to print print an empty string if the `departureTime` is nil
//: a. Createa new `printDepartures2(departureBoard:)` or modify the previous function
//:
//: b. Use optional binding to unwrap any optional values, use string interpolation to turn a non-optional date into a String
//:
//: c. Call the new or udpated function. It should not print `Optional(2019-05-30 17:09:20 +0000)` for departureTime or for the Terminal.
//:
//: d. Stretch: Format the time string so it displays only the time using a [`DateFormatter`](https://developer.apple.com/documentation/foundation/dateformatter) look at the `dateStyle` (none), `timeStyle` (short) and the `string(from:)` method
//:
//: e. Your output should look like:
//:
//:     Destination: Los Angeles Airline: Delta Air Lines Flight: KL 6966 Departure Time:  Terminal: 4 Status: Canceled
//:     Destination: Rochester Airline: Jet Blue Airways Flight: B6 586 Departure Time: 1:26 PM Terminal:  Status: Scheduled
//:     Destination: Boston Airline: KLM Flight: KL 6966 Departure Time: 1:26 PM Terminal: 4 Status: Scheduled
func printDepartures2() {
    for flight in flights {
        
        if let unwrappedTerminal =  flight.terminal, let unwrappedDepartureTime = flight.departureTime, let unwrappedArrivalTime = flight.arrivalTime {
            
            print("Destination: \(flight.destination) AirLine: PanAm Flight: \(flight.flightID) Departure Time: \(unwrappedDepartureTime) Arrival Time: \(unwrappedArrivalTime) Terminal: \(unwrappedTerminal) Status: \(flight.flightStatus.rawValue)")
            
        } else if flight.flightStatus == FlightStatus.enRoute, let unwrappedArrivalTime = flight.arrivalTime {
            
            print("Destination: \(flight.destination) AirLine: PanAm Flight: \(flight.flightID) Departure Time: Sorry, Your flight has left Arrival Time: \(unwrappedArrivalTime) Terminal: Sorry, Your flight had departed Status: \(flight.flightStatus.rawValue)")
            
        } else {
            
            print("Destination: \(flight.destination) AirLine: PanAm Flight: \(flight.flightID) Departure Time: Sorry, Your flight ha been canceled. Arrival Time: Sorry, Your flight has been canceled. Terminal: Sorry, Your flight has been canceled Status: \(flight.flightStatus.rawValue)")
        }
    }
}

printDepartures2()
//: ## 5. Add an instance method to your `DepatureBoard` class (above) that can send an alert message to all passengers about their upcoming flight. Loop through the flights and use a `switch` on the flight status variable.
//: a. If the flight is canceled print out: "We're sorry your flight to \(city) was canceled, here is a $500 voucher"
//:
//: b. If the flight is scheduled print out: "Your flight to \(city) is scheduled to depart at \(time) from terminal: \(terminal)"
//:
//: c. If their flight is boarding print out: "Your flight is boarding, please head to terminal: \(terminal) immediately. The doors are closing soon."
//:
//: d. If the `departureTime` or `terminal` are optional, use "TBD" instead of a blank String
//:
//: e. If you have any other cases to handle please print out appropriate messages
//:
//: d. Call the `alertPassengers()` function on your `DepartureBoard` object below
//:
//: f. Stretch: Display a custom message if the `terminal` is `nil`, tell the traveler to see the nearest information desk for more details.
extension DepartureBoard {
    func alertPassengers() {
        
        for flight in flights {
            
            switch flight.flightStatus {
                
            case .canceled:
                print("We are very sorry to inform you that your flight to \(flight.destination) was canceled. Please head to Customer Affairs to pick up a $500 voucher as compensation.")
                
            case .enRoute:
                print("Your flight to \(flight.destination) is  already gone. We are very sorry for any inconvenience this may or may not have caused.")
                
            case .scheduled:
                if let unwrappedDepartureTime = flight.departureTime, let unwrappedTerminal = flight.terminal {
                print("Your flight to \(flight.destination) is boarding and scheduled to leave at \(unwrappedDepartureTime). Please head to terminal \(unwrappedTerminal) immediately.")
                }
                
            default:
                print("Developer says hi. Also, something's broken here.")
            }
        }
    }
}
panAm.alertPassengers()


//: ## 6. Create a free-standing function to calculate your total airfair for checked bags and destination
//: Use the method signature, and return the airfare as a `Double`
//:
//:     func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
//:     }
//:
//: a. Each bag costs $25
//:
//: b. Each mile costs $0.10
//:
//: c. Multiply the ticket cost by the number of travelers
//:
//: d. Call the function with a variety of inputs (2 bags, 2000 miles, 3 travelers = $750)
//:
//: e. Make sure to cast the numbers to the appropriate types so you calculate the correct airfare
//:
//: f. Stretch: Use a [`NumberFormatter`](https://developer.apple.com/documentation/foundation/numberformatter) with the `currencyStyle` to format the amount in US dollars.



