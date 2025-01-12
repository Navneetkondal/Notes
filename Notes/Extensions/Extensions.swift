//// 	 
//	Extensions.swift
//	Notes
//
//	Created By Altametrics on 17/11/24
//	

//	Hubworks: https://www.hubworks.com
//


import Foundation

extension String{
    func removeSpaces() -> String{
        self.trimmingCharacters(in: .whitespaces)
    }
}

extension Double {
    func getDateFromTimeInterval() -> Date {
         Date(timeIntervalSince1970: self)
    }
}

extension Date{
    func getDateStringFromUTC(_ format: String = "MMM dd YYYY hh:mm a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
