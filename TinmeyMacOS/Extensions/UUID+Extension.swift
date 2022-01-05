//
//  UUID+Extension.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 03.01.2022.
//

import Foundation

extension UUID {
    static var zero: Self {
        UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
    }
}
