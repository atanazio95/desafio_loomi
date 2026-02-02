// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ProfileDataSection extends StatelessWidget {
//   const ProfileDataSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       child: Column(
//         crossAxisAlignment:
//             CrossAxisAlignment.start, // Alinhamento à esquerda para os dados
//         children: [
//           const SizedBox(height: 32),

//           // --- RÓTULO E NOME ---
//           _buildDataField(
//             label: 'Nome',
//             value: 'João Silva', // Futuramente: state.user.name
//           ),

//           const SizedBox(height: 24),

//           // --- RÓTULO E EMAIL ---
//           _buildDataField(
//             label: 'E-mail',
//             value: 'joao.silva@email.com', // Futuramente: state.user.email
//           ),

//           const SizedBox(height: 48),

//           // --- BOTÃO DE AÇÃO: EDITAR ---
//           SizedBox(
//             width: double.infinity,
//             height: 56,
//             child: ElevatedButton(
//               onPressed: () => context.push('/edit-profile'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF0D478C), // Azul Nortus
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 elevation: 0,
//               ),
//               child: Text(
//                 'Editar perfil',
//                 style: GoogleFonts.spaceGrotesk(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),

//           const SizedBox(height: 16),

//           // --- BOTÃO DE AÇÃO: SAIR (TEXTO) ---
//           Center(
//             child: TextButton(
//               onPressed: () {
//                 // Lógica de Logout
//               },
//               child: Text(
//                 'Sair da conta',
//                 style: GoogleFonts.spaceGrotesk(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget auxiliar para manter o padrão de rótulo + valor
//   Widget _buildDataField({required String label, required String value}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label.toUpperCase(),
//           style: GoogleFonts.spaceGrotesk(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey[500],
//             letterSpacing: 1.2,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: GoogleFonts.spaceGrotesk(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: Colors.black,
//           ),
//         ),
//         const SizedBox(height: 8),
//         const Divider(height: 1),
//       ],
//     );
//   }
// }
