//
//  Constants.swift
//  Penny
//
//  Created by Alan S Mathew on 19/07/22.
//

import Foundation
import UIKit
import CoreLocation

let now = Date()
var totalAmount = 0.0
var totalIncome = 0.0
var totalExpense = 0.0

var selectedCatogery = ""

//database data comes here
var databaseData:[Trans]?
var categoryData : [CategoryTable]?

struct Constants {
    // colors
    let greenColor = UIColor(red: 0.00, green: 0.45, blue: 0.39, alpha: 1.00)
    let redColor = UIColor.red
    
    let menuItems = ["Main currency settings","Passcode","Info","Feedback"]
    let catogeries = ["Food", "Grocery", "Gas","Medicines","Shopping"]
}

var defaultCurrency = "$"
var defaultCurrencyIndex = 18

let currencyCounrty = [
                       "Albania Lek",
                       "Afghanistan Afghani",
                       "Argentina Peso",
                       "Aruba Guilder",
                       "Australia Dollar",
                       "Azerbaijan Manat",
                       "Bahamas Dollar",
                       "Barbados Dollar",
                       "Belarus Ruble",
                       "Belize Dollar",
                       "Bermuda Dollar",
                       "Bolivia Bolíviano",
                       "Bosnia and Herzegovina Convertible Mark",
                       "Botswana Pula",
                       "Bulgaria Lev",
                       "Brazil Real",
                       "Brunei Darussalam Dollar",
                       "Cambodia Riel",
                       "Canada Dollar",
                       "Cayman Islands Dollar",
                       "Chile Peso",
                       "China Yuan Renminbi",
                       "Colombia Peso",
                       "Costa Rica Colon",
                       "Croatia Kuna",
                       "Cuba Peso",
                       "Czech Republic Koruna",
                       "Denmark Krone",
                       "Dominican Republic Peso",
                       "East Caribbean Dollar",
                       "Egypt Pound",
                       "El Salvador Colon",
                       "Euro Member Countries",
                       "Falkland Islands (Malvinas) Pound",
                       "Fiji Dollar",
                       "Ghana Cedi",
                       "Gibraltar Pound",
                       "Guatemala Quetzal",
                       "Guernsey Pound",
                       "Guyana Dollar",
                       "Honduras Lempira",
                       "Hong Kong Dollar",
                       "Hungary Forint",
                       "Iceland Krona",
                       "India Rupee",
                       "Indonesia Rupiah",
                       "Iran Rial",
                       "Isle of Man Pound",
                       "Israel Shekel",
                       "Jamaica Dollar",
                       "Japan Yen",
                       "Jersey Pound",
                       "Kazakhstan Tenge",
                       "Korea (North) Won",
                       "Korea (South) Won",
                       "Kyrgyzstan Som",
                       "Laos Kip",
                       "Lebanon Pound",
                       "Liberia Dollar",
                       "Macedonia Denar",
                       "Malaysia Ringgit",
                       "Mauritius Rupee",
                       "Mexico Peso",
                       "Mongolia Tughrik",
                       "Moroccan-dirham",
                       "Mozambique Metical",
                       "Namibia Dollar",
                       "Nepal Rupee",
                       "Netherlands Antilles Guilder",
                       "New Zealand Dollar",
                       "Nicaragua Cordoba",
                       "Nigeria Naira",
                       "Norway Krone",
                       "Oman Rial",
                       "Pakistan Rupee",
                       "Panama Balboa",
                       "Paraguay Guarani",
                       "Peru Sol",
                       "Philippines Peso",
                       "Poland Zloty",
                       "Qatar Riyal",
                       "Romania Leu",
                       "Russia Ruble",
                       "Saint Helena Pound",
                       "Saudi Arabia Riyal",
                       "Serbia Dinar",
                       "Seychelles Rupee",
                       "Singapore Dollar",
                       "Solomon Islands Dollar",
                       "Somalia Shilling",
                       "South Korean Won",
                       "South Africa Rand",
                       "Sri Lanka Rupee",
                       "Sweden Krona",
                       "Switzerland Franc",
                       "Suriname Dollar",
                       "Syria Pound",
                       "Taiwan New Dollar",
                       "Thailand Baht",
                       "Trinidad and Tobago Dollar",
                       "Turkey Lira",
                       "Tuvalu Dollar",
                       "Ukraine Hryvnia",
                       "UAE-Dirham",
                       "United Kingdom Pound",
                       "United States Dollar",
                       "Uruguay Peso",
                       "Uzbekistan Som",
                       "Venezuela Bolívar",
                       "Viet Nam Dong",
                       "Yemen Rial",
                       "Zimbabwe Dollar"
]

let currencySymbol = [
    "Lek",
                "؋",
                "$",
                "ƒ",
                "$",
                "₼",
                "$",
                "$",
                "Br",
                "BZ$",
                "$",
                "$b",
                "KM",
                "P",
                "лв",
                "R$",
                "$",
                "៛",
                "$",
                "$",
                "$",
                "¥",
                "$",
                "₡",
                "kn",
                "₱",
                "Kč",
                "kr",
                "RD$",
                "$",
                "£",
                "$",
                "€",
                "£",
                "$",
                "¢",
                "£",
                "Q",
                "£",
                "$",
                "L",
                "$",
                "Ft",
                "kr",
                "₹",
                "Rp",
                "﷼",
                "£",
                "₪",
                "J$",
                "¥",
                "£",
                "лв",
                "₩",
                "₩",
                "лв",
                "₭",
                "£",
                "$",
                "ден",
                "RM",
                "₨",
                "$",
                "₮",
                "د.إ",
                "MT",
                "$",
                "₨",
                "ƒ",
                "$",
                "C$",
                "₦",
                "kr",
                "﷼",
                "₨",
                "B/.",
                "Gs",
                "S/.",
                "₱",
                "zł",
                "﷼",
                "lei",
                "₽",
                "£",
                "﷼",
                "Дин.",
                "₨",
                "$",
                "$",
                "S",
                "₩",
                "R",
                "₨",
                "kr",
                "CHF",
                "$",
                "£",
                "NT$",
                "฿",
                "TT$",
                "₺",
                "$",
                "₴",
                "د.إ",
                "£",
                "$",
                "$U",
                "лв",
                "Bs",
                "₫",
                "﷼",
                "Z$"
    ]
