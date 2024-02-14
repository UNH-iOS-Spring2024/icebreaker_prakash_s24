//
//  ContentView.swift
//  Icebreaker
//
//  Created by Peter on 2/14/24.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    
    var db = Firestore.firestore()
    @State var questions = [Question]()
    @State var textFirstName: String = ""
    @State var textLastName: String = ""
    @State var textPrefName: String = ""
    @State var textQuestion: String = ""
    @State var textAnswer: String = ""
    var body: some View {
        VStack {
            Text("Icebreaker")
                .font(.system(size: 40))
                .bold()
            Text("Built with SwiftUI")
            
            TextField("First Name", text: $textFirstName)
            
            TextField("Last Name", text: $textLastName)
            
            TextField("Preferred Name", text: $textPrefName)
            
            Button(action: {setRandomQuestion()}){
                Text("Get a new random question")
                    .font(.system(size: 20))
            }
            
            Text(textQuestion)
            
            TextField("Answer", text: $textAnswer)
            
            Button(action: {if(textAnswer != "") {
                writeStudentToFirebase()
                resetTextField()
            }}){
                Text("Submit")
                    .font(.system(size: 20))
            }
            
        }
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .autocorrectionDisabled(true)
        .padding()
        .onAppear() {
            getQuestionsFromFirebase()
        }
    }
    
    func setRandomQuestion() {
        let newQuestion = questions.randomElement()?.text
        if(newQuestion != nil) {
            self.textQuestion = newQuestion!
            print(self.textQuestion)
        }
    }
    
    func getQuestionsFromFirebase(){
        db.collection("questions")
            .getDocuments() { (querySnapshot, err) in
                if let err = err { // if error is not nil
                    print("Error getting documents: \(err)")
                } else { // Get my question documents from Firebase
                    for document in querySnapshot!.documents{
                        print("\(document.documentID)")
                        if let question = Question(id: document.documentID, data: document.data()) {
                            print("Question ID = \(question.id), text = \(question.text)")
                            questions.append(question)
                        }
                    }
                    
                }
                
            }
    }
        
    
    func writeStudentToFirebase() {
        print("Submit button pressed")
        print("First Name: \(textFirstName)")
        print("Last Name: \(textLastName)")
        print("Pref Name: \(textPrefName)")
        print("Answer: \(textAnswer)")
        print("Question: \(textQuestion)")
        print("Class: ios-spring2024")
        
        let data = [
            "first_name": textFirstName,
            "last_name": textLastName,
            "pref_name": textPrefName,
            "question": textQuestion,
            "answer": textAnswer,
            "class": "ios-spring2024"] as [String: Any]
            
            var ref: DocumentReference? = nil
            ref = db.collection("students")
                .addDocument(data: data) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else{
                        print("Document addeed Document ID: \(ref!.documentID)")
                    }
                    
                }
        
        
    }
    func resetTextField() {
        textFirstName = ""
        textLastName = ""
        textPrefName = ""
        textQuestion = ""
        textAnswer = ""
    }
}

#Preview {
    ContentView()
}
