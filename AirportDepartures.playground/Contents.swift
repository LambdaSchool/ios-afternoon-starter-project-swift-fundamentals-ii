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
    case boarding = "Boarding"
    case scheduled = "Scheduled"
    case cancelled = "Cancelled"
    case delayed = "Delayed"
}

struct Airport {
    let city: String
    let code: String
}

struct Flight {
    let airport: Airport
    let airline: String
    let number: String
    let departure: Date?
    let terminal: String?
    let flightStatus: FlightStatus
}

class DepartureBoard {
    var departures: [Flight]
    var currentAirport: Airport
    
    init(departures: [Flight] = [], currentAirport: Airport) {
        self.departures = departures
        self.currentAirport = currentAirport
    }
    
    func alertPassengers() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        for departure in departures {
            switch departure.flightStatus {
            case .boarding:
                let terminalString = "\(departure.terminal ?? "TBD")"
                print("Your flight is boarding, please head to terminal: \(terminalString) immediately. The doors are closing soon.")
            case .delayed:
                print("We are sorry but flight number \(departure.number) has been delayed.")
            case .cancelled:
                print("We're sorry your flight to \(departure.airport.city) was cancelled, here is a $500 voucher")
            case .scheduled:
                var timeString = ""
                var terminalString = ""
                if let terminal = departure.terminal {
                    terminalString = "\(terminal)"
                } else {
                    terminalString = "TBD"
                }
                
                if let time = departure.departure {
                    timeString = "\(dateFormatter.string(from: time))"
                } else {
                    timeString = "TBD"
                }
                print("Your flight to \(departure.airport.city) is scheduled to depart at \(timeString) from terminal: \(terminalString)")
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


let departureBoard = DepartureBoard(currentAirport: Airport(city: "Chicago", code: "ORD"))

if let date1 = DateComponents(calendar: .current, year: 2019, month: 12, day: 23, hour: 5, minute: 30).date {
    let flight1 = Flight(airport: Airport(city: "Boston", code: "BOS"), airline: "JetBlue", number: "B6 5921", departure: date1, terminal: "5", flightStatus: .delayed)
    departureBoard.departures.append(flight1)
}

let flight2 = Flight(airport: Airport(city: "Toronto", code: "YYZ"),airline: "American Airlines", number: "AA 3957", departure: nil, terminal: "8", flightStatus: .cancelled)
let flight3 = Flight(airport: Airport(city: "Anguilla", code: "AXA"),airline: "Presidential Aviation", number: "81", departure: Date(), terminal: nil, flightStatus: .scheduled)

departureBoard.departures.append(flight2)
departureBoard.departures.append(flight3)
//: ## 3. Create a free-standing function that can print the flight information from the `DepartureBoard`
//: a. Use the function signature: `printDepartures(departureBoard:)`
//:
//: b. Use a `for in` loop to iterate over each departure
//:
//: c. Make your `FlightStatus` enum conform to `String` so you can print the `rawValue` String values from the `enum`. See the [enum documentation](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html).
//:
//: d. Print out the current DepartureBoard you created using the function
func printDepartures(departureBoard: DepartureBoard) {
    for departure in departureBoard.departures {
        print("Destination: \(departure.airport.city) Airline: \(departure.airline) Flight: \(departure.number) Departure Time: \(String(describing: departure.departure)) Terminal: \(String(describing: departure.terminal)) Status: \(departure.flightStatus.rawValue)")
    }
}

print("printDepartures Function Call")
printDepartures(departureBoard: departureBoard)
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
func printDepartures2(departureBoard: DepartureBoard) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    for departure in departureBoard.departures {
        if let terminal = departure.terminal {
            if let time = departure.departure {
                print("Destination: \(departure.airport.city) Airline: \(departure.airline) Flight: \(departure.number) Departure Time: \(dateFormatter.string(from: time)) Terminal: \(terminal) Status: \(departure.flightStatus.rawValue)")
            } else {
                print("Destination: \(departure.airport.city) Airline: \(departure.airline) Flight: \(departure.number) Departure Time: Terminal: \(terminal) Status: \(departure.flightStatus.rawValue)")
            }
        } else {
            if let time = departure.departure {
                print("Destination: \(departure.airport.city) Airline: \(departure.airline) Flight: \(departure.number) Departure Time: \(dateFormatter.string(from: time)) Terminal: Status: \(departure.flightStatus.rawValue)")
            }
        }
    }
}
print("\nprintDepartures2 Function Call")
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
print("\nalertPassengers")
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
