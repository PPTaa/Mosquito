//
//  MosquitoWidget.swift
//  MosquitoWidget
//
//  Created by leejungchul on 2023/03/03.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    // 데이터를 불러오기 전에 표출될 placeholder
    func placeholder(in context: Context) -> SimpleEntry {
        let stageImage = getTodayStage(score: -1)
        return SimpleEntry(date: Date(), stageImage: stageImage, configuration: ConfigurationIntent())
    }
    
    // 데이터 로드 담당 메소드
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        getMosquitoData(date: Date()) { stage in
            let entry = SimpleEntry(date: Date(), stageImage: stage, configuration: configuration)
            completion(entry)
        }
    }

    // 데이터를 언제 리프레시 할지 결정
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        getMosquitoData(date: Date()) { stage in
            let currentDate = Date()
            let entry = SimpleEntry(date: Date(), stageImage: stage, configuration: configuration)
            let nextRefresh = Calendar.current.date(byAdding: .hour, value: 2, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
            completion(timeline)
        }
    }
    
    private func getMosquitoData(date: Date, completion: @escaping (UIImage) -> ()) {
        MosquitoService().getMosquitoInfo(date: date) { error, data in
            if let error = error {
                let stage = getTodayStage(score: 1)
                completion(stage)
            } else {
                guard let mosquitoData = data?.mosquitoStatus?.row[0] else {
                    let stage = getTodayStage(score: -1)
                    completion(stage)
                    return
                }
                let score = Double(mosquitoData.mosquitoValueHouse) ?? 0.0
                let stage = getTodayStage(score: CGFloat(score))
                completion(stage)
            }
        }
    }
    
    private func getTodayStage(score: CGFloat) -> UIImage {
        let stage: Int
        switch score {
        case -1:
            stage = 5
        case 0...24.9 :
            stage = 1
        case 25.0...49.9 :
            stage = 2
        case 50.0...74.9 :
            stage = 3
        case 75.0... :
            stage = 4
        default:
            stage = 1
        }
        return UIImage(named: "widgetStage\(stage)") ?? UIImage()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let stageImage: UIImage
    let configuration: ConfigurationIntent
}

struct MosquitoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
//        Text(entry.date, style: .time)
        Image(uiImage: entry.stageImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

@main
struct MosquitoWidget: Widget {
    let kind: String = "MosquitoWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MosquitoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("웽웽 위젯")
        .description("웽웽의 위젯입니다.")
    }
}

struct MosquitoWidget_Previews: PreviewProvider {
    static var previews: some View {
        MosquitoWidgetEntryView(entry: SimpleEntry(date: Date(), stageImage: UIImage(named: "widgetStage5")!, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
