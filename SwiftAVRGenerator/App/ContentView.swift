//
//  ContentView.swift
//  SwiftAVRGenerator
//
//  Created by Paul Shelley on 5/27/23.
//
import Foundation
import SwiftUI

struct ContentView: View {
    @State var urls: [URL] = []
    @State var showFileChooser = false
    @State var docDir: URL? = nil

    var body: some View {
        HStack {
            Button("Select Files") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = true
                panel.canChooseDirectories = false
                if panel.runModal() == .OK {
                    self.urls = panel.urls
                }
            }
            Button {
                printValues()
            } label: {
                Text("Display in Console")
            }
            Button {
                let panel = NSSavePanel()
                panel.allowedContentTypes = [.text]
                panel.canCreateDirectories = true
                panel.nameFieldLabel = "File Name:"
                if panel.runModal() == .OK {
                    guard let url = panel.url else { return }
                    exportAll(fromURLs: self.urls, toURL: url, docURL: docDir!)
                }
            } label: {
                Text("Export")
            }
            Button("doc dir") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = true
                if panel.runModal() == .OK {
                    self.docDir = panel.url
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func printValues() {
    let uniqueNames = listOfValues.unique()
    print()
    for name in uniqueNames {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        let enumValue = name.filter { okayChars.contains($0) }
        print("case \(enumValue) = \"\(name)\"")
    }
}
