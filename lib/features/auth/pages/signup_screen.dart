import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart' as app_auth;
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
      
      final success = await authProvider.createUserWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error ?? '회원가입에 실패했습니다.')),
        );
      }
      // 성공 시 AuthWrapper가 홈 화면으로 자동 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<app_auth.AuthProvider>(context);
    
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.03),
                    
                    // 회원가입 헤더 및 텍스트
                    _buildSignupHeader(),
                    
                    SizedBox(height: size.height * 0.03),
                    
                    // 회원가입 폼
                    _buildSignupForm(authProvider),
                    
                    SizedBox(height: size.height * 0.02),
                    
                    // 로그인으로 이동 버튼
                    _buildLoginRedirect()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // 회원가입 헤더
  Widget _buildSignupHeader() {
    return Column(
      children: [
        // 앱 로고
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.family_restroom,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        
        // 회원가입 텍스트
        Text(
          '회원가입',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          '가족과 함께하기 위한 계정을 만들어보세요',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
  
  // 회원가입 폼
  Widget _buildSignupForm(app_auth.AuthProvider authProvider) {
    return Column(
      children: [
        // 이메일 입력필드
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: '이메일',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty || !value.contains('@')) {
              return '유효한 이메일을 입력하세요';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 20),
        
        // 비밀번호 입력필드
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: '비밀번호',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 6) {
              return '비밀번호는 6자 이상이어야 합니다';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 20),
        
        // 비밀번호 확인 입력필드
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          decoration: InputDecoration(
            hintText: '비밀번호 확인',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '비밀번호를 다시 입력하세요';
            }
            if (value != _passwordController.text) {
              return '비밀번호가 일치하지 않습니다';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 30),
        
        // 회원가입 버튼
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: authProvider.isLoading ? null : _signUpWithEmailAndPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
            child: authProvider.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    '회원가입',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
  
  // 로그인으로 이동 버튼
  Widget _buildLoginRedirect() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '이미 계정이 있으신가요?',
            style: TextStyle(color: Colors.grey),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: Text(
              '로그인',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 