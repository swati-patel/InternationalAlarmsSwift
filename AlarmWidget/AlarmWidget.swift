//
//  AlarmWidget.swift
//  AlarmWidget
//
//  Created by Swati Patel on 26/11/2025.
//

import ActivityKit
import AlarmKit
import SwiftUI
import WidgetKit

struct AlarmWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmAttributes<EmptyMetadata>.self) { context in
            // Lock Screen presentation
            VStack {
                Text(String(localized: context.attributes.presentation.alert.title))
                       .font(.title3)
                       .fontWeight(.semibold)
            }
            .padding()
            
        } dynamicIsland: { context in
            // Dynamic Island presentation
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(String(localized: context.attributes.presentation.alert.title))
                            .font(.title3)
                            .fontWeight(.semibold)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    // Empty for now
                }
                DynamicIslandExpandedRegion(.bottom) {
                    // Empty for now
                }
            } compactLeading: {
                Text(String(localized: context.attributes.presentation.alert.title))
                        .font(.caption)
                        .lineLimit(1)
            } compactTrailing: {
                Text(String(localized: context.attributes.presentation.alert.title))
                      .font(.caption)
                      .lineLimit(1)
            } minimal: {
                Image(systemName: "alarm")
                    .foregroundStyle(context.attributes.tintColor)
            }
            .keylineTint(context.attributes.tintColor)
        }
    }
}
