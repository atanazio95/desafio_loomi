abstract class NewsDetailsEvent {}

class GetNewsDetails extends NewsDetailsEvent {
  final String id;
  GetNewsDetails(this.id);
}

// Adicione este evento
class ToggleFavoriteNews extends NewsDetailsEvent {}
