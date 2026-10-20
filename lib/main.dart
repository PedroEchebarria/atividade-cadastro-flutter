import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema dark com vermelho para dar uma cara mais agressiva e moderna
    return MaterialApp(
      title: 'Cadastro do Usuário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          surface: Color(0xFF1E1E1E),
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const CadastroPage(),
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  
  bool _ocultaSenha = true;
  bool _ocultaConfirma = true;

  @override
  void dispose() {
    _senhaController.dispose();
    super.dispose();
  }

  void _enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cadastro realizado com sucesso!', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ops! Verifique os campos inválidos.', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red.shade900,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Usuário', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textInputAction: TextInputAction.next,
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Nome obrigatório' : null,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'E-mail obrigatório';
                  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!regex.hasMatch(val)) return 'Formato de e-mail inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Apenas números',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val == null || val.isEmpty) return 'CPF obrigatório';
                  if (val.length != 11) return 'O CPF precisa ter 11 dígitos';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: 'DDD + Número',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Telefone obrigatório';
                  if (val.length < 10 || val.length > 11) return 'Deve ter 10 ou 11 dígitos';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_ocultaSenha ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _ocultaSenha = !_ocultaSenha),
                  ),
                ),
                obscureText: _ocultaSenha,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Senha obrigatória';
                  if (val.length < 6) return 'Mínimo de 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(_ocultaConfirma ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _ocultaConfirma = !_ocultaConfirma),
                  ),
                ),
                obscureText: _ocultaConfirma,
                textInputAction: TextInputAction.done,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Confirmação obrigatória';
                  if (val != _senhaController.text) return 'As senhas não batem';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _enviarFormulario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 2,
                  ),
                  child: const Text(
                    'FINALIZAR CADASTRO',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
