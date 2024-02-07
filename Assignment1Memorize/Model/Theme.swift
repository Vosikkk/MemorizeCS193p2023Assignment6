//
//  Theme.swift
//  Memorize
//
//  Created by Саша Восколович on 07.02.2024.
//

import Foundation


struct Theme: Identifiable, Codable, Hashable {
    
    var name: String
    var emojis: String
    var id = UUID()
    var color: RGBA
    
    
    static var builtins: [Theme] { [
        Theme(name: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜", color: RGBA(red: 255, green: 143, blue: 20, alpha: 1)),
        Theme(name: "Sports", emojis:  "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳", color: RGBA(red: 86, green: 178, blue: 62, alpha: 1)),
        Theme(name: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻", color: RGBA(red: 248, green: 218, blue: 9, alpha: 1)),
        Theme(name: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔", color: RGBA(red: 229, green: 108, blue: 204, alpha: 1)),
        Theme(name: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲", color: RGBA(red: 37, green: 75, blue: 240, alpha: 1)),
        Theme(name: "Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻", color: RGBA(red: 1, green: 1, blue: 1, alpha: 1)),
        Theme(name: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪", color: RGBA(red: 1, green: 1, blue: 1, alpha: 1)),
        Theme(name: "COVID", emojis:  "💉🦠😷🤧🤒", color: RGBA(red: 1, green: 1, blue: 1, alpha: 1)),
        Theme(name: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠", color: RGBA(red: 1, green: 1, blue: 1, alpha: 1))
      ]
    }
}
