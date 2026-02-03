import 'package:desafio_loomi_flutter/core/presentation/custom_footer.dart';
import 'package:desafio_loomi_flutter/core/theme/responsive.dart';
import 'package:desafio_loomi_flutter/core/widgets/app_dropdown.dart';
import 'package:desafio_loomi_flutter/core/widgets/app_text_field.dart';
import 'package:desafio_loomi_flutter/core/widgets/form_section_header.dart';
import 'package:desafio_loomi_flutter/features/user/domain/entities/user_entity.dart';
import 'package:desafio_loomi_flutter/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _languages = [
    'Português - BR',
    'English - US',
    'Español - ES',
  ];

  final List<String> _dateFormats = ['DD/MM/AA', 'MM/DD/AA', 'AA-MM-DD'];

  final List<String> _timezones = [
    'Brasília - DF ( GMT-3 )',
    'New York - USA ( GMT-5 )',
    'London - UK ( GMT+0 )',
  ];

  String? _selectedLanguage;
  String? _selectedDateFormat;
  String? _selectedTimezone;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _zipCodeController;
  late TextEditingController _streetController;
  late TextEditingController _numberController;
  late TextEditingController _neighborhoodController;
  late TextEditingController _complementController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;

  @override
  void initState() {
    super.initState();
    _initControllers();

    _selectedLanguage = _languages[0];
    _selectedDateFormat = _dateFormats[0];
    _selectedTimezone = _timezones[0];

    final state = context.read<UserBloc>().state;
    if (state is UserLoaded) {
      _populateFields(state.user);
    }
  }

  void _initControllers() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _zipCodeController = TextEditingController();
    _streetController = TextEditingController();
    _numberController = TextEditingController();
    _neighborhoodController = TextEditingController();
    _complementController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
  }

  void _populateFields(UserEntity user) {
    _nameController.text = user.name;
    _emailController.text = user.email;

    if (user.language == 'pt-BR')
      _selectedLanguage = 'Português - BR';
    else if (user.language == 'en-US')
      _selectedLanguage = 'English - US';
    else if (user.language == 'es-ES')
      _selectedLanguage = 'Español - ES';
    else if (_languages.contains(user.language))
      _selectedLanguage = user.language;

    if (_dateFormats.contains(user.dateFormat)) {
      _selectedDateFormat = user.dateFormat;
    }

    if (user.timezone == 'America/Sao_Paulo')
      _selectedTimezone = 'Brasília - DF ( GMT-3 )';
    else if (user.timezone == 'America/New_York')
      _selectedTimezone = 'New York - USA ( GMT-5 )';
    else if (user.timezone == 'Europe/London')
      _selectedTimezone = 'London - UK ( GMT+0 )';
    else if (_timezones.contains(user.timezone))
      _selectedTimezone = user.timezone;

    if (user.address != null) {
      _zipCodeController.text = user.address!.zipCode;
      _streetController.text = user.address!.street;
      _numberController.text = user.address!.number;
      _neighborhoodController.text = user.address!.neighborhood;
      _complementController.text = user.address!.complement;
      _cityController.text = user.address!.city;
      _stateController.text = user.address!.state;
    }

    if (mounted) setState(() {});
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<UserBloc>().state;
      if (state is! UserLoaded) return;

      String apiLanguage = 'pt-BR';
      if (_selectedLanguage == 'English - US') apiLanguage = 'en-US';
      if (_selectedLanguage == 'Español - ES') apiLanguage = 'es-ES';

      String apiTimezone = 'America/Sao_Paulo';
      if (_selectedTimezone == 'New York - USA ( GMT-5 )')
        apiTimezone = 'America/New_York';
      if (_selectedTimezone == 'London - UK ( GMT+0 )')
        apiTimezone = 'Europe/London';

      final newAddress = AddressEntity(
        zipCode: _zipCodeController.text,
        country: state.user.address?.country ?? 'Brasil',
        street: _streetController.text,
        number: _numberController.text,
        complement: _complementController.text,
        neighborhood: _neighborhoodController.text,
        city: _cityController.text,
        state: _stateController.text,
      );

      final updatedUser = UserEntity(
        id: state.user.id,
        name: _nameController.text,
        email: _emailController.text,
        language: apiLanguage,
        dateFormat: _selectedDateFormat ?? 'DD/MM/AA',
        timezone: apiTimezone,
        address: newAddress,
      );

      context.read<UserBloc>().add(UpdateUserProfile(updatedUser));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _zipCodeController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _complementController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brandBlue = Color(0xFF1876D2);
    const textBlack = Color(0xFF0B1125);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Voltar',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoaded && state is! UserUpdated) {
            _populateFields(state.user);
          }

          if (state is UserUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Dados atualizados com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) context.pop();
            });
          }

          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.horizontalPadding(context),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configurações de usuário',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                          color: textBlack,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Language, timezone and date section
                      FormSectionHeader(
                        title: 'Ajustes de idioma, fuso horário e data',
                      ),
                      const SizedBox(height: 16),
                      AppDropdown(
                        label: 'Idioma',
                        value: _selectedLanguage,
                        items: _languages,
                        onChanged: (val) =>
                            setState(() => _selectedLanguage = val),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AppDropdown(
                              label: 'Formatação de data',
                              value: _selectedDateFormat,
                              items: _dateFormats,
                              onChanged: (val) =>
                                  setState(() => _selectedDateFormat = val),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppDropdown(
                              label: 'Fuso horário',
                              value: _selectedTimezone,
                              items: _timezones,
                              onChanged: (val) =>
                                  setState(() => _selectedTimezone = val),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(color: Color(0xFFE0E0E0)),
                      const SizedBox(height: 24),

                      // User info section
                      AppTextField(
                        label: 'Nome Completo',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'E-mail',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 24),
                      const Divider(color: Color(0xFFE0E0E0)),
                      const SizedBox(height: 24),

                      // Address section
                      AppTextField(
                        label: 'CEP',
                        controller: _zipCodeController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              label: 'Rua',
                              controller: _streetController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: AppTextField(
                              label: 'Número',
                              controller: _numberController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Logradouro',
                        controller: _neighborhoodController,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Complemento',
                        controller: _complementController,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              label: 'Cidade',
                              controller: _cityController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: AppTextField(
                              label: 'UF',
                              controller: _stateController,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 48),

                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          final isLoading = state is UserLoading;
                          return Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () => context.pop(),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(color: textBlack),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                    ),
                                    child: Text(
                                      'Cancelar',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: textBlack,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _onSubmit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: brandBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            'Salvar',
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Responsive.footerTopSpacing(context)),
              const CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
