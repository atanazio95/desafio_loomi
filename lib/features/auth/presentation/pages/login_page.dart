import 'package:flutter/material.dart';
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
  bool _isPasswordStep = false; // Controla se estamos na fase da senha

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
              padding: EdgeInsets.fromLTRB(24, size.height * 0.08, 24, 0),
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
                              _buildFieldLabel('E-mail'),
                              TextFormField(
                                controller: _emailController,
                                enabled: !_isPasswordStep,
                                decoration: _inputDecoration(
                                  'Digite seu e-mail',
                                ),
                              ),
                              if (_isPasswordStep) ...[
                                const SizedBox(height: 20),
                                _buildFieldLabel('Senha'),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  autofocus: true,
                                  decoration: _inputDecoration(
                                    'Digite sua senha',
                                  ),
                                ),
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

  // Métodos Auxiliares para limpar o código
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: const Color(0xFF0D478C),
          fontWeight: FontWeight.bold,
        ),
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
    const darkBlueNortus = Color(0xFF0D478C);

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          // Se ainda não estiver na etapa da senha e o e-mail não estiver vazio
          if (!_isPasswordStep && _emailController.text.isNotEmpty) {
            setState(() => _isPasswordStep = true);
          } else if (_isPasswordStep) {
            // AQUI: Lógica final de autenticação (ex: chamada ao Bloc ou API)
            print("Tentando logar com: ${_emailController.text}");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: darkBlueNortus, // Cor exata: #0D478C
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          _isPasswordStep ? 'Entrar' : 'Próximo',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D478C) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : const Color(0xFF0D478C),
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
