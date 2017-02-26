//
//  ArticleParser.swift
//  Hello
//
//  Created by Marin Bencevic on 17/01/17.
//
//

import Foundation

private let inputDateFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateFormat = "dd-MM-yyyy"
	return formatter
}()


private let outputDateFormatter: DateFormatter = {
	let formatter = DateFormatter()
	formatter.dateFormat = "MMM dd yyyy"
	return formatter
}()

struct ArticleParser {

	func parse(articleFile contents: String, filePath: String, fileName: String) throws -> Article? {

		guard contents.hasPrefix("{") else {
			return nil
		}

		var contents = contents

		// JSON metadata

		let range = contents.range(of: "}")!
		let indexOfJsonEnd = contents.distance(from: contents.startIndex, to: range.upperBound)

		let json = contents.substring(to: contents.index(contents.startIndex, offsetBy: indexOfJsonEnd))
		let jsonData = json.data(using: .utf8)!

		let parsedJSON = try JSONSerialization.jsonObject(with: jsonData, options: [JSONSerialization.ReadingOptions.allowFragments]) as! [String: Any]

		let dateString = parsedJSON["date"] as! String
		let date = inputDateFormatter.date(from: dateString)!

		let formattedDate = outputDateFormatter.string(from: date)
		let title = parsedJSON["title"] as! String

		let isFeatured = parsedJSON["isFeatured"] as? Bool ?? false


		// contents

		contents.removeSubrange(contents.startIndex...contents.index(contents.startIndex, offsetBy: indexOfJsonEnd))


		// url name

		let urlName = title
			.components(separatedBy: " ")
            .map { component in
                
                let characterSet = CharacterSet.alphanumerics.inverted
                
                return String(component.characters
                    .filter {
                        String($0).rangeOfCharacter(from: characterSet) == nil
                    }
                )
            }
			.joined(separator: "-")
			.lowercased()

		return Article(title: title, filePath: filePath, urlName: urlName, date: date, formattedDate: formattedDate, content: contents, isFeatured: isFeatured)

	}

}
