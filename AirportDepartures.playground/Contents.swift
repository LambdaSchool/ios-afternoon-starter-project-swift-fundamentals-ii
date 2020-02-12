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
    case enRouteDelayed = "En Route - Delayed"
    case scheduled = "Scheduled"
    case scheduledDelayed = "Scheduled - Delayed"
    case landed = "Landed"
    case landedDelayed = "Landed - Delayed"
    case diverted = "Diverted"
    case canceled = "Canceled"
    case boarding = "Boarding"
}

struct Airport {
    let name: String
    let iataCode: String
}

struct Flight {
    let destination: Airport
    let airline: String
    let code: String
    var departureTime: Date?
    var terminal: String?
    var status: FlightStatus
}

class DepartureBoard {
    var flights: [Flight]
    let airport: Airport
    
    init(airport: Airport) {
        self.airport = airport
        self.flights = []
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
let jfk = Airport(name: "J.F.K. International - New York", iataCode: "JFK")
let atl = Airport(name: "Atlanta", iataCode: "ATL")
let lax = Airport(name: "Los Angeles", iataCode: "LAX")
let dfw = Airport(name: "Dallas", iataCode: "DFW")

let jfkDepartureBoard = DepartureBoard(airport: jfk)

var flight1 = Flight(destination: atl,
                     airline: "Delta Air Lines",
                     code: "DL2341",
                     departureTime: DateComponents(calendar: .current, year: 2020, month: 02, day: 10, hour: 6, minute: 30).date!,
                     terminal: "4",
                     status: .boarding)
var flight2 = Flight(destination: lax,
                     airline: "American Air Lines",
                     code: "AA171",
                     departureTime: nil,
                     terminal: "4",
                     status: .canceled)
var flight3 = Flight(destination: dfw,
                     airline: "Gulf Air",
                     code: "GF4294",
                     departureTime: DateComponents(calendar: .current, year: 2020, month: 02, day: 10, hour: 13).date!,
                     terminal: nil,
                     status: .scheduledDelayed)

jfkDepartureBoard.flights.append(contentsOf: [flight1, flight2, flight3])



//: ## 3. Create a free-standing function that can print the flight information from the `DepartureBoard`
//: a. Use the function signature: `printDepartures(departureBoard:)`
//:
//: b. Use a `for in` loop to iterate over each departure
//:
//: c. Make your `FlightStatus` enum conform to `String` so you can print the `rawValue` String values from the `enum`. See the [enum documentation](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html).
//:
//: d. Print out the current DepartureBoard you created using the function
let formatter = DateFormatter()
formatter.dateStyle = .none

formatter.timeStyle = .short

func printDepartures(departureBoard: DepartureBoard) {
    print("------- \(departureBoard.airport.name) Departure Board ------- \n")
    
    for flight in departureBoard.flights {
        
        let departureTime = flight.departureTime != nil ? formatter.string(from: flight.departureTime!) : ""
        
        print(
            "Flight: \(flight.code)\n",
            "Destination: \(flight.destination.name) (\(flight.destination.iataCode))\n",
            "Airline: \(flight.airline)\n",
            "Departure: \(departureTime)\n",
            "Terminal: \(flight.terminal ?? "")\n",
            "Status: \(flight.status.rawValue)\n\n")
    }
    print("-----------------------------------------------------------------")
}

printDepartures(departureBoard: jfkDepartureBoard)

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
            let departureTime = flight.departureTime != nil ? formatter.string(from: flight.departureTime!) : "TBD"
            
            print("\nAttention passengers of flight \(flight.code), traveling with \(flight.airline):")
            
            guard let terminal = flight.terminal else {
                print("You should travel to the nearest information desk for details regarding your flight.")
                break
            }
            
            switch flight.status {
            case .canceled:
                print("We're sorry your flight to \(flight.destination.name) was canceled, here is a $500 voucher.")
            case .scheduled:
                print("Your flight to \(flight.destination.name) is scheduled to depart at \(departureTime) from terminal: \(terminal)")
            case .boarding:
                print("Your flight is boarding, please head to terminal: \(terminal) immediately. The doors are closing soon.")
            default:
                break
            }
        }
    }
}

jfkDepartureBoard.alertPassengers()



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
func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> String {
    var total: Double = 0
    total += Double(checkedBags) * 25.0
    total += Double(distance) * 0.1
    total *= Double(travelers)
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    
    return formatter.string(for: total) ?? ""
}

print("\n")
print("Your total airfare is: " + calculateAirfare(checkedBags: 2, distance: 2000, travelers: 3))
print("\n")
print("Your total airfare is: " + calculateAirfare(checkedBags: 4, distance: 1300, travelers: 5))
print("\n")
print("Your total airfare is: " + calculateAirfare(checkedBags: 1, distance: 570, travelers: 1))
print("\n")
print("Your total airfare is: " + calculateAirfare(checkedBags: -3, distance: -1570, travelers: -2))
