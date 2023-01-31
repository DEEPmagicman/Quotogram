//
//  ContentView.swift
//  Quotogram
//
//  Created by MAC on 19/03/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var abcd = Keyur_CarbonIntensity()
    
    var body: some View {
        Home()
            .onAppear {
                
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class Keyur_CarbonIntensity: ObservableObject{
    @Published var shortname: String = String()
    @Published var forecast: String = String()
//    func getData() {
    init () {
        let jsonUrlString = "https://api.carbonintensity.org.uk/regional/postcode/SE7"
        
        guard let url = URL(string: jsonUrlString) else{
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                print(json)
            } catch {
                print("didnt work")
            }
        }.resume()
        
    }
    
    func getRequired(json: [String: Any]?) {
//        let json = json
//        ((json?["data"] as? NSArray)?.firstObject as? NSDictionary)?["shortname"]
//        (((((json?["data"] as? NSArray)?.firstObject as? NSDictionary)?["data"] as? NSArray)?.firstObject as? NSDictionary)?["intensity"] as? NSDictionary)?["forecast"]
        if let json = json, let data = json["data"] as? [[String: Any]], let firstData = data.first,   let shortName = firstData["shortname"] as? String {
            print(shortName)
        }
    }
}
