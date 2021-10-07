//
//  EditBookCoverView.swift
//  TinmeyMacOS
//
//  Created by Dmitry Borodin on 19.08.2021.
//

import SwiftUI

struct EditWorkView: View {
    @ObservedObject private var viewModel: EditWorksViewModel
    
    init(workType: WorkType, isPresented: Binding<Bool>) {
        self.viewModel = EditWorksViewModel(
            workType: workType,
            isPresented: isPresented
        )
    }
    
    init(work: Work, workType: WorkType, workToEdit: Binding<Work?>) {
        self.viewModel = EditWorksViewModel(
            work: work,
            workType: workType,
            workToEdit: workToEdit
        )
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 8) {
                Text(viewModel.title)
                    .font(.title)
                    .padding(.top, 16)
                
                boxes
                
                TextField("See work link", text: $viewModel.seeMoreLink)
                
                HStack {
                    Button(action: {
                        viewModel.isPresented = false
                        viewModel.workToEdit = nil
                    }, label: {
                        Text("Dismiss")
                    })
                    Spacer()
                    Button(action: {
                        viewModel.createOrUpdate()
                    }, label: {
                        Text("Save")
                    })
                }
            }
            .padding()
            
            if viewModel.isLoading {
                Color.black.opacity(0.5)
                VStack {
                    Spacer()
                    ProgressIndicator(size: .regular)
                    Spacer()
                }
            }
        }
        .frame(minWidth: 1000, minHeight: 400)
        .background(BlurView())
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.text),
                dismissButton: .default(Text("Close"))
            )
        }
    }
    
    // MARK: - Boxes
    var boxes: some View {
        HStack(spacing: 0) {
            switch viewModel.workLayout {
            case .leftBody:
                bodyBox
                firstImageBox
                secondImageBox
                
            case .middleBody:
                firstImageBox
                bodyBox
                secondImageBox
                
            case .rightBody:
                firstImageBox
                secondImageBox
                bodyBox
                
            case .leftLargeBody:
                largeBodyBox
                firstImageBox
                
            case .rightLargeBody:
                firstImageBox
                largeBodyBox
            }
        }
    }
    
    var bodyBox: some View {
        VStack(spacing: 8) {
            EditWorkViewBodyBox(title: $viewModel.titleText,
                                description: $viewModel.descriptionText)
                .background(Color.black)
                .border(Color.gray, width: 1)
            bodyBoxControls
        }
    }
    
    var largeBodyBox: some View {
        VStack(spacing: 8) {
            HStack {
                EditWorkViewBodyBox(title: $viewModel.titleText,
                                    description: $viewModel.descriptionText)
                Spacer()
            }
            .frame(width: 600, height: 300)
            .background(Color.black)
            .border(Color.gray, width: 1)
            bodyBoxControls
        }
    }
    
    var firstImageBox: some View {
        VStack(spacing: 8) {
            if let selectedImagePath = viewModel.newFirstImagePath {
                WorkViewImageBox(imageURL: selectedImagePath)
                    .background(Color.black)
                    .border(Color.gray, width: 1)
            } else {
                WorkViewImageBox(imageURL: viewModel.currentFirstImagePath)
                    .background(Color.black)
                    .border(Color.gray, width: 1)
            }
            firstImageBoxControls
        }
    }
    
    var secondImageBox: some View {
        VStack(spacing: 8) {
            if let selectedImagePath = viewModel.newSecondImagePath {
                WorkViewImageBox(imageURL: selectedImagePath)
                    .background(Color.black)
                    .border(Color.gray, width: 1)
            } else {
                WorkViewImageBox(imageURL: viewModel.currentSecondImagePath)
                    .background(Color.black)
                    .border(Color.gray, width: 1)
            }
            secondImageBoxControls
        }
    }
    
    // MARK: - Controls
    var bodyBoxControls: some View {
        HStack {
            if viewModel.canMoveBodyLeft {
                moveLeftButton
            }
            changeBodyBoxStateButton
            if viewModel.canMoveBodyRight {
                moveRightButton
            }
        }
    }
    
    var moveLeftButton: some View {
        Button(action: viewModel.moveBodyLeft) {
            Image("arrow_left")
        }
    }
    
    var moveRightButton: some View {
        Button(action: viewModel.moveBodyRight) {
            Image("arrow_right")
        }
    }
    
    var changeBodyBoxStateButton: some View {
        Button(action: viewModel.changeBodyBoxState) {
            Text(viewModel.changeBodyBoxStateTitle)
        }
    }
    
    var firstImageBoxControls: some View {
        HStack {
            Button {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK, let url = panel.url {
                    viewModel.newFirstImagePath = url
                }
            } label: {
                Text("Select")
            }
            if viewModel.newFirstImagePath != nil {
                Button {
                    viewModel.newFirstImagePath = nil
                } label: {
                    Text("Reset")
                }
            }
        }
    }
    
    var secondImageBoxControls: some View {
        HStack {
            Button {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK, let url = panel.url {
                    viewModel.newSecondImagePath = url
                }
            } label: {
                Text("Select")
            }
            if viewModel.newSecondImagePath != nil {
                Button {
                    viewModel.newSecondImagePath = nil
                } label: {
                    Text("Reset")
                }
            }
        }
    }
    
}



struct EditBookCoverView_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkView(workType: .cover, isPresented: .constant(true))
    }
}
