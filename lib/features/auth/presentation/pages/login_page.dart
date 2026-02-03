import 'package:desafio_loomi_flutter/core/theme/app_colors.dart';
import 'package:desafio_loomi_flutter/core/theme/responsive.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/widgets/footer_text_link.dart';
import 'package:desafio_loomi_flutter/features/auth/presentation/widgets/tab_button.dart';
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
    final padH = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
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
                color: AppColors.labelHint,
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
                  padding: EdgeInsets.fromLTRB(padH, 60, padH, 40),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDark,
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
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
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
                                AuthTextFormField(
                                  controller: _emailController,
                                  label: 'Digite seu E-mail',
                                  validator: _validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  maxLength: 64,
                                  onChanged: () => setState(() {}),
                                ),

                                if (_isRegisterMode || _isPasswordStep) ...[
                                  const SizedBox(height: 16),
                                  AuthTextFormField(
                                    controller: _passwordController,
                                    label: 'Digite a Senha',
                                    showLabel: false,
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
                                    onChanged: () => setState(() {}),
                                  ),
                                ],

                                if (_isRegisterMode) ...[
                                  const SizedBox(height: 16),
                                  AuthTextFormField(
                                    controller: _confirmPasswordController,
                                    label: 'Confirme Senha',
                                    showLabel: false,
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
                                    onChanged: () => setState(() {}),
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
                                          activeColor: AppColors.primaryDark,
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
                                BlocConsumer<AuthBloc, AuthState>(
                                  listener: (context, state) {
                                    if (state is AuthAuthenticated) {
                                      if (_isRegisterMode) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Usuário cadastrado com sucesso!',
                                            ),
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
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(state.message),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    return AuthPrimaryButton(
                                      label: _isRegisterMode
                                          ? 'Cadastrar'
                                          : 'Entrar',
                                      isLoading: state is AuthLoading,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          if (_isRegisterMode) {
                                            context.read<AuthBloc>().add(
                                              RegisterSubmitted(
                                                username: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                              ),
                                            );
                                          } else if (!_isPasswordStep) {
                                            setState(
                                              () => _isPasswordStep = true,
                                            );
                                          } else {
                                            context.read<AuthBloc>().add(
                                              LoginSubmitted(
                                                username: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                                keepLoggedIn: _keepLoggedIn,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    );
                                  },
                                ),
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
                          FooterTextLink(
                            label: 'Esqueci a senha',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Função não disponível'),
                                ),
                              );
                            },
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          FooterTextLink(
                            label: 'Continuar sem conta',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Função não disponível'),
                                ),
                              );
                            },
                          ),
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
                          color: AppColors.textPrimary.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TabButton(
                            label: 'Acessar conta',
                            isSelected: _selectedTab == 0,
                            onTap: () => setState(() {
                              _selectedTab = 0;
                              _isPasswordStep = false;
                              _formKey.currentState?.reset();
                              _passwordController.clear();
                              _confirmPasswordController.clear();
                            }),
                          ),
                        ),
                        Expanded(
                          child: TabButton(
                            label: 'Não tenho conta',
                            isSelected: _selectedTab == 1,
                            onTap: () => setState(() {
                              _selectedTab = 1;
                              _isPasswordStep = false;
                              _formKey.currentState?.reset();
                              _passwordController.clear();
                              _confirmPasswordController.clear();
                            }),
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
}
