// File: lib/Pages/sign_in_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';

// --- IMPOR YANG DIPERBAIKI ---
import '../DB/user_database.dart';
import '../Models/user_model.dart';
import '../Theme/app_theme.dart';
import '../Widgets/rounded_input.dart';
import 'main_wrapper.dart';
// ----------------------------

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controllers untuk mengambil data input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // State untuk dropdowns dan checkbox
  String? _selectedGender;
  String? _selectedBirthplace;
  DateTime _selectedDate = DateTime.now();
  bool _agreedToTerms = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _birthplaces = ['Jakarta', 'Surabaya', 'Bandung', 'Medan', 'Other'];

  // Fungsi untuk menampilkan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor, // Warna header
              onPrimary: baseColor, // Warna teks di header
              surface: baseColor, // Warna latar belakang kalender
              onSurface: primaryColor, // Warna angka/teks kalender
            ),
            dialogBackgroundColor: baseColor,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Fungsi SIGN UP
  void _signUp() {
    // 1. Validasi dasar
    if (_passwordController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password dan Konfirmasi Password tidak cocok!', style: GoogleFonts.didactGothic())),
      );
      return;
    }
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda harus menyetujui Syarat & Ketentuan.', style: GoogleFonts.didactGothic())),
      );
      return;
    }

    final String username = _usernameController.text.toLowerCase();

    // 2. Cek apakah username sudah ada di Mock Database
    if (UserDatabase().findUser(username) != null) { // Menggunakan getter UserDatabase()
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username sudah digunakan. Coba username lain.', style: GoogleFonts.didactGothic())),
      );
      return;
    }

    // 3. Buat objek User baru
    final UserModel newUser = UserModel(
      name: _nameController.text,
      username: username,
      email: _emailController.text,
      password: _passwordController.text,
      address: _addressController.text,
      gender: _selectedGender ?? 'N/A',
      birthdate: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
      birthplace: _selectedBirthplace ?? 'N/A',
      userPoints: 0, // Poin awal
      shoppingCart: [],
      selectedPaymentMethod: 'Debit',
    );

    // 4. Simpan ke Mock Database
    UserDatabase().addUser(newUser); // Menggunakan getter UserDatabase()

    // 5. Muat data pengguna ke Sesi
    SessionData().loadFromDatabase(newUser); // Menggunakan getter SessionData()

    // 6. Navigasi ke Halaman Utama
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pendaftaran Berhasil! Selamat datang, ${_nameController.text}.', style: GoogleFonts.didactGothic())),
    );
    Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        title: Text('SIGN - IN FORM', style: GoogleFonts.fredoka(color: primaryColor)),
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: SingleChildScrollView( // DIBUNGKUS DENGAN SingleChildScrollView
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Please fill in the Sign In Form!', style: GoogleFonts.didactGothic(color: primaryColor, fontSize: 18)),
            const SizedBox(height: 20),

            // NAMA
            Text('Name =', style: GoogleFonts.didactGothic(color: primaryColor, fontSize: 16)),
            RoundedInputField(controller: _nameController, hintText: 'Insert Your Name Here!'),

            // USERNAME
            Text('Username =', style: GoogleFonts.didactGothic(color: primaryColor, fontSize: 16)),
            RoundedInputField(controller: _usernameController, hintText: 'Insert Your Username Here! ( for display at app )'),

            // EMAIL
            Text('Email =', style: GoogleFonts.didactGothic(color: primaryColor, fontSize: 16)),
            RoundedInputField(controller: _emailController, hintText: 'Insert Your Email Here!', keyboardType: TextInputType.emailAddress),

            // PASSWORD
            Text('Password =', style: GoogleFonts.didactGothic(color: primaryColor, fontSize: 16)),
            RoundedInputField(
              controller: _passwordController,
              hintText: 'Insert Your Password Here!',
              obscureText: !_showPassword,
              suffixIcon: IconButton(
                icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off, color: primaryColor),
                onPressed: () { setState(() { _showPassword = !_showPassword; }); },
              ),
            ),

            // CONFIRM PASSWORD
            Text('Confirm Pass. =', style: GoogleFonts.didactGothic(color: primaryColor, fontSize: 16)),
            RoundedInputField(
              controller: _confirmPassController,
              hintText: 'Confirm Your Password Here!',
              obscureText: !_showConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(_showConfirmPassword ? Icons.visibility : Icons.visibility_off, color: primaryColor),
                onPressed: () { setState(() { _showConfirmPassword = !_showConfirmPassword; }); },
              ),
            ),
            const SizedBox(height: 10),

            // GENDER DROPDOWN
            Text('Gender =', style: GoogleFonts.didactGothic(color: primaryColor, fontSize: 16)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: InputBorder.none),
                hint: Text('Choose your Gender here!', style: GoogleFonts.didactGothic(color: baseColor.withOpacity(0.8))),
                value: _selectedGender,
                items: _genders.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: GoogleFonts.didactGothic(color: primaryColor)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() { _selectedGender = newValue; });
                },
                dropdownColor: baseColor,
                iconEnabledColor: primaryColor,
              ),
            ),
            const SizedBox(height: 10),

            // BIRTHDATE (Date Picker)
            Text('Birthdate =', style: GoogleFonts.didactGothic(color: primaryColor, fontSize: 16)),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: GoogleFonts.didactGothic(color: primaryColor, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // BIRTHPLACE DROPDOWN
            Text('Birthplace =', style: GoogleFonts.didactGothic(color: primaryColor, fontSize: 16)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: InputBorder.none),
                hint: Text('Choose your Place of Birth here!', style: GoogleFonts.didactGothic(color: baseColor.withOpacity(0.8))),
                value: _selectedBirthplace,
                items: _birthplaces.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: GoogleFonts.didactGothic(color: primaryColor)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() { _selectedBirthplace = newValue; });
                },
                dropdownColor: baseColor,
                iconEnabledColor: primaryColor,
              ),
            ),
            const SizedBox(height: 10),

            // ADDRESS
            Text('Address =', style: GoogleFonts.didactGothic(color: primaryColor, fontSize: 16)),
            RoundedInputField(controller: _addressController, hintText: 'Insert Your Address Here!', keyboardType: TextInputType.streetAddress),
            const SizedBox(height: 10),

            // TERMS & CONDITIONS CHECKBOX
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  onChanged: (bool? newValue) {
                    setState(() { _agreedToTerms = newValue!; });
                  },
                  activeColor: primaryColor,
                ),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      text: 'By checking this box, You agree with the ',
                      style: GoogleFonts.didactGothic(color: primaryColor),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: GoogleFonts.didactGothic(
                            color: accentColor,
                            decoration: TextDecoration.underline,
                          ),
                          // Simulasi link
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Membuka Halaman Syarat & Ketentuan...', style: GoogleFonts.didactGothic())),
                              );
                            },
                        ),
                        TextSpan(text: ' that is displayed here!'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // SIGN UP NOW BUTTON
            ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: baseColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 5,
              ),
              child: Text(
                'SIGN - UP NOW !',
                style: GoogleFonts.fredoka(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
