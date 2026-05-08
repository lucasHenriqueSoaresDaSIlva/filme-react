import 'package:flutter/material.dart';
import 'detalhes_filme.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Filmes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TelaPrincipal(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  // Controlador do campo de texto
  final TextEditingController _controllerFilme = TextEditingController();
  
  // Lista de filmes
  List<String> _listaFilmes = [];
  
  // Cor de fundo (padrão: branco)
  Color _corFundo = Colors.white;
  
  // Cores disponíveis para alternar
  final List<Color> _coresPalheta = [
    Colors.white,
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.red.shade50,
    Colors.yellow.shade50,
    Colors.purple.shade50,
    Colors.orange.shade50,
  ];
  
  int _indiceCorAtual = 0;

  // Função para adicionar filme
  void _adicionarFilme() {
    String nomeFilme = _controllerFilme.text.trim();
    
    if (nomeFilme.isEmpty) {
      // Exibe mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite o nome de um filme!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _listaFilmes.add(nomeFilme);
      _controllerFilme.clear(); // Limpa o campo
    });
    
    // Feedback de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$nomeFilme" foi adicionado!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Função para remover filme
  void _removerFilme(int index) {
    String filmeRemovido = _listaFilmes[index];
    
    setState(() {
      _listaFilmes.removeAt(index);
    });
    
    // Feedback de remoção
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$filmeRemovido" foi removido!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Função para alterar cor de fundo
  void _alterarCorFundo() {
    setState(() {
      _indiceCorAtual = (_indiceCorAtual + 1) % _coresPalheta.length;
      _corFundo = _coresPalheta[_indiceCorAtual];
    });
  }

  // Função para navegar para tela de detalhes
  void _navegarParaDetalhes(String nomeFilme) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDetalhes(nomeFilme: nomeFilme),
      ),
    );
  }

  @override
  void dispose() {
    _controllerFilme.dispose(); // Libera recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catálogo de Filmes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // Botão para alterar cor de fundo na AppBar
          IconButton(
            onPressed: _alterarCorFundo,
            icon: const Icon(Icons.palette),
            tooltip: 'Alterar cor de fundo',
          ),
        ],
      ),
      body: Container(
        color: _corFundo,
        child: Column(
          children: [
            // Área de entrada de dados
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    '🎬 Adicionar Novo Filme',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controllerFilme,
                          decoration: InputDecoration(
                            hintText: 'Digite o nome do filme...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.movie),
                          ),
                          onSubmitted: (_) => _adicionarFilme(), // Enter adiciona
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _adicionarFilme,
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Botão alternativo para alterar cor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                onPressed: _alterarCorFundo,
                icon: const Icon(Icons.color_lens),
                label: const Text('Alterar Cor de Fundo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Título da lista
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.list, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Meus Filmes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Total: ',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 5),
            
            // Lista de filmes
            Expanded(
              child: _listaFilmes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.movie_filter,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum filme cadastrado',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Adicione filmes usando o campo acima',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _listaFilmes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              _listaFilmes[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _removerFilme(index),
                              tooltip: 'Remover filme',
                            ),
                            onTap: () => _navegarParaDetalhes(_listaFilmes[index]),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}