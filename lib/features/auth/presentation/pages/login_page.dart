import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  int _selectedTab = 0;
  bool _isPasswordStep = false;
  bool _keepLoggedIn = false;
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmed = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isRegisterMode => _selectedTab == 1;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Informe seu e-mail';

    if (_isRegisterMode) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) return 'E-mail em formato inválido';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Informe sua senha';
    if (_isRegisterMode) {
      if (value.length < 8) return 'Mínimo de 8 caracteres';
      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$').hasMatch(value)) {
        return 'Deve conter ao menos uma letra e um número';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const primaryBlue = Color(0xFF1876D2);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.05,
            right: -size.width * 0.45,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/assets/logo_shield.png',
                width: size.width * 1.6,
                fit: BoxFit.contain,
                color: Colors.grey,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, size.height * 0.05, 24, 0),
              child: Text(
                'Nortus',
                style: GoogleFonts.inter(
                  color: primaryBlue,
                  fontSize: size.width * 0.11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0D478C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isRegisterMode
                                      ? 'Crie sua conta'
                                      : 'Acesse sua conta',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                _buildTextFormField(
                                  controller: _emailController,
                                  label: 'Digite seu E-mail',
                                  validator: _validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                ),

                                if (_isRegisterMode || _isPasswordStep) ...[
                                  const SizedBox(height: 16),
                                  _buildTextFormField(
                                    controller: _passwordController,
                                    label: 'Digite a Senha',
                                    validator: _validatePassword,

                                    obscureText: _obscurePassword,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.black,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                    ),
                                    maxLength: 15,
                                  ),
                                ],

                                if (_isRegisterMode) ...[
                                  const SizedBox(height: 16),
                                  _buildTextFormField(
                                    controller: _confirmPasswordController,
                                    label: 'Confirme Senha',
                                    obscureText: _obscurePasswordConfirmed,
                                    validator: (value) {
                                      if (value != _passwordController.text)
                                        return 'As senhas não coincidem';
                                      return null;
                                    },
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePasswordConfirmed
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.black,
                                      ),
                                      onPressed: () => setState(
                                        () => _obscurePasswordConfirmed =
                                            !_obscurePasswordConfirmed,
                                      ),
                                    ),
                                    maxLength: 15,
                                  ),
                                ],

                                if (!_isRegisterMode && _isPasswordStep) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: _keepLoggedIn,
                                          activeColor: const Color(0xFF0D478C),
                                          onChanged: (value) => setState(
                                            () =>
                                                _keepLoggedIn = value ?? false,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () => setState(
                                          () => _keepLoggedIn = !_keepLoggedIn,
                                        ),
                                        child: Text(
                                          'Mantenha-me conectado',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],

                                const SizedBox(height: 24),
                                _buildActionButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        children: [
                          _footerTextLink('Esqueci a senha', () {}),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          _footerTextLink('Continuar sem conta', () {}),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -28,
                  left: 24,
                  right: 24,
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTabButton(
                            'Acessar conta',
                            _selectedTab == 0,
                            0,
                          ),
                        ),
                        Expanded(
                          child: _buildTabButton(
                            'Não tenho conta',
                            _selectedTab == 1,
                            1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: (value) => setState(() {}),
      style: GoogleFonts.inter(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      maxLength: maxLength ?? 15,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: GoogleFonts.inter(
          color: controller.text.isNotEmpty
              ? const Color(0xFF0D478C)
              : Colors.grey[500],
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          color: const Color(0xFF1876D2),
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.fromLTRB(16, 30, 16, 12),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(height: 0.8, fontSize: 12),
      ),
    );
  }

  Widget _buildActionButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (_isRegisterMode) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Usuário cadastrado com sucesso!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            setState(() {
              _selectedTab = 0;
              _isPasswordStep = false;
              _emailController.clear();
              _passwordController.clear();
              _confirmPasswordController.clear();
            });
          } else {
            context.go('/news');
          }
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_isRegisterMode) {
                  context.read<AuthBloc>().add(
                    RegisterSubmitted(
                      username: _emailController.text,
                      password: _passwordController.text,
                    ),
                  );
                } else if (!_isPasswordStep) {
                  setState(() => _isPasswordStep = true);
                } else {
                  context.read<AuthBloc>().add(
                    LoginSubmitted(
                      username: _emailController.text,
                      password: _passwordController.text,
                      keepLoggedIn: _keepLoggedIn,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1876D2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state is AuthLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    _isRegisterMode ? 'Cadastrar' : 'Entrar',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String label, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => setState(() {
        _selectedTab = index;
        _isPasswordStep = false;
        _formKey.currentState?.reset();
        _passwordController.clear();
        _confirmPasswordController.clear();
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1876D2) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _footerTextLink(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
        ),
      ),
    );
  }
}
