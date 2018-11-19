//
//  PAddressViewController.m
//  KES
//
//  Created by Piglet on 05.10.18.
//  Copyright © 2018 matata. All rights reserved.
//

#import "PAddressViewController.h"

@interface PAddressViewController ()

@end

@implementation PAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    heightTopOfParentView = 139;
    [self setButtonsView];
    [self setUI];
    
    objWebServices = [WebServices sharedInstance];
    objWebServices.delegate = self;
    arrCountries = @[
                      @{
                          @"name": @"United States",
                          @"code": @"US"
                          },
                      @{
                          @"name": @"United Kingdom",
                          @"code": @"GB"
                          },
                      @{
                          @"name": @"Canada",
                          @"code": @"CA"
                          },
                      @{
                          @"name": @"Nigeria",
                          @"code": @"NG"
                          },
                      @{
                          @"name": @"Afghanistan",
                          @"code": @"AF"
                          },
                      @{
                          @"name": @"Aland Islands",
                          @"code": @"AX"
                          },
                      @{
                          @"name": @"Albania",
                          @"code": @"AL"
                          },
                      @{
                          @"name": @"Algeria",
                          @"code": @"DZ"
                          },
                      @{
                          @"name": @"AmericanSamoa",
                          @"code": @"AS"
                          },
                      @{
                          @"name": @"Andorra",
                          @"code": @"AD"
                          },
                      @{
                          @"name": @"Angola",
                          @"code": @"AO"
                          },
                      @{
                          @"name": @"Anguilla",
                          @"code": @"AI"
                          },
                      @{
                          @"name": @"Antarctica",
                          @"code": @"AQ"
                          },
                      @{
                          @"name": @"Antigua and Barbuda",
                          @"code": @"AG"
                          },
                      @{
                          @"name": @"Argentina",
                          @"code": @"AR"
                          },
                      @{
                          @"name": @"Armenia",
                          @"code": @"AM"
                          },
                      @{
                          @"name": @"Aruba",
                          @"code": @"AW"
                          },
                      @{
                          @"name": @"Australia",
                          @"code": @"AU"
                          },
                      @{
                          @"name": @"Austria",
                          @"code": @"AT"
                          },
                      @{
                          @"name": @"Azerbaijan",
                          @"code": @"AZ"
                          },
                      @{
                          @"name": @"Bahamas",
                          @"code": @"BS"
                          },
                      @{
                          @"name": @"Bahrain",
                          @"code": @"BH"
                          },
                      @{
                          @"name": @"Bangladesh",
                          @"code": @"BD"
                          },
                      @{
                          @"name": @"Barbados",
                          @"code": @"BB"
                          },
                      @{
                          @"name": @"Belarus",
                          @"code": @"BY"
                          },
                      @{
                          @"name": @"Belgium",
                          @"code": @"BE"
                          },
                      @{
                          @"name": @"Belize",
                          @"code": @"BZ"
                          },
                      @{
                          @"name": @"Benin",
                          @"code": @"BJ"
                          },
                      @{
                          @"name": @"Bermuda",
                          @"code": @"BM"
                          },
                      @{
                          @"name": @"Bhutan",
                          @"code": @"BT"
                          },
                      @{
                          @"name": @"Bolivia, Plurinational State of",
                          @"code": @"BO"
                          },
                      @{
                          @"name": @"Bosnia and Herzegovina",
                          @"code": @"BA"
                          },
                      @{
                          @"name": @"Botswana",
                          @"code": @"BW"
                          },
                      @{
                          @"name": @"Brazil",
                          @"code": @"BR"
                          },
                      @{
                          @"name": @"British Indian Ocean Territory",
                          @"code": @"IO"
                          },
                      @{
                          @"name": @"Brunei Darussalam",
                          @"code": @"BN"
                          },
                      @{
                          @"name": @"Bulgaria",
                          @"code": @"BG"
                          },
                      @{
                          @"name": @"Burkina Faso",
                          @"code": @"BF"
                          },
                      @{
                          @"name": @"Burundi",
                          @"code": @"BI"
                          },
                      @{
                          @"name": @"Cambodia",
                          @"code": @"KH"
                          },
                      @{
                          @"name": @"Cameroon",
                          @"code": @"CM"
                          },
                      @{
                          @"name": @"Cape Verde",
                          @"code": @"CV"
                          },
                      @{
                          @"name": @"Cayman Islands",
                          @"code": @"KY"
                          },
                      @{
                          @"name": @"Central African Republic",
                          @"code": @"CF"
                          },
                      @{
                          @"name": @"Chad",
                          @"code": @"TD"
                          },
                      @{
                          @"name": @"Chile",
                          @"code": @"CL"
                          },
                      @{
                          @"name": @"China",
                          @"code": @"CN"
                          },
                      @{
                          @"name": @"Christmas Island",
                          @"code": @"CX"
                          },
                      @{
                          @"name": @"Cocos (Keeling) Islands",
                          @"code": @"CC"
                          },
                      @{
                          @"name": @"Colombia",
                          @"code": @"CO"
                          },
                      @{
                          @"name": @"Comoros",
                          @"code": @"KM"
                          },
                      @{
                          @"name": @"Congo",
                          @"code": @"CG"
                          },
                      @{
                          @"name": @"Congo, The Democratic Republic of the Congo",
                          @"code": @"CD"
                          },
                      @{
                          @"name": @"Cook Islands",
                          @"code": @"CK"
                          },
                      @{
                          @"name": @"Costa Rica",
                          @"code": @"CR"
                          },
                      @{
                          @"name": @"Cote d'Ivoire",
                          @"code": @"CI"
                          },
                      @{
                          @"name": @"Croatia",
                          @"code": @"HR"
                          },
                      @{
                          @"name": @"Cuba",
                          @"code": @"CU"
                          },
                      @{
                          @"name": @"Cyprus",
                          @"code": @"CY"
                          },
                      @{
                          @"name": @"Czech Republic",
                          @"code": @"CZ"
                          },
                      @{
                          @"name": @"Denmark",
                          @"code": @"DK"
                          },
                      @{
                          @"name": @"Djibouti",
                          @"code": @"DJ"
                          },
                      @{
                          @"name": @"Dominica",
                          @"code": @"DM"
                          },
                      @{
                          @"name": @"Dominican Republic",
                          @"code": @"DO"
                          },
                      @{
                          @"name": @"Ecuador",
                          @"code": @"EC"
                          },
                      @{
                          @"name": @"Egypt",
                          @"code": @"EG"
                          },
                      @{
                          @"name": @"El Salvador",
                          @"code": @"SV"
                          },
                      @{
                          @"name": @"Equatorial Guinea",
                          @"code": @"GQ"
                          },
                      @{
                          @"name": @"Eritrea",
                          @"code": @"ER"
                          },
                      @{
                          @"name": @"Estonia",
                          @"code": @"EE"
                          },
                      @{
                          @"name": @"Ethiopia",
                          @"code": @"ET"
                          },
                      @{
                          @"name": @"Falkland Islands (Malvinas)",
                          @"code": @"FK"
                          },
                      @{
                          @"name": @"Faroe Islands",
                          @"code": @"FO"
                          },
                      @{
                          @"name": @"Fiji",
                          @"code": @"FJ"
                          },
                      @{
                          @"name": @"Finland",
                          @"code": @"FI"
                          },
                      @{
                          @"name": @"France",
                          @"code": @"FR"
                          },
                      @{
                          @"name": @"French Guiana",
                          @"code": @"GF"
                          },
                      @{
                          @"name": @"French Polynesia",
                          @"code": @"PF"
                          },
                      @{
                          @"name": @"Gabon",
                          @"code": @"GA"
                          },
                      @{
                          @"name": @"Gambia",
                          @"code": @"GM"
                          },
                      @{
                          @"name": @"Georgia",
                          @"code": @"GE"
                          },
                      @{
                          @"name": @"Germany",
                          @"code": @"DE"
                          },
                      @{
                          @"name": @"Ghana",
                          @"code": @"GH"
                          },
                      @{
                          @"name": @"Gibraltar",
                          @"code": @"GI"
                          },
                      @{
                          @"name": @"Greece",
                          @"code": @"GR"
                          },
                      @{
                          @"name": @"Greenland",
                          @"code": @"GL"
                          },
                      @{
                          @"name": @"Grenada",
                          @"code": @"GD"
                          },
                      @{
                          @"name": @"Guadeloupe",
                          @"code": @"GP"
                          },
                      @{
                          @"name": @"Guam",
                          @"code": @"GU"
                          },
                      @{
                          @"name": @"Guatemala",
                          @"code": @"GT"
                          },
                      @{
                          @"name": @"Guernsey",
                          @"code": @"GG"
                          },
                      @{
                          @"name": @"Guinea",
                          @"code": @"GN"
                          },
                      @{
                          @"name": @"Guinea-Bissau",
                          @"code": @"GW"
                          },
                      @{
                          @"name": @"Guyana",
                          @"code": @"GY"
                          },
                      @{
                          @"name": @"Haiti",
                          @"code": @"HT"
                          },
                      @{
                          @"name": @"Holy See (Vatican City State)",
                          @"code": @"VA"
                          },
                      @{
                          @"name": @"Honduras",
                          @"code": @"HN"
                          },
                      @{
                          @"name": @"Hong Kong",
                          @"code": @"HK"
                          },
                      @{
                          @"name": @"Hungary",
                          @"code": @"HU"
                          },
                      @{
                          @"name": @"Iceland",
                          @"code": @"IS"
                          },
                      @{
                          @"name": @"India",
                          @"code": @"IN"
                          },
                      @{
                          @"name": @"Indonesia",
                          @"code": @"ID"
                          },
                      @{
                          @"name": @"Iran, Islamic Republic of Persian Gulf",
                          @"code": @"IR"
                          },
                      @{
                          @"name": @"Iraq",
                          @"code": @"IQ"
                          },
                      @{
                          @"name": @"Ireland",
                          @"code": @"IE"
                          },
                      @{
                          @"name": @"Isle of Man",
                          @"code": @"IM"
                          },
                      @{
                          @"name": @"Israel",
                          @"code": @"IL"
                          },
                      @{
                          @"name": @"Italy",
                          @"code": @"IT"
                          },
                      @{
                          @"name": @"Jamaica",
                          @"code": @"JM"
                          },
                      @{
                          @"name": @"Japan",
                          @"code": @"JP"
                          },
                      @{
                          @"name": @"Jersey",
                          @"code": @"JE"
                          },
                      @{
                          @"name": @"Jordan",
                          @"code": @"JO"
                          },
                      @{
                          @"name": @"Kazakhstan",
                          @"code": @"KZ"
                          },
                      @{
                          @"name": @"Kenya",
                          @"code": @"KE"
                          },
                      @{
                          @"name": @"Kiribati",
                          @"code": @"KI"
                          },
                      @{
                          @"name": @"Korea, Democratic People's Republic of Korea",
                          @"code": @"KP"
                          },
                      @{
                          @"name": @"Korea, Republic of South Korea",
                          @"code": @"KR"
                          },
                      @{
                          @"name": @"Kuwait",
                          @"code": @"KW"
                          },
                      @{
                          @"name": @"Kyrgyzstan",
                          @"code": @"KG"
                          },
                      @{
                          @"name": @"Laos",
                          @"code": @"LA"
                          },
                      @{
                          @"name": @"Latvia",
                          @"code": @"LV"
                          },
                      @{
                          @"name": @"Lebanon",
                          @"code": @"LB"
                          },
                      @{
                          @"name": @"Lesotho",
                          @"code": @"LS"
                          },
                      @{
                          @"name": @"Liberia",
                          @"code": @"LR"
                          },
                      @{
                          @"name": @"Libyan Arab Jamahiriya",
                          @"code": @"LY"
                          },
                      @{
                          @"name": @"Liechtenstein",
                          @"code": @"LI"
                          },
                      @{
                          @"name": @"Lithuania",
                          @"code": @"LT"
                          },
                      @{
                          @"name": @"Luxembourg",
                          @"code": @"LU"
                          },
                      @{
                          @"name": @"Macao",
                          @"code": @"MO"
                          },
                      @{
                          @"name": @"Macedonia",
                          @"code": @"MK"
                          },
                      @{
                          @"name": @"Madagascar",
                          @"code": @"MG"
                          },
                      @{
                          @"name": @"Malawi",
                          @"code": @"MW"
                          },
                      @{
                          @"name": @"Malaysia",
                          @"code": @"MY"
                          },
                      @{
                          @"name": @"Maldives",
                          @"code": @"MV"
                          },
                      @{
                          @"name": @"Mali",
                          @"code": @"ML"
                          },
                      @{
                          @"name": @"Malta",
                          @"code": @"MT"
                          },
                      @{
                          @"name": @"Marshall Islands",
                          @"code": @"MH"
                          },
                      @{
                          @"name": @"Martinique",
                          @"code": @"MQ"
                          },
                      @{
                          @"name": @"Mauritania",
                          @"code": @"MR"
                          },
                      @{
                          @"name": @"Mauritius",
                          @"code": @"MU"
                          },
                      @{
                          @"name": @"Mayotte",
                          @"code": @"YT"
                          },
                      @{
                          @"name": @"Mexico",
                          @"code": @"MX"
                          },
                      @{
                          @"name": @"Micronesia, Federated States of Micronesia",
                          @"code": @"FM"
                          },
                      @{
                          @"name": @"Moldova",
                          @"code": @"MD"
                          },
                      @{
                          @"name": @"Monaco",
                          @"code": @"MC"
                          },
                      @{
                          @"name": @"Mongolia",
                          @"code": @"MN"
                          },
                      @{
                          @"name": @"Montenegro",
                          @"code": @"ME"
                          },
                      @{
                          @"name": @"Montserrat",
                          @"code": @"MS"
                          },
                      @{
                          @"name": @"Morocco",
                          @"code": @"MA"
                          },
                      @{
                          @"name": @"Mozambique",
                          @"code": @"MZ"
                          },
                      @{
                          @"name": @"Myanmar",
                          @"code": @"MM"
                          },
                      @{
                          @"name": @"Namibia",
                          @"code": @"NA"
                          },
                      @{
                          @"name": @"Nauru",
                          @"code": @"NR"
                          },
                      @{
                          @"name": @"Nepal",
                          @"code": @"NP"
                          },
                      @{
                          @"name": @"Netherlands",
                          @"code": @"NL"
                          },
                      @{
                          @"name": @"Netherlands Antilles",
                          @"code": @"AN"
                          },
                      @{
                          @"name": @"New Caledonia",
                          @"code": @"NC"
                          },
                      @{
                          @"name": @"New Zealand",
                          @"code": @"NZ"
                          },
                      @{
                          @"name": @"Nicaragua",
                          @"code": @"NI"
                          },
                      @{
                          @"name": @"Niger",
                          @"code": @"NE"
                          },
                      @{
                          @"name": @"Niue",
                          @"code": @"NU"
                          },
                      @{
                          @"name": @"Norfolk Island",
                          @"code": @"NF"
                          },
                      @{
                          @"name": @"Northern Mariana Islands",
                          @"code": @"MP"
                          },
                      @{
                          @"name": @"Norway",
                          @"code": @"NO"
                          },
                      @{
                          @"name": @"Oman",
                          @"code": @"OM"
                          },
                      @{
                          @"name": @"Pakistan",
                          @"code": @"PK"
                          },
                      @{
                          @"name": @"Palau",
                          @"code": @"PW"
                          },
                      @{
                          @"name": @"Palestinian Territory, Occupied",
                          @"code": @"PS"
                          },
                      @{
                          @"name": @"Panama",
                          @"code": @"PA"
                          },
                      @{
                          @"name": @"Papua New Guinea",
                          @"code": @"PG"
                          },
                      @{
                          @"name": @"Paraguay",
                          @"code": @"PY"
                          },
                      @{
                          @"name": @"Peru",
                          @"code": @"PE"
                          },
                      @{
                          @"name": @"Philippines",
                          @"code": @"PH"
                          },
                      @{
                          @"name": @"Pitcairn",
                          @"code": @"PN"
                          },
                      @{
                          @"name": @"Poland",
                          @"code": @"PL"
                          },
                      @{
                          @"name": @"Portugal",
                          @"code": @"PT"
                          },
                      @{
                          @"name": @"Puerto Rico",
                          @"code": @"PR"
                          },
                      @{
                          @"name": @"Qatar",
                          @"code": @"QA"
                          },
                      @{
                          @"name": @"Romania",
                          @"code": @"RO"
                          },
                      @{
                          @"name": @"Russia",
                          @"code": @"RU"
                          },
                      @{
                          @"name": @"Rwanda",
                          @"code": @"RW"
                          },
                      @{
                          @"name": @"Reunion",
                          @"code": @"RE"
                          },
                      @{
                          @"name": @"Saint Barthelemy",
                          @"code": @"BL"
                          },
                      @{
                          @"name": @"Saint Helena, Ascension and Tristan Da Cunha",
                          @"code": @"SH"
                          },
                      @{
                          @"name": @"Saint Kitts and Nevis",
                          @"code": @"KN"
                          },
                      @{
                          @"name": @"Saint Lucia",
                          @"code": @"LC"
                          },
                      @{
                          @"name": @"Saint Martin",
                          @"code": @"MF"
                          },
                      @{
                          @"name": @"Saint Pierre and Miquelon",
                          @"code": @"PM"
                          },
                      @{
                          @"name": @"Saint Vincent and the Grenadines",
                          @"code": @"VC"
                          },
                      @{
                          @"name": @"Samoa",
                          @"code": @"WS"
                          },
                      @{
                          @"name": @"San Marino",
                          @"code": @"SM"
                          },
                      @{
                          @"name": @"Sao Tome and Principe",
                          @"code": @"ST"
                          },
                      @{
                          @"name": @"Saudi Arabia",
                          @"code": @"SA"
                          },
                      @{
                          @"name": @"Senegal",
                          @"code": @"SN"
                          },
                      @{
                          @"name": @"Serbia",
                          @"code": @"RS"
                          },
                      @{
                          @"name": @"Seychelles",
                          @"code": @"SC"
                          },
                      @{
                          @"name": @"Sierra Leone",
                          @"code": @"SL"
                          },
                      @{
                          @"name": @"Singapore",
                          @"code": @"SG"
                          },
                      @{
                          @"name": @"Slovakia",
                          @"code": @"SK"
                          },
                      @{
                          @"name": @"Slovenia",
                          @"code": @"SI"
                          },
                      @{
                          @"name": @"Solomon Islands",
                          @"code": @"SB"
                          },
                      @{
                          @"name": @"Somalia",
                          @"code": @"SO"
                          },
                      @{
                          @"name": @"South Africa",
                          @"code": @"ZA"
                          },
                      @{
                          @"name": @"South Sudan",
                          @"code": @"SS"
                          },
                      @{
                          @"name": @"South Georgia and the South Sandwich Islands",
                          @"code": @"GS"
                          },
                      @{
                          @"name": @"Spain",
                          @"code": @"ES"
                          },
                      @{
                          @"name": @"Sri Lanka",
                          @"code": @"LK"
                          },
                      @{
                          @"name": @"Sudan",
                          @"code": @"SD"
                          },
                      @{
                          @"name": @"Suriname",
                          @"code": @"SR"
                          },
                      @{
                          @"name": @"Svalbard and Jan Mayen",
                          @"code": @"SJ"
                          },
                      @{
                          @"name": @"Swaziland",
                          @"code": @"SZ"
                          },
                      @{
                          @"name": @"Sweden",
                          @"code": @"SE"
                          },
                      @{
                          @"name": @"Switzerland",
                          @"code": @"CH"
                          },
                      @{
                          @"name": @"Syrian Arab Republic",
                          @"code": @"SY"
                          },
                      @{
                          @"name": @"Taiwan",
                          @"code": @"TW"
                          },
                      @{
                          @"name": @"Tajikistan",
                          @"code": @"TJ"
                          },
                      @{
                          @"name": @"Tanzania, United Republic of Tanzania",
                          @"code": @"TZ"
                          },
                      @{
                          @"name": @"Thailand",
                          @"code": @"TH"
                          },
                      @{
                          @"name": @"Timor-Leste",
                          @"code": @"TL"
                          },
                      @{
                          @"name": @"Togo",
                          @"code": @"TG"
                          },
                      @{
                          @"name": @"Tokelau",
                          @"code": @"TK"
                          },
                      @{
                          @"name": @"Tonga",
                          @"code": @"TO"
                          },
                      @{
                          @"name": @"Trinidad and Tobago",
                          @"code": @"TT"
                          },
                      @{
                          @"name": @"Tunisia",
                          @"code": @"TN"
                          },
                      @{
                          @"name": @"Turkey",
                          @"code": @"TR"
                          },
                      @{
                          @"name": @"Turkmenistan",
                          @"code": @"TM"
                          },
                      @{
                          @"name": @"Turks and Caicos Islands",
                          @"code": @"TC"
                          },
                      @{
                          @"name": @"Tuvalu",
                          @"code": @"TV"
                          },
                      @{
                          @"name": @"Uganda",
                          @"code": @"UG"
                          },
                      @{
                          @"name": @"Ukraine",
                          @"code": @"UA"
                          },
                      @{
                          @"name": @"United Arab Emirates",
                          @"code": @"AE"
                          },
                      @{
                          @"name": @"Uruguay",
                          @"code": @"UY"
                          },
                      @{
                          @"name": @"Uzbekistan",
                          @"code": @"UZ"
                          },
                      @{
                          @"name": @"Vanuatu",
                          @"code": @"VU"
                          },
                      @{
                          @"name": @"Venezuela, Bolivarian Republic of Venezuela",
                          @"code": @"VE"
                          },
                      @{
                          @"name": @"Vietnam",
                          @"code": @"VN"
                          },
                      @{
                          @"name": @"Virgin Islands, British",
                          @"code": @"VG"
                          },
                      @{
                          @"name": @"Virgin Islands, U.S.",
                          @"code": @"VI"
                          },
                      @{
                          @"name": @"Wallis and Futuna",
                          @"code": @"WF"
                          },
                      @{
                          @"name": @"Yemen",
                          @"code": @"YE"
                          },
                      @{
                          @"name": @"Zambia",
                          @"code": @"ZM"
                          },
                      @{
                          @"name": @"Zimbabwe",
                          @"code": @"ZW"
                          }
                      ];
    
    [self initValues];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBlackView)
                                                 name:NOTI_SHOW_SUB_BLACK
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:NOTI_HIDE_SUB_BLACK
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideBlackView)
                                                 name:HIDE_BLACKVIEW_SUPER
                                               object:nil];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBlackViewForBoth)];
    [self.viewBlackOpaque addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - Keyboard Notification

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat keyboardHeight = kbSize.height;
    
    if (keyboardHeight + mtfHeight + mtfposition + heightTopOfParentView > self.view.frame.size.height) {
        float d_height = keyboardHeight + mtfHeight + mtfposition + heightTopOfParentView - self.view.frame.size.height;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
            self.scContainer.contentOffset = CGPointMake(0, d_height);
        }];
    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear  animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - webservice call delegate
- (void)response:(NSDictionary *)responseDict apiName:(NSString *)apiName ifAnyError:(NSError *)error {
    if ([apiName isEqualToString:updateProfileApi]) {
        if(responseDict != nil) {
            int success = [[responseDict valueForKey:@"success"] intValue];
            if (success == 1) {
                [Functions showSuccessAlert:@"" message:PROFILE_UPDATED image:@""];
                [self.delegate goBackFromPAddressVC];
            } else {
                [Functions checkError:responseDict];
            }
        }
    }
}

#pragma mark - functions
- (void)initValues {
    [self.tfAddress1 setText:appDelegate.contactData.address1];
    [self.tfAddress2 setText:appDelegate.contactData.address2];
    [self.tfAddress3 setText:appDelegate.contactData.address3];
    [self.tfCity setText:appDelegate.contactData.town];
    [self.tfPostcode setText:appDelegate.contactData.postcode];
    
    for (NSDictionary *countryObj in arrCountries) {
        if ([countryObj[@"code"] isEqualToString:appDelegate.contactData.country]) {
            [_tfCountry setText:countryObj[@"name"]];
        }
    }
}

- (void) setUI
{
    [Functions setBoundsWithView:self.tfAddress1];
    
    [Functions setBoundsWithView:self.tfAddress2];
    
    [Functions setBoundsWithView:self.tfAddress3];
    
    [Functions setBoundsWithView:self.tfCity];
    
    [Functions setBoundsWithView:self.tfCountry];
    
    [Functions setBoundsWithView:self.tfPostcode];
    
//    [Functions setBoundsWithView:self.pickerContainer];
    
}

- (void) setButtonsView
{
    [Functions setBoundsWithView:self.viewResult];
}

- (void) showBlackViewsForBoth
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BLACKVIEW_SHOW object:nil];
    [self showBlackView];
}

- (void) showBlackView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viewBlackOpaque.alpha = 0.7f;
        [self.scContainer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    }];
}

- (void) hideBlackViewForBoth
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_BLACKVIEW_HIDE object:nil];
    [self hideBlackView];
}

- (void) hideBlackView
{
    isShowingTBCountry = false;
    [UIView animateWithDuration:0.3 animations:^{
        self.viewBlackOpaque.alpha = 0.0f;
        self.pickerContainer.alpha = 0.0f;
        [self.scContainer setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0f]];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void) showTBCountry:(UIButton *) btn
{
    CGFloat heightOfTb = 245.0f;
    
    
    [self changeScrollWhenSelectBtn:btn andHeightOfShownView:heightOfTb];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showBlackViewsForBoth];
    });
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.pickerContainer.alpha = 1.0f;
        
        [self.pickerContainer.superview bringSubviewToFront:self.pickerContainer];
    }];
    [self.countryPicker setSelectedCountryCode:appDelegate.contactData.country animated:false];
}

- (void) hideTBCountry
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideBlackViewForBoth];
    });
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.pickerContainer.alpha = 0.0f;
        [UIView animateWithDuration:0.3f animations:^{
            self.scContainer.contentOffset = CGPointMake(0, 0);
        }];
    }];
}
#pragma mark - CountryPickerDelegate

/// This method is called whenever a country is selected in the picker.
- (void)countryPicker:(CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code
{
    strSelectedCountry = name;
    appDelegate.contactData.country = code;
    [self.tfCountry setText:name];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    mtfposition = textField.frame.origin.y;
    mtfHeight = textField.frame.size.height;
    tmpTf = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (void) textFieldDidChange:(UITextField *)textField
{
    NSString *strTxt = textField.text;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Actions
- (IBAction)onBtnDoneCountryPicker:(id)sender {
    isShowingTBCountry = false;
    [self hideTBCountry];
}

- (IBAction)onBtnCountry:(id)sender {
    [tmpTf resignFirstResponder];
    isShowingTBCountry = !isShowingTBCountry;
    
    if (isShowingTBCountry) {
        UIButton *btn = (UIButton *) sender;
        [self showTBCountry:btn];
    }
    else
        [self hideTBCountry];

}

- (void) changeScrollWhenSelectBtn:(UIButton *) button andHeightOfShownView:(CGFloat) height
{
    mtfposition = button.frame.origin.y;
    mtfHeight = button.frame.size.height;
    
    if (height + mtfHeight + mtfposition + heightTopOfParentView > self.view.frame.size.height) {
        float d_height = height + mtfHeight + mtfposition + heightTopOfParentView - self.view.frame.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            self.scContainer.contentOffset = CGPointMake(0, d_height);
        }];
    }
}

- (IBAction)onBtnSave:(id)sender
{
    appDelegate.contactData.address1 = _tfAddress1.text;
    appDelegate.contactData.address2 = _tfAddress2.text;
    appDelegate.contactData.address3 = _tfAddress3.text;
    appDelegate.contactData.town = _tfCity.text;
    appDelegate.contactData.postcode = _tfPostcode.text;
    
    NSMutableDictionary *parameters = [Functions getProfileParameter];
    updateProfileApi = [NSString stringWithFormat:@"%@%@", strMainBaseUrl, CONTACT_DETAIL];
    [objWebServices callApiWithParameters:parameters apiName:updateProfileApi type:POST_REQUEST loader:YES view:self];
}
- (IBAction)onBtnReset:(id)sender
{
    _tfAddress1.text = @"";
    _tfAddress2.text = @"";
    _tfAddress3.text = @"";
    _tfCity.text = @"";
    _tfPostcode.text = @"";
}
- (IBAction)onBtnCancel:(id)sender
{
    [self.delegate goBackFromPAddressVC];
}
@end
