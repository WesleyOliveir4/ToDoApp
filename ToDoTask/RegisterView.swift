
import SwiftUI
import CoreData

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .padding(.bottom, 40)

            TextField("Email", text: $email)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5.0)
                .padding(.bottom, 20)

            Button(action: {
                if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                    alertMessage = "Please fill in all fields"
                    showingAlert = true
                } else if password != confirmPassword {
                    alertMessage = "Passwords do not match"
                    showingAlert = true
                } else {
                    registerUser()
                }
            }) {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }

    private func registerUser() {
        let newUser = User(context: viewContext)
        newUser.email = email
        newUser.password = password

        do {
            try viewContext.save()
            alertMessage = "User registered successfully"
        } catch {
            alertMessage = "Failed to save user: \(error.localizedDescription)"
        }
        showingAlert = true
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
