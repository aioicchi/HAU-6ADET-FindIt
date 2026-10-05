enum ClaimStatus { pending, approved, rejected }

/// Someone saying a found item is theirs, with their answer to the finder's question.
class Claim {
  Claim({
    required this.id,
    required this.itemId,
    required this.claimant,
    required this.answer,
    required this.time,
    required this.fromMe,
    this.status = ClaimStatus.pending,
  });

  factory Claim.fromJson(Map<String, dynamic> j) => Claim(
        id: j['id'] as String,
        itemId: j['itemId'] as String,
        claimant: j['claimant'] as String,
        answer: j['answer'] as String,
        time: DateTime.parse(j['time'] as String),
        fromMe: j['fromMe'] as bool,
        status: ClaimStatus.values.byName(j['status'] as String),
      );

  final String id;
  final String itemId;

  /// Display name of whoever made the claim.
  final String claimant;
  final String answer;
  final DateTime time;

  /// True when the signed-in user made this claim.
  final bool fromMe;
  ClaimStatus status;

  bool get isPending => status == ClaimStatus.pending;

  Map<String, dynamic> toJson() => {
        'id': id,
        'itemId': itemId,
        'claimant': claimant,
        'answer': answer,
        'time': time.toIso8601String(),
        'fromMe': fromMe,
        'status': status.name,
      };
}
