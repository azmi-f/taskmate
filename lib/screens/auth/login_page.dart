import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: Center(

        child: SizedBox(

          width: 420,

          child: Padding(

            padding: const EdgeInsets.all(24),

            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                const Icon(
                  Icons.lock_open,
                  size: 80,
                  color: Colors.blue,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text("Masuk ke akun TaskMate"),

                const SizedBox(height: 30),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(

                  width: double.infinity,

                  height: 50,

                  child: ElevatedButton(

                    onPressed: () {},

                    child: const Text(
                      "Masuk",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(

                  onPressed: () {

                    Navigator.pop(context);

                  },

                  child: const Text(
                    "Belum punya akun? Daftar",
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}