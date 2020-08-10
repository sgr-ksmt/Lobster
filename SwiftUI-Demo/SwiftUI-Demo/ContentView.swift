//
//  ContentView.swift
//  SwiftUI-Demo
//
//  Created by Suguru Kishimoto on 2020/08/10.
//  Copyright © 2020 su-Tech. All rights reserved.
//

import SwiftUI
import Lobster
import Combine

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        VStack {
            Text(viewModel.title)
                .font(.largeTitle)
                .bold()
                .foregroundColor(viewModel.titleColor)
            Spacer()
                .frame(height: 160)


            VStack(alignment: .leading, spacing: 8.0) {
                Text("Name: \(viewModel.name)")
                    .foregroundColor(.white)
                Text("Age: \(viewModel.age)")
                    .foregroundColor(.white)
                Text("Country: \(viewModel.country)")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.blue)

            Spacer()

            Button(action: {
                Lobster.shared.fetch()
            }, label: { Text("Fetch") })
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(4.0)
                .padding()

            Spacer()
                .frame(height: 32)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class ViewModel: ObservableObject {
    @Published var title: String
    @Published var titleColor: Color
    @Published var name: String
    @Published var age: Int
    @Published var country: String

    private var cancellables: Set<AnyCancellable> = []
    init() {
        title = Lobster.shared[.titleText]
        titleColor = Color(Lobster.shared[.titleColor])
        let person = Lobster.shared[.person]
        name = person.name
        age = person.age
        country = person.country

        Lobster.shared.combine.fetched(.titleText)
            .receive(on: RunLoop.main)
            .assign(to: \.title, on: self)
            .store(in: &cancellables)

        Lobster.shared.combine.fetched(.titleColor)
            .map { Color($0) }
            .receive(on: RunLoop.main)
            .assign(to: \.titleColor, on: self)
            .store(in: &cancellables)

        let personPublisher = Lobster.shared.combine.fetched(.person)

        personPublisher
            .map { $0.name }
            .receive(on: RunLoop.main)
            .assign(to: \.name, on: self)
            .store(in: &cancellables)

        personPublisher
            .map { $0.age }
            .receive(on: RunLoop.main)
            .assign(to: \.age, on: self)
            .store(in: &cancellables)

        personPublisher
            .map { $0.country }
            .receive(on: RunLoop.main)
            .assign(to: \.country, on: self)
            .store(in: &cancellables)
    }
}
