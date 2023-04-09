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
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년/MM월 dd일"
        formatter.locale = Locale(identifier: "ko_kr")
        return formatter
    }()
    // 데이터를 불러오기 전에 표출될 placeholder
    func placeholder(in context: Context) -> SimpleEntry {
        let today = dateFormatter.string(from: Date()).components(separatedBy: "/")
        return SimpleEntry(date: Date(), dateString: today, stage: 1, configuration: ConfigurationIntent())
    }
    
    // 데이터 로드 담당 메소드
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        getMosquitoData(date: Date()) { stage in
            let today = dateFormatter.string(from: Date()).components(separatedBy: "/")
            let entry = SimpleEntry(date: Date(), dateString: today, stage: stage, configuration: ConfigurationIntent())
            completion(entry)
        }
    }

    // 데이터를 언제 리프레시 할지 결정
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let today = dateFormatter.string(from: Date()).components(separatedBy: "/")
        getMosquitoData(date: Date()) { stage in
            let currentDate = Date()
            let entry = SimpleEntry(date: Date(), dateString: today, stage: stage, configuration: ConfigurationIntent())
            let nextRefresh = Calendar.current.date(byAdding: .hour, value: 2, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
            completion(timeline)
        }
    }
    
    private func getMosquitoData(date: Date, completion: @escaping (Int) -> ()) {
        MosquitoService().getMosquitoInfo(date: date) { error, data in
            if let _ = error {
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
    
    private func getTodayStage(score: CGFloat) -> Int {
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
        return stage
    }
}


struct SimpleEntry: TimelineEntry {
    var date: Date
    let dateString: [String]
    let stage: Int
    let configuration: ConfigurationIntent
}

struct MosquitoWidgetEntryView : View {
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemMedium:
            GeometryReader { reader in
                Color("graphColor\(entry.stage)").ignoresSafeArea()
                HStack(alignment: .center, spacing: 0) {
                    Image("widgetStage\(entry.stage)")
                        .frame(width: reader.size.width - reader.size.height, height: reader.size.height)
                        .aspectRatio(contentMode: .fit)
                    RoundedRectangle(cornerRadius: 21)
                        .fill(.white)
                        .frame(width: reader.size.height, height: reader.size.height)
                        .overlay (
                            VStack {
                                Text(entry.dateString[0])
                                    .font(.custom("Pretendard-Medium", size: 24))
                                Text(entry.dateString[1])
                                    .font(.custom("Pretendard-SemiBold", size: 32))
                            }
                        )
                }
            }
        default:
            Image("widgetStage\(entry.stage)")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
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
        MosquitoWidgetEntryView(entry: SimpleEntry(date: Date(), dateString: ["2222년", "33월 44일"], stage: Int.random(in: 1...5), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
