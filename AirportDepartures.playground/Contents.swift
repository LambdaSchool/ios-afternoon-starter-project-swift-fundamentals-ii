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
    case delayed = "Delayed"
    case landed = "Landed"
    case boarding = "Boarding"
}

struct Airport {
    var destination: String
}

struct Flight {
    var departureTime: Date?
    var terminal: String?
    var status: FlightStatus
    var airportDestination: Airport
}

class DepartureBoard {
    var departureFlights: [Flight]
    var currentAirport: String
    
    init(currentAirport: String = "JFK") {
        self.currentAirport = currentAirport
        departureFlights = []
    }
    
    func addFlight(departureFlight: [Flight]) {
        departureFlights.append(contentsOf: departureFlight)
    }
    
    func alertPassengers() {
        for flight in departureFlights {
            var terminalValue = ""
            var departingTimeValue = ""
            
            if let terminal = flight.terminal {
                terminalValue = terminal
            } else {
                terminalValue = "TBD"
            }
            
            if let time = flight.departureTime {
                departingTimeValue = String(describing: time)
            } else {
                departingTimeValue = "TBD"
            }
            
            
            switch flight.status {
            case .canceled:
                print("We're sorry your flight to \(flight.airportDestination.destination) was canceled, here is a $500 voucher")
            case .scheduled:
                print("Your flight to \(flight.airportDestination.destination) is scheduled to depart at \(departingTimeValue) from terminal: \(terminalValue)")
            case .boarding:
                print("Your flight is boarding, please head to terminal: \(terminalValue) immediately. The doors are closing soon.")
            case .delayed:
                print("Your flight has been delayed! Please stand by for a new departure time")
            case .landed:
                print("Your flight has landed! Thank you for flying with us today!")
            default:
                print("Your flight is en route to you \(flight.airportDestination.destination)")
            }
        }
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
var newFlight = Flight(departureTime: nil, terminal: nil, status: .canceled, airportDestination: Airport(destination: "LAX"))

var newFlightTwo = Flight(departureTime: Date(), terminal: nil, status: .enRoute, airportDestination: Airport(destination: "NRT"))

var newFlightThree = Flight(departureTime: Date(), terminal: "8", status: .landed, airportDestination: .init(destination: "YYZ"))

var departureBoard = DepartureBoard()

departureBoard.addFlight(departureFlight: [newFlight, newFlightTwo, newFlightThree])

//departureBoard.addFlight(departureFlight: newFlight)
//departureBoard.addFlight(departureFlight: newFlightTwo)
//departureBoard.addFlight(departureFlight: newFlightThree)

print(departureBoard.departureFlights.count)

//: ## 3. Create a free-standing function that can print the flight information from the `DepartureBoard`
//: a. Use the function signature: `printDepartures(departureBoard:)`
//:
//: b. Use a `for in` loop to iterate over each departure
//:
//: c. Make your `FlightStatus` enum conform to `String` so you can print the `rawValue` String values from the `enum`. See the [enum documentation](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html).
//:
//: d. Print out the current DepartureBoard you created using the function
//func printDepartures(departureBoard: DepartureBoard) {
//
//    for flight in 0..<departureBoard.departureFlights.count {
//        print(
//                """
//                \nFlight from \(departureBoard.currentAirport) to \(String(describing: departureBoard.departureFlights[flight].airportDestination.destination))
//                Status: \(departureBoard.departureFlights[flight].status.rawValue)
//                Terminal: \(String(describing: departureBoard.departureFlights[flight].terminal?.description))
//                Date of Departure: \(String(describing: departureBoard.departureFlights[flight].departureTime?.description))
//                """)
//    }
//}
//
//
//printDepartures(departureBoard: departureBoard)

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

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short


func printDepartures2(departureBoard: DepartureBoard) {
    for flight in 0..<departureBoard.departureFlights.count {
        var timeString = ""
        var terminalString = ""

        if let time = departureBoard.departureFlights[flight].departureTime {
            timeString = dateFormatter.string(from: time)
        } else {
            timeString = "N/A"
        }
        
        if let terminal = departureBoard.departureFlights[flight].terminal {
            terminalString = terminal
        } else {
            terminalString = "TBD"
        }
        
        if departureBoard.departureFlights[flight].status.rawValue == "Canceled" {
            print(
                """
                \nFlight from \(departureBoard.currentAirport) to \(String(describing: departureBoard.departureFlights[flight].airportDestination.destination))
                Status: \(departureBoard.departureFlights[flight].status.rawValue)
                Terminal: N/A
                Date of Departure: N/A
                """)
        } else if terminalString == "TBD" {
            print(
                """
                \nFlight from \(departureBoard.currentAirport) to \(String(describing: departureBoard.departureFlights[flight].airportDestination.destination))
                Status: \(departureBoard.departureFlights[flight].status.rawValue)
                Terminal: \(terminalString)
                Date of Departure: \(timeString)
                """)
        } else {
            print(
                """
                \nFlight from \(departureBoard.currentAirport) to \(String(describing: departureBoard.departureFlights[flight].airportDestination.destination))
                Status: \(departureBoard.departureFlights[flight].status.rawValue)
                Terminal: \(terminalString)
                Date of Departure: \(timeString)
                """)
        }
    }
}

printDepartures2(departureBoard: departureBoard)

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

departureBoard.alertPassengers()


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
// Unsure if step "d" is asking you to make 3 total passengers add up to $750 + $50 worth of checked bags + $200 worth of distance charges, or if it wants you to use the cost laid out for bags and miles to figure out the cost per traveler so the method returns a total of $750. Went with the latter but included a commented out line to execute the former.

func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
    var totalValue: Double = 0.0
    let bagCost: Double = Double(checkedBags) * 25
    let distanceCost: Double = Double(distance) * 0.10
    let travelerCost: Double = Double(travelers) * 166.67
//    let travelerCost: Double = Double(travelers) * 250
    
    totalValue = bagCost + distanceCost + travelerCost
    
    return totalValue
}

calculateAirfare(checkedBags: 2, distance: 2000, travelers: 3)

