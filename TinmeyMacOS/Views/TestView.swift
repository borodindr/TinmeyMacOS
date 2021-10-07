////
////  TestView.swift
////  TinmeyMacOS
////
////  Created by Dmitry Borodin on 19.08.2021.
////
//
//import SwiftUI
//
//struct Mail: Identifiable, Hashable {
//    let id = UUID()
//    let date: Date
//    let subject: String
//    let body: String
//    var isFavorited = false
//}
//
//final class MailStore: ObservableObject {
//    @Published var allMails: [String: [Mail]] = [
//        "Inbox": [ .init(date: Date(), subject: "Subject1", body: "Very long body...") ],
//        "Sent": [ .init(date: Date(), subject: "Subject2", body: "Very long body...") ],
//    ]
//}
//
//struct Sidebar: View {
//    @ObservedObject var store: MailStore
//    @Binding var selectedFolder: String?
//    @Binding var selectedMail: Mail?
//
//    var body: some View {
//        List {
//            ForEach(Array(store.allMails.keys), id: \.self) { folder in
//                NavigationLink(
//                    destination: FolderView(
//                        title: folder,
//                        mails: store.allMails[folder, default: []],
//                        selectedMail: $selectedMail
//                    ),
//                    tag: folder,
//                    selection: $selectedFolder
//                ) {
//                    Text(folder).font(.headline)
//                }
//            }
//        }.listStyle(SidebarListStyle())
//    }
//}
//
//struct FolderView: View {
//    let title: String
//    let mails: [Mail]
//    @Binding var selectedMail: Mail?
//
//    var body: some View {
//        List {
//            ForEach(mails) { mail in
//                NavigationLink(
//                    destination: MailView(mail: mail),
//                    tag: mail,
//                    selection: $selectedMail
//                ) {
//                    VStack(alignment: .leading) {
//                        Text(mail.subject)
//                        Text(mail.date, style: .date)
//                    }
//                }
//            }
//        }.navigationTitle(title)
//    }
//}
//
//struct MailView: View {
//    let mail: Mail
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(mail.subject)
//                .font(.headline)
//            Text(mail.date, style: .date)
//            Text(mail.body)
//        }
//    }
//}
//
//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        Sidebar(store: MailStore(), selectedFolder: .constant("Index"), selectedMail: .constant(nil))
//    }
//}
