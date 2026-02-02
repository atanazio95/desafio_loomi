import '../../features/news/data/models/news_model.dart';

class NewsMock {
  /// Gera uma lista de notícias simuladas baseada na página solicitada.
  /// Isso permite testar a paginação infinita ("Ver mais").
  static List<NewsModel> getNews(int page) {
    // Prefixo para garantir IDs únicos (ex: "p1_")
    final String p = "p$page";

    // --- MOCK DE NOTÍCIAS RELACIONADAS (Para aparecer na tela de Detalhes) ---
    final List<NewsModel> relatedMock = [
      const NewsModel(
        id: 'rel_1',
        title: 'Startups de IA recebem investimento recorde',
        category: 'Tecnologia',
        author: 'Ana Silva',
        summary: 'O setor de inteligência artificial continua aquecido...',
        description: 'Descrição completa da notícia relacionada...',
        datePublished: '2025-10-20T10:30:00Z',
        imageUrl:
            'https://images.unsplash.com/photo-1485827404703-89b55fcc595e',
        relatedNews: [],
        isFavorite: false,
      ),
      const NewsModel(
        id: 'rel_2',
        title: 'Futuro do trabalho remoto em 2026',
        category: 'Carreira',
        author: 'João Souza',
        summary: 'Empresas reavaliam modelos híbridos.',
        description: 'Descrição completa...',
        datePublished: '2025-10-19T15:00:00Z',
        imageUrl:
            'https://images.unsplash.com/photo-1593642632823-8f78536788c6',
        relatedNews: [],
        isFavorite: true, // Testando estrela amarela
      ),
      const NewsModel(
        id: 'rel_3',
        title: 'Sustentabilidade no Agronegócio',
        category: 'Agro',
        author: 'Marcos Dias',
        summary: 'Novas tecnologias no campo.',
        description: 'Descrição completa...',
        datePublished: '2025-10-18T09:00:00Z',
        imageUrl:
            'https://images.unsplash.com/photo-1625246333195-78d9c38ad449',
        relatedNews: [],
        isFavorite: false,
      ),
    ];

    // --- LISTA PRINCIPAL (Dinâmica por Página) ---
    // Retornamos 8 itens por página para preencher bem a tela
    return [
      // ITEM 1
      NewsModel(
        id: '${p}_1',
        title: page == 1
            ? 'Inovação: O impacto do 5G na indústria automotiva'
            : 'Página $page: Avanços da Computação Quântica',
        category: 'Inovação',
        author: 'Carlos Tech',
        summary:
            'A conectividade ultrarrápida permitirá carros autônomos mais seguros e eficientes nas cidades inteligentes.',
        description:
            'O 5G não é apenas internet rápida para celulares. Na indústria automotiva, ele representa a espinha dorsal da comunicação V2X (Vehicle-to-Everything)...',
        datePublished: '2025-10-21T08:00:00Z',
        // Alterna imagem baseada na página para dar sensação de novidade
        imageUrl: page % 2 != 0
            ? 'https://images.unsplash.com/photo-1519389950473-47ba0277781c'
            : 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b',
        relatedNews: relatedMock,
        isFavorite: false,
      ),

      // ITEM 2
      NewsModel(
        id: '${p}_2',
        title: page == 1
            ? 'Design Minimalista: Menos é mais na interface'
            : 'Página $page: Novas Tendências de UI/UX',
        category: 'Design',
        author: 'Sofia UX',
        summary:
            'Como limpar a interface melhora a conversão e a experiência do usuário em aplicativos móveis.',
        description:
            'O minimalismo não é apenas uma escolha estética, é uma ferramenta funcional para reduzir a carga cognitiva...',
        datePublished: '2025-10-21T12:00:00Z',
        imageUrl: page % 2 != 0
            ? 'https://images.unsplash.com/photo-1561070791-2526d30994b5'
            : 'https://images.unsplash.com/photo-1586717791821-3f44a5638d0f',
        relatedNews: relatedMock,
        isFavorite: false, // Vamos deixar false para testar o clique
      ),

      // ITEM 3
      NewsModel(
        id: '${p}_3',
        title: 'Transformação Digital no Varejo (Pág $page)',
        category: 'Mercado',
        author: 'Marcos Vendas',
        summary: 'O varejo físico se reinventa com experiências digitais.',
        description:
            'Lojas conceito estão usando realidade aumentada para atrair clientes...',
        datePublished: '2025-10-20T10:00:00Z',
        imageUrl:
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
        relatedNews: relatedMock,
        isFavorite: false,
      ),

      // ITEM 4
      NewsModel(
        id: '${p}_4',
        title: 'Cibersegurança: Protegendo dados na nuvem (Pág $page)',
        category: 'Segurança',
        author: 'Hacker White',
        summary: 'Com o aumento de ataques, empresas blindam seus servidores.',
        description:
            'A segurança de dados nunca foi tão crítica quanto agora...',
        datePublished: '2025-10-19T14:20:00Z',
        imageUrl: 'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb',
        relatedNews: relatedMock,
        isFavorite: false,
      ),

      // ITEM 5
      NewsModel(
        id: '${p}_5',
        title: 'O crescimento das Fintechs no Brasil (Pág $page)',
        category: 'Finanças',
        author: 'Ana Money',
        summary: 'Bancos digitais ganham cada vez mais espaço no mercado.',
        description: 'A desburocratização dos serviços financeiros...',
        datePublished: '2025-10-18T09:15:00Z',
        imageUrl:
            'https://images.unsplash.com/photo-1563986768609-322da13575f3',
        relatedNews: relatedMock,
        isFavorite: false,
      ),

      // ITEM 6
      NewsModel(
        id: '${p}_6',
        title: 'Energia Limpa: O futuro é renovável (Pág $page)',
        category: 'Sustentabilidade',
        author: 'Verde Green',
        summary: 'Investimentos em energia solar e eólica batem recordes.',
        description: 'A transição energética está acelerada...',
        datePublished: '2025-10-17T16:45:00Z',
        imageUrl:
            'https://images.unsplash.com/photo-1509391366360-2e959784a276',
        relatedNews: relatedMock,
        isFavorite: false,
      ),

      // ITEM 7
      NewsModel(
        id: '${p}_7',
        title: 'Educação 4.0: Tecnologia na sala de aula (Pág $page)',
        category: 'Educação',
        author: 'Prof. Tech',
        summary: 'Como tablets e IA estão personalizando o ensino.',
        description: 'O modelo tradicional de ensino está sendo desafiado...',
        datePublished: '2025-10-16T11:30:00Z',
        imageUrl:
            'https://images.unsplash.com/photo-1503676260728-1c00da094a0b',
        relatedNews: relatedMock,
        isFavorite: false,
      ),

      // ITEM 8
      NewsModel(
        id: '${p}_8',
        title: 'Logística Inteligente e Drones (Pág $page)',
        category: 'Logística',
        author: 'Entrega Rápida',
        summary: 'Entregas autônomas já são realidade em alguns países.',
        description: 'A última milha da entrega está sendo revolucionada...',
        datePublished: '2025-10-15T08:00:00Z',
        imageUrl:
            'https://images.unsplash.com/photo-1586880244406-556ebe35f288',
        relatedNews: relatedMock,
        isFavorite: false,
      ),
    ];
  }
}
