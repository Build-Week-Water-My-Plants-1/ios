//
//  MockJSON.swift
//  OxygenUnitTests
//
//  Created by Ezra Black on 4/30/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
let goodResultPlantData = """
[
    {
        "id": 21,
        "common_name": "eggs",
        "scientific_name": "eggs",
        "h2o_frequency": 1
    },
    {
        "id": 22,
        "common_name": "eggy",
        "scientific_name": "weggy",
        "h2o_frequency": 1
    },
    {
        "id": 23,
        "common_name": "abra",
        "scientific_name": "kade",
        "h2o_frequency": 1
    }
]
""".data(using: .utf8)!

let badResultPlantData = """
[
    {
        "id": 21,
        "common
    {
        "id": 22,
        "common
        "id": 23,}}}}
        "contific_name": "kade",
        "h2o_frequency": 1
    }

}
}
}
}
]
""".data(using: .utf8)!
