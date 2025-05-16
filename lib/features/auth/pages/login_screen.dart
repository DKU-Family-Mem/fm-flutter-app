import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart' as app_auth;
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null;
      });
      
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      
      print('로그인 시도 - 이메일: $email, 비밀번호 길이: ${password.length}');
      
      final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
      final success = await authProvider.signInWithEmailAndPassword(email, password);
      
      if (!mounted) return;
      
      if (!success) {
        setState(() {
          _errorMessage = authProvider.error ?? '로그인에 실패했습니다. 이메일과 비밀번호를 확인하세요.';
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!)),
        );
      }
      // 성공 시 AuthWrapper가 홈 화면으로 자동 이동
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _errorMessage = null;
    });
    
    final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithGoogle();
    
    if (!mounted) return;
    
    if (!success) {
      setState(() {
        _errorMessage = authProvider.error ?? 'Google 로그인에 실패했습니다.';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
    }
    // 성공 시 AuthWrapper가 홈 화면으로 자동 이동
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
                    SizedBox(height: size.height * 0.05),
                    
                    // 로그인 헤더 이미지 및 텍스트
                    _buildLoginHeader(),
                    
                    SizedBox(height: size.height * 0.03),
                    
                    // 로그인 폼
                    _buildLoginForm(authProvider),
                    
                    SizedBox(height: size.height * 0.03),
                    
                    // Google 로그인 버튼
                    _buildGoogleLoginButton(authProvider),
                    
                    // 회원가입으로 이동 버튼
                    _buildSignUpRedirect()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // 로그인 헤더 (로고와 텍스트)
  Widget _buildLoginHeader() {
    return Column(
      children: [
        // 앱 로고
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.family_restroom,
            size: 70,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 30),
        
        // 로그인 텍스트
        Text(
          '로그인',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          '가족과의 소통을 위해 로그인해주세요',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
  
  // 로그인 폼 (이메일, 비밀번호 입력 필드)
  Widget _buildLoginForm(app_auth.AuthProvider authProvider) {
    return Column(
      children: [
        // 이메일 입력필드
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: '이메일',
            prefixIcon: const Icon(Icons.person_outline),
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
        
        const SizedBox(height: 10),
        
        // 에러 메시지 표시
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ),
        
        const SizedBox(height: 20),
        
        // 로그인 버튼
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: authProvider.isLoading ? null : _signInWithEmailAndPassword,
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
                    '로그인',
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
  
  // Google 로그인 버튼
  Widget _buildGoogleLoginButton(app_auth.AuthProvider authProvider) {
    return Column(
      children: [
        const Text(
          '또는',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 20),
        
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.g_mobiledata, size: 24),  // Google 아이콘으로 교체 필요
            label: const Text(
              'Google 계정으로 로그인',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: authProvider.isLoading ? null : _signInWithGoogle,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  // 회원가입으로 이동 버튼
  Widget _buildSignUpRedirect() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '계정이 없으신가요?',
            style: TextStyle(color: Colors.grey),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SignupScreen(),
                ),
              );
            },
            child: Text(
              '회원가입',
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