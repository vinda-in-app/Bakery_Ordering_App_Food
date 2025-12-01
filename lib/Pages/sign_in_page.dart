// File: lib/Pages/sign_in_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

// --- IMPORT PROJECT ---
import '../DB/user_database.dart';
import '../Models/user_model.dart';
import '../Theme/app_theme.dart';
import '../Widgets/rounded_input.dart';
import 'main_wrapper.dart'; // kalau pakai named route '/main', ini optional saja
// ----------------------

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controllers untuk input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // State form
  String? _selectedGender;
  String? _selectedBirthplace;
  DateTime _selectedDate = DateTime.now();
  bool _agreedToTerms = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _birthplaces = [
    'Jakarta',
    'Surabaya',
    'Bandung',
    'Medan',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Date picker untuk Birthdate
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
              primary: primaryColor,
              onPrimary: baseColor,
              surface: baseColor,
              onSurface: primaryColor,
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

  // Fungsi SIGN UP (ASYNC, full SQLite)
  Future<void> _signUp() async {
    if (_isLoading) return;

    // 1. Validasi isi form
    if (_nameController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPassController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Semua field wajib diisi (Name, Username, Email, Password).',
            style: GoogleFonts.didactGothic(),
          ),
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password dan Konfirmasi Password tidak cocok!',
            style: GoogleFonts.didactGothic(),
          ),
        ),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Anda harus menyetujui Syarat & Ketentuan.',
            style: GoogleFonts.didactGothic(),
          ),
        ),
      );
      return;
    }

    final String username = _usernameController.text.trim().toLowerCase();

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Cek username di SQLite via UserDatabase (PAKAI await)
      final existingUser = await UserDatabase().findUser(username);
      if (existingUser != null) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Username sudah digunakan. Coba username lain.',
              style: GoogleFonts.didactGothic(),
            ),
          ),
        );
        return;
      }

      // 3. Buat objek User baru
      final UserModel newUser = UserModel(
        name: _nameController.text.trim(),
        username: username,
        email: _emailController.text.trim(),
        password: _passwordController.text, // kalau nanti pakai hashing, ganti di sini
        address: _addressController.text.trim(),
        gender: _selectedGender ?? 'N/A',
        birthdate:
        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
        birthplace: _selectedBirthplace ?? 'N/A',
        userPoints: 0,
        shoppingCart: [],
        selectedPaymentMethod: 'Debit',
      );

      // 4. Simpan user ke SQLite
      await UserDatabase().addUser(newUser);

      // 5. Muat ke session
      SessionData().loadFromDatabase(newUser);

      // 6. Sukses → pindah ke main
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pendaftaran Berhasil! Selamat datang, ${_nameController.text}.',
            style: GoogleFonts.didactGothic(),
          ),
        ),
      );

      // Kalau kamu pakai named route '/main':
      Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);

      // Atau kalau mau pakai widget langsung:
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (_) => const MainWrapper()),
      //   (route) => false,
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terjadi kesalahan saat mendaftar: $e',
            style: GoogleFonts.didactGothic(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        title: Text(
          'SIGN - IN FORM',
          style: GoogleFonts.fredoka(color: primaryColor),
        ),
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Please fill in the Sign In Form!',
              style: GoogleFonts.didactGothic(
                color: primaryColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),

            // NAMA
            Text(
              'Name =',
              style: GoogleFonts.didactGothic(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            RoundedInputField(
              controller: _nameController,
              hintText: 'Insert Your Name Here!',
            ),

            // USERNAME
            Text(
              'Username =',
              style: GoogleFonts.didactGothic(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            RoundedInputField(
              controller: _usernameController,
              hintText: 'Insert Your Username Here!',
            ),

            // EMAIL
            Text(
              'Email =',
              style: GoogleFonts.didactGothic(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            RoundedInputField(
              controller: _emailController,
              hintText: 'Insert Your Email Here!',
              keyboardType: TextInputType.emailAddress,
            ),

            // PASSWORD
            Text(
              'Password =',
              style: GoogleFonts.didactGothic(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            RoundedInputField(
              controller: _passwordController,
              hintText: 'Insert Your Password Here!',
              obscureText: !_showPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),
            ),

            // CONFIRM PASSWORD
            Text(
              'Confirm Pass. =',
              style: GoogleFonts.didactGothic(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            RoundedInputField(
              controller: _confirmPassController,
              hintText: 'Confirm Your Password Here!',
              obscureText: !_showConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _showConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),

            // GENDER
            Text(
              'Gender =',
              style: GoogleFonts.didactGothic(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: InputBorder.none),
                hint: Text(
                  'Choose your Gender here!',
                  style: GoogleFonts.didactGothic(
                    color: baseColor.withOpacity(0.8),
                  ),
                ),
                value: _selectedGender,
                items: _genders.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.didactGothic(color: primaryColor),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                dropdownColor: baseColor,
                iconEnabledColor: primaryColor,
              ),
            ),
            const SizedBox(height: 10),

            // BIRTHDATE
            Text(
              'Birthdate =',
              style: GoogleFonts.didactGothic(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: GoogleFonts.didactGothic(
                    color: primaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // BIRTHPLACE
            Text(
              'Birthplace =',
              style: GoogleFonts.didactGothic(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: InputBorder.none),
                hint: Text(
                  'Choose your Place of Birth here!',
                  style: GoogleFonts.didactGothic(
                    color: baseColor.withOpacity(0.8),
                  ),
                ),
                value: _selectedBirthplace,
                items: _birthplaces.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.didactGothic(color: primaryColor),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBirthplace = newValue;
                  });
                },
                dropdownColor: baseColor,
                iconEnabledColor: primaryColor,
              ),
            ),
            const SizedBox(height: 10),

            // ADDRESS
            Text(
              'Address =',
              style: GoogleFonts.didactGothic(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
            RoundedInputField(
              controller: _addressController,
              hintText: 'Insert Your Address Here!',
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 10),

            // TERMS & CONDITIONS
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _agreedToTerms = newValue ?? false;
                    });
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
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Membuka Halaman Syarat & Ketentuan...',
                                    style: GoogleFonts.didactGothic(),
                                  ),
                                ),
                              );
                            },
                        ),
                        const TextSpan(text: ' that is displayed here!'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // SIGN UP BUTTON
            ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: baseColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 5,
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Text(
                'SIGN - UP NOW !',
                style: GoogleFonts.fredoka(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
