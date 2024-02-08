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
        Theme(name: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜", color: RGBA(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)),
        Theme(name: "Sports", emojis:  "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳", color: RGBA(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)),
        Theme(name: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻", color: RGBA(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)),
        Theme(name: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔", color: RGBA(red: 0.0, green: 0.991, blue: 1.0, alpha: 1.0)),
        Theme(name: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲", color: RGBA(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)),
        Theme(name: "Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻", color: RGBA(red: 1.0, green: 0.253, blue: 1.0, alpha: 1.0)),
        Theme(name: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪", color: RGBA(red: 0.579, green: 0.128, blue: 0.573, alpha: 1.0)),
        Theme(name: "COVID", emojis:  "💉🦠😷🤧🤒", color: RGBA(red: 1.0, green: 0.576, blue: 0.0, alpha: 1.0)),
        Theme(name: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠", color: RGBA(red: 0.0, green: 0.329, blue: 0.575, alpha: 1.0))
      ]
    }
}
