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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _selectedTab = 0;
  bool _isPasswordStep = false;
  bool _keepLoggedIn = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const primaryBlue = Color(0xFF1876D2);
    const darkBlueNortus = Color(0xFF0D478C);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. MARCA D'ÁGUA (Escudo)
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

          // 2. TÍTULO NORTUS
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

          // 3. CARD DINÂMICO
          // --- CARD DINÂMICO E SELETOR ---
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // 1. O CARD AZUL
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    60,
                    24,
                    40,
                  ), // Ajustado padding inferior
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
                      // CONTAINER BRANCO (Inputs)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _emailController,
                                enabled: true,
                                decoration: _inputDecoration(
                                  'Digite seu e-mail',
                                ),
                              ),
                              if (_isPasswordStep) ...[
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration:
                                      _inputDecoration(
                                        'Digite sua senha',
                                      ).copyWith(
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
                                      ),
                                ),
                                if (_isPasswordStep) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: _keepLoggedIn,
                                          activeColor: const Color(
                                            0xFF0D478C,
                                          ), // O azul escuro que você definiu
                                          onChanged: (value) {
                                            setState(
                                              () => _keepLoggedIn =
                                                  value ?? false,
                                            );
                                          },
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
                              ],
                              const SizedBox(height: 24),
                              _buildActionButton(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // --- RODAPÉ COM LINKS (ADIÇÃO SOLICITADA) ---
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        children: [
                          _footerTextLink('Esqueci a senha', () {
                            // Lógica de recuperar senha
                          }),
                          // O ponto separador
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          _footerTextLink('Continuar sem conta', () {
                            // Rota do seu desafio
                          }),
                        ],
                      ),
                    ],
                  ),
                ),

                // 2. SELETOR DE ABAS (Fica na frente)
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildActionButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/news'); // Navega se logar com sucesso
        } else if (state is AuthError) {
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
            // No seu _buildActionButton dentro da LoginPage:
            onPressed: () {
              if (_isPasswordStep) {
                context.read<AuthBloc>().add(
                  LoginSubmitted(
                    username: _emailController.text,
                    password: _passwordController.text,
                    keepLoggedIn:
                        _keepLoggedIn, // A variável que controlamos com o setState do Checkbox
                  ),
                );
              } else {
                setState(() => _isPasswordStep = true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1876D2),
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
                    'Entrar',
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
      onTap: () => setState(() => _selectedTab = index),
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
