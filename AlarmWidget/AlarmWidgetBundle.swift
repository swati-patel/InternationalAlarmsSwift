//
//  AlarmWidgetBundle.swift
//  AlarmWidget
//
//  Created by Swati Patel on 26/11/2025.
//

import WidgetKit
import SwiftUI

@main
struct AlarmWidgetBundle: WidgetBundle {
    var body: some Widget {
        AlarmWidget()
        AlarmWidgetControl()
        AlarmWidgetLiveActivity()
    }
}
