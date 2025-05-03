import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import 'signup_screen.dart'; // 회원가입 화면 임포트

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final authService = Provider.of<AuthService>(context, listen: false);
      
      try {
        final userCredential = await authService.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        
        if (!mounted) return; // mounted 체크 추가
        
        if (userCredential == null) {
          // 로그인 실패 시 오류 메시지 표시 (예: SnackBar)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인에 실패했습니다. 이메일 또는 비밀번호를 확인하세요.')),
          );
        }
        // 성공 시 AuthWrapper가 홈 화면으로 이동시킴
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userCredential = await authService.signInWithGoogle();
      
      if (!mounted) return; // mounted 체크 추가
      
      if (userCredential == null) {
        // 로그인 취소 또는 실패 시
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google 로그인에 실패했습니다.'))
        );
      }
      // 성공 시 AuthWrapper가 홈 화면으로 이동시킴
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              // 키보드 오버플로우 방지
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: '이메일'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return '유효한 이메일을 입력하세요.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: '비밀번호'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return '비밀번호는 6자 이상이어야 합니다.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _signInWithEmailAndPassword,
                        child: const Text('이메일로 로그인'),
                      ),
                  const SizedBox(height: 12),
                  _isLoading
                      ? const SizedBox.shrink() // 로딩 중에는 숨김
                      : ElevatedButton.icon(
                        icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 24.0),
                        label: const Text("Google 계정으로 로그인"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          minimumSize: const Size(double.infinity, 50),
                          elevation: 2,
                        ),
                        onPressed: _signInWithGoogle,
                      ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const SizedBox.shrink()
                      : TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            // 현재 화면을 스택에서 제거하고 이동
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text('계정이 없으신가요? 회원가입'),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
