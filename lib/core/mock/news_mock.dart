import '../../features/news/data/models/news_model.dart';

class NewsMock {
  static List<NewsModel> getNews() {
    // --- 1. PREPARANDO AS NOTÍCIAS RELACIONADAS (Baseado no JSON id: 8) ---
    final List<NewsModel> relatedList = [
      const NewsModel(
        id: '8',
        title: "Neque Porro Quisquam Est Qui Dolorem",
        imageUrl: "https://picsum.photos/800/400?random=8",
        category: "Tecnologia", // Pego do array categories[0]
        author: "Chris Martin", // Pego do array authors[0].name
        summary:
            "Empreendedor e redator de tecnologia...", // Fallback pois o JSON relacionado é resumido
        description: "Conteúdo completo da notícia relacionada...",
        datePublished: "2025-10-14T14:05:00Z",
        relatedNews: [],
        isFavorite: false,
      ),
      const NewsModel(
        id: '9',
        title: "Quis Autem Vel Eum Iure Reprehenderit",
        imageUrl: "https://picsum.photos/800/400?random=9",
        category: "Inovação",
        author: "Autor Desconhecido",
        summary: "Resumo da notícia lida também...",
        description: "Descrição completa...",
        datePublished: "2025-10-15T10:00:00Z",
        relatedNews: [],
        isFavorite: true,
      ),
      const NewsModel(
        id: '10',
        title: "Excepteur Sint Occaecat Cupidatat",
        imageUrl: "https://picsum.photos/800/400?random=10",
        category: "Startups",
        author: "Jane Doe",
        summary: "Mais uma notícia relacionada para testar o scroll.",
        description: "Descrição...",
        datePublished: "2025-10-16T09:30:00Z",
        relatedNews: [],
        isFavorite: false,
      ),
    ];

    // --- 2. LISTA PRINCIPAL (Baseado no JSON id: 1) ---
    // Vou replicar o item algumas vezes mudando o ID para encher a tela
    return [
      // ITEM 1 (O Exato do seu JSON)
      NewsModel(
        id: '1',
        title: "Lorem Ipsum Dolor Sit Amet",
        // Mapeando image.src para imageUrl
        imageUrl: "https://picsum.photos/800/400?random=1",
        // Mapeando categories[0] para category
        category: "Tecnologia",
        // Mapeando authors[0].name para author
        author: "John Doe",
        // Mapeando newsResume para summary
        summary:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam...",
        // Campo description
        description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse consequat, augue vel convallis volutpat, eros enim porta purus, sed imperdiet neque lorem sit amet nulla. Integer vel facilisis nunc.",
        datePublished: "2025-10-21T12:00:00Z",
        relatedNews: relatedList, // Injetando os relacionados aqui
        isFavorite: false,
      ),

      // ITEM 2 (Variação)
      NewsModel(
        id: '2',
        title: "Consectetur Adipiscing Elit Sed Do",
        imageUrl: "https://picsum.photos/800/400?random=2",
        category: "Inovação",
        author: "Maria Silva",
        summary:
            "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
        description:
            "Descrição completa da segunda notícia para testar a navegação e leitura.",
        datePublished: "2025-10-20T15:30:00Z",
        relatedNews: relatedList,
        isFavorite: true, // Testar estrela amarela na home
      ),

      // ITEM 3 (Variação)
      NewsModel(
        id: '3',
        title: "Ullamco Laboris Nisi Ut Aliquip",
        imageUrl: "https://picsum.photos/800/400?random=3",
        category: "Negócios",
        author: "John Doe",
        summary:
            "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        description:
            "Mais detalhes sobre negócios e tecnologia neste artigo completo.",
        datePublished: "2025-10-19T08:45:00Z",
        relatedNews: relatedList,
        isFavorite: false,
      ),

      // ITEM 4 (Variação)
      NewsModel(
        id: '4',
        title: "Duis Aute Irure Dolor In Reprehenderit",
        imageUrl: "https://picsum.photos/800/400?random=4",
        category: "Mobile",
        author: "Carlos Tech",
        summary:
            "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        description:
            "A revolução mobile continua avançando com novos frameworks.",
        datePublished: "2025-10-18T11:20:00Z",
        relatedNews: relatedList,
        isFavorite: false,
      ),
    ];
  }
}
